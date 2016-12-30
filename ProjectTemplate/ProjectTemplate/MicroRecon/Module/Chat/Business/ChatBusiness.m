//
//  ChatBusiness.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define StateMessage_FailState dict[kXMNMessageConfigurationSendStateKey] && [dict[kXMNMessageConfigurationSendStateKey] isEqualToString:@"2"]

#import "ChatBusiness.h"
#import "UserChatModel.h"
#import "UserlistModel.h"
#import "XMNChatUntiles.h"
#import "ICometModel.h"
#import "VideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation ChatBusiness


//绘制图片水印
+ (UIImage *)addVideoLogo:(UIImage *)image videoTime:(NSString *)videoTimeStr videoSize:(NSString *)videoSizeStr {
    ZEBLog(@"videoTime is %@, videoSize is %@", videoTimeStr, videoSizeStr);
    UIImage *logo = [UIImage imageNamed:@"chat_video_player_icon"];
    CGFloat w = 480.f;
    CGFloat h = 640.f;
    
    CGFloat logoWidth = 90.f;
    CGFloat logoHeight = 90.f;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    CGContextDrawImage(context, CGRectMake((w-logoWidth)*0.5, (h-logoHeight)*0.5, logoWidth, logoHeight), [logo CGImage]);
    
    // 添加文字
    CGFloat margin = 45.f;
    CGFloat fontSize = 30.f;
    char* videoTime = (char*)[videoTimeStr cStringUsingEncoding:NSASCIIStringEncoding];
    char* videoSize = (char*)[videoSizeStr cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Helvetica", fontSize, kCGEncodingMacRoman);//设置字体的大小
    CGContextSetTextDrawingMode(context, kCGTextFill);//设置字体绘制方式
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);//设置字体绘制的颜色
    CGContextShowTextAtPoint(context, margin, margin*2, videoTime, strlen(videoTime));//设置字体绘制的位置
    CGContextShowTextAtPoint(context, w-strlen(videoSize)*fontSize, margin*2, videoSize, strlen(videoSize));//设置字体绘制的位置
    
    //获得添加水印后的图片
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    
}
+ (NSUInteger)durationWithVideo:(NSURL *)videoUrl{
    if (!videoUrl) {
        return 0;
    }
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}
#pragma mark - Video Methods
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    int minute = 0, second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    if (second >= 60) {
        int index = second / 60;
        minute = index;
        second = second - index*60;
    }
    // 视频时长
    NSString *videoTime = [NSString stringWithFormat:@"%02d:%02d",minute, second];
    
    NSArray *tracks = [urlAsset tracks];
    float estimatedSize = 0.0 ;
    for (AVAssetTrack * track in tracks) {
        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
        float seconds = CMTimeGetSeconds([track timeRange].duration);
        estimatedSize += seconds * rate;
    }
    float sizeInMB = estimatedSize / 1024 / 1024;
    // 视频文件大小
    NSString *videoSize = [NSString stringWithFormat:@"%.2fM", sizeInMB];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    if (error == nil)
    {
        return [ChatBusiness addVideoLogo:[UIImage imageWithCGImage:imageRef] videoTime:videoTime videoSize:videoSize];
    }
    return nil;
}
#pragma mark -
#pragma mark 将拉取的历史消息中带有删除，添加好友的数据将data格式化
+ (void)backChatModel:(chatModel *)iModel {
    
    if ([@"A" isEqualToString:iModel.MSG.MTYPE]) {
       
        //不做处理直接用
    }else {
        __block UserInfoModel *usModel;
        
        __block UserAllModel *uaModel;
        dispatch_queue_t q = dispatch_queue_create("zback", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(q, ^{
          usModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
        });
        dispatch_sync(q, ^{
           uaModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:iModel.SID];
        });
    
    BOOL isHaveMe = NO;
    NSArray *pAlarmArr = [iModel.MSG.DATA componentsSeparatedByString:@","];
    NSMutableArray *pNameArr = [NSMutableArray array];
    for (NSString *alarmStr in pAlarmArr) {
        dispatch_queue_t q = dispatch_queue_create("zpalarm", DISPATCH_QUEUE_SERIAL);
        __block UserAllModel *uModel;
        dispatch_sync(q, ^{
        uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:alarmStr];
        });
        
        if (uModel != nil) {
            
            [pNameArr addObject:uModel.RE_name];
            
            if ([alarmStr isEqualToString:usModel.alarm]) {
                isHaveMe = YES;
            }
            NSString *alarmStrs = [pNameArr componentsJoinedByString:@","];
            
            if ([@"P" isEqualToString:iModel.MSG.MTYPE]) {
                
                NSString *tempData = iModel.MSG.DATA;
                NSString *name = @"";
                if ([usModel.alarm isEqualToString:iModel.SID]) {
                    name = @"你";
                }else {
                    name = uaModel.RE_name;
                }
                tempData = [NSString stringWithFormat:@"%@邀请%@加入群聊",name,alarmStrs];
                if (isHaveMe) {
                    
                    tempData = [NSString stringWithFormat:@"你被%@加入群聊",name];
                }
                iModel.MSG.DATA = tempData;
            }else if ([@"D" isEqualToString:iModel.MSG.MTYPE]) {
                
                NSString *tempData = iModel.MSG.DATA;
                NSString *name = @"";
                if ([usModel.alarm isEqualToString:iModel.SID]) {
                    name = @"你";
                }else {
                    name = uaModel.RE_name;
                }
                tempData = [NSString stringWithFormat:@"%@将%@移除了群聊",name,alarmStrs];
                if (isHaveMe) {
                    tempData = [NSString stringWithFormat:@"你被%@移除群聊",name];
                }
                iModel.MSG.DATA = tempData;
            }
            
        }
        
    }
    }
  
        [[[DBManager sharedManager] MessageDAO] insertMessageOfchatModell:iModel];
        [[[DBManager sharedManager] taskMarkSQ] insertTaskMarkFormChatModel:iModel];

}
// 格式化撤回消息
+ (void)backSystemChatmodel:(chatModel *)model {
    
    UserInfoModel *iModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    UserAllModel *sModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:model.SID];
    NSString *messageData = @"";
    
    if ([model.SID isEqualToString:iModel.alarm]) {
        messageData = @"你撤回了一条消息";
    }else {
        messageData = [NSString stringWithFormat:@"%@撤回了一条消息",sModel.RE_name];
    }
    model.MSG.DATA = messageData;
    // 将消息存入到聊天记录表
    [[[DBManager sharedManager] MessageDAO] insertMessageOfchatModell:model];

}
// 拉取历史消息刷新界面
+ (void)getHistoryReloadView:(NSMutableDictionary *)dict  chatModel:(chatModel *)iModel {

    dict[kXMNMessageConfigurationQIDKey] = @(iModel.QID);
    dict[kXMNMessageConfigurationFireKey] = iModel.FIRE;
    dict[kXMNMessageConfigurationTimerStrKey] = iModel.timeStr;
    
    if ([@"T" isEqualToString:iModel.MSG.MTYPE]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeText);
    } else if ([@"P" isEqualToString:iModel.MSG.MTYPE]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeImage);
        dict[kXMNMessageConfigurationImageKey] = iModel.MSG.DATA;
    } else if ([@"S" isEqualToString:iModel.MSG.MTYPE]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVoice);
        dict[kXMNMessageConfigurationVoiceKey] = iModel.MSG.DATA;
        dict[kXMNMessageConfigurationVoiceSecondsKey] = @([iModel.MSG.VOICETIME doubleValue]);
    } else if ([@"L" isEqualToString:iModel.MSG.MTYPE]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeLocation);
        NSRange rangeU = [iModel.MSG.DATA rangeOfString:@"locationUrl="];
        NSRange rangeT = [iModel.MSG.DATA rangeOfString:@"&locationText="];
        NSRange locationUrl = NSMakeRange(rangeU.location+rangeU.length, rangeT.location-rangeU.location-rangeU.length);
        dict[kXMNMessageConfigurationLocationKey] = [iModel.MSG.DATA substringWithRange:locationUrl];
        dict[kXMNMessageConfigurationTextKey] = [iModel.MSG.DATA substringFromIndex:(rangeT.location+rangeT.length)];
        
    } else if ([@"V" isEqualToString:iModel.MSG.MTYPE]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVideo);
        dict[kXMNMessageConfigurationVideoKey] = iModel.MSG.DATA;
        dict[kXMNMessageConfigurationImageKey] = iModel.MSG.VIDEOPIC;
    } else {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeText);
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    if ([iModel.SID isEqualToString:alarm]) {
        // 自己发送的消息
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    } else {
        // 别人发送的消息
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerOther);
    }

    dict[kXMNMessageConfigurationAlarmKey] = iModel.SID;
    
    dict[kXMNMessageConfigurationTimeKey] = iModel.TIME;
    
    
    
//    dict[kXMNMessageConfigurationTimeScopeKey] = [self isTimeScopeType:iModel.TIME withDict:dict] ? @"begin" : @"during";
    
    UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:iModel.SID];
    dict[kXMNMessageConfigurationNicknameKey] = uModel.RE_name;
    
    dict[kXMNMessageConfigurationAvatarKey] = uModel.RE_headpic;
    if ([@"2" isEqualToString:iModel.CMD]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
    }else if ([@"3" isEqualToString:iModel.CMD]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
    }else if ([@"4" isEqualToString:iModel.CMD]) {
        if ([iModel.MSG.MTYPE isEqualToString:@"7"]) {
            dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
            dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
        }
    }else if ([@"5" isEqualToString:iModel.CMD]) {//任务
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeReleaseTask);
        if ([iModel.SID isEqualToString:alarm]) {
            // 自己发送的消息
            dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
        } else {
            // 别人发送的消息
            dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerOther);
        }
        if ([iModel.MSG.MTYPE isEqualToString:@"S"]) {//疑情
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
        }else if ([iModel.MSG.MTYPE isEqualToString:@"X"]) {;//聊天群创建侦察任务群
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
        }else if ([iModel.MSG.MTYPE isEqualToString:@"N"]) {//通知（新增记录，标记）
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            dict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",iModel.MSG.taskNDataModel.workname];
        }else if ([iModel.MSG.MTYPE isEqualToString:@"P"]) {// "P":任务发布
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
        }else if ([iModel.MSG.MTYPE isEqualToString:@"C"]) {//案件
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
        }else if ([iModel.MSG.MTYPE isEqualToString:@"T"]) {//轨迹上传提醒
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            dict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",iModel.MSG.taskTDataModel.workname];
            
        }else if ([iModel.MSG.MTYPE isEqualToString:@"F"]) {// "F":任务结束通知
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            dict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",iModel.MSG.taskFDataModel.workname];
            
        }else if ([iModel.MSG.MTYPE isEqualToString:@"A"]) {// "A":任务添加成员
            
            
        }else if ([iModel.MSG.MTYPE isEqualToString:@"D"]) {//删除疑情列表人员
            
            
        }else if ([iModel.MSG.MTYPE isEqualToString:@"AC"]){//集合消息
            dict[kXMNMessageConfigurationWorkNameKey]=@"[未知消息]";
            dict[kXMNMessageConfigurationTextKey]=@"该版本不支持此消息，请用其他版本查看";
        
        }
        
    }
    
}
// 拉取本地历史消息刷新
+ (void)getNewsForDb:(NSMutableDictionary *)dict iComdeModel:(ICometModel *)iModel {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];

    dict[kXMNMessageConfigurationSendStateKey] = iModel.messageState;
    
    dict[kXMNMessageConfigurationQIDKey] =@(iModel.qid);
    dict[kXMNMessageConfigurationFireKey] = iModel.FIRE;
    dict[kXMNMessageConfigurationTimerStrKey] = iModel.timeStr;
    //消息发送失败通过唯一id判断存取
    if (StateMessage_FailState) {
        dict[kXMNMessageConfigurationCUIDKey] = iModel.cuid;
    }

    if ([@"T" isEqualToString:iModel.mtype]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeText);
    } else if ([@"P" isEqualToString:iModel.mtype]) {
        
        dict[kXMNMessageConfigurationImageKey] = iModel.data;
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeImage);
        if (StateMessage_FailState) {
            __block UIImage *image;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                image = [LZXHelper Base64StrToUIImage:iModel.data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    dict[kXMNMessageConfigurationImageKey] = image;
                    //回调或者说是通知主线程刷新，
                    
                });
                
            });
            
//            dict[kXMNMessageConfigurationImageKey] = [LZXHelper Base64StrToUIImage:iModel.data];
           
        }
        
        
    } else if ([@"S" isEqualToString:iModel.mtype]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVoice);
        dict[kXMNMessageConfigurationVoiceKey] = iModel.data;
        dict[kXMNMessageConfigurationVoiceSecondsKey] = @([iModel.voicetime doubleValue]);
        
    } else if ([@"L" isEqualToString:iModel.mtype]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeLocation);
        NSRange rangeU = [iModel.data rangeOfString:@"locationUrl="];
        NSRange rangeT = [iModel.data rangeOfString:@"&locationText="];
        NSRange locationUrl = NSMakeRange(rangeU.location+rangeU.length, rangeT.location-rangeU.location-rangeU.length);
        dict[kXMNMessageConfigurationLocationKey] = [iModel.data substringWithRange:locationUrl];
        dict[kXMNMessageConfigurationTextKey] = [iModel.data substringFromIndex:(rangeT.location+rangeT.length)];
        
    } else if ([@"V" isEqualToString:iModel.mtype]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVideo);
        dict[kXMNMessageConfigurationVideoKey] = iModel.data;
        dict[kXMNMessageConfigurationImageKey] = iModel.videopic;
        if (StateMessage_FailState) {
            
            if (![LZXHelper Base64StrToUIImage:iModel.videopic]) {
                dict[kXMNMessageConfigurationImageKey] = iModel.videopic;
            }
            dict[kXMNMessageConfigurationImageKey] = [LZXHelper Base64StrToUIImage:iModel.videopic];
            
            if ([iModel.data isKindOfClass:[NSString class]]) {
                dict[kXMNMessageConfigurationVideoKey] = [NSURL URLWithString:iModel.data];
                
            } else if ([iModel.data isKindOfClass:[NSURL class]]) {
                dict[kXMNMessageConfigurationVideoKey] = iModel.data;
            }
            
        }
        
    } else {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeText);
    }
    if ([iModel.sid isEqualToString:alarm]) {
        // 自己发送的消息
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    } else {
        // 别人发送的消息
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerOther);
    }
    
    
    dict[kXMNMessageConfigurationAlarmKey] = iModel.sid;
    dict[kXMNMessageConfigurationTimeKey] = iModel.time;
    
    
    
//    dict[kXMNMessageConfigurationTimeScopeKey] = [self isTimeScopeType:iModel.time withDict:dict] ? @"begin" : @"during";
    
    UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:iModel.sid];
    dict[kXMNMessageConfigurationNicknameKey] = uModel.RE_name;
    dict[kXMNMessageConfigurationAvatarKey] = uModel.RE_headpic;
    dict[kXMNMessageConfigurationDETypeKey] = iModel.DE_type;
    dict[kXMNMessageConfigurationDENameKey] = iModel.DE_name;
    if ([@"2" isEqualToString:iModel.cmd]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
        
    }else if ([@"3" isEqualToString:iModel.cmd]) {
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
        dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
        
    }else if ([@"4" isEqualToString:iModel.cmd]) {
        if ([iModel.mtype isEqualToString:@"7"]) {
            dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
            dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
        }
    }else if ([@"5" isEqualToString:iModel.cmd]) {//任务
        dict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeReleaseTask);
        
        
        if ([iModel.sid isEqualToString:alarm]) {
            // 自己发送的消息
            dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
        } else {
            // 别人发送的消息
            dict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerOther);
        }
        
        if ([iModel.mtype isEqualToString:@"S"]) {//疑情
            
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([iModel.mtype isEqualToString:@"X"]) {;//聊天群创建侦察任务群
            
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([iModel.mtype isEqualToString:@"N"]) {//通知（新增记录，标记）
            
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            dict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",iModel.workname];
        }else if ([iModel.mtype isEqualToString:@"P"]) {// "P":任务发布
            
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([iModel.mtype isEqualToString:@"C"]) {//案件
            
            dict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([iModel.mtype isEqualToString:@"T"]) {//轨迹上传提醒
            
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            dict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",iModel.workname];
            
        }else if ([iModel.mtype isEqualToString:@"F"]) {// "F":任务结束通知
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            dict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",iModel.workname];
            
        }else if ([iModel.mtype isEqualToString:@"A"]) {// "A":任务添加成员
            
            
        }else if ([iModel.mtype isEqualToString:@"D"]) {//删除疑情列表人员
            
            
        }else if ([iModel.mtype isEqualToString:@"AC"]){//集合消息
        
            dict[kXMNMessageConfigurationWorkNameKey]=@"[未知消息]";
            dict[kXMNMessageConfigurationTextKey]=@"该版本不支持此消息，请用其他版本查看";
            
        }
        
    }
}
// 返回消息列表消息
+ (NSString *)getLastMessage:(UserlistModel *)model {
    
    NSString *lastMsg = [model.ut_message copy];
    if ([model.ut_fire isEqualToString:@"LOCK"]) {
        
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        
        if ([model.ut_sendid isEqualToString:alarm]) {
            lastMsg = @"你发送了一条悄悄话";
        }
        else
        {
            lastMsg = @"你收到了一条悄悄话";
        }
    }
    else
    {
        if ([model.ut_cmd isEqualToString:@"1"]) {//cmd
            
            if ([@"P" isEqualToString:model.ut_mtype]) {
                
                lastMsg = @"[图片]";
                
            } else if ([@"S" isEqualToString:model.ut_mtype]) {
                lastMsg = @"[语音]";
            } else if ([@"V" isEqualToString:model.ut_mtype]) {
                lastMsg = @"[视频]";
            } else if ([@"L" isEqualToString:model.ut_mtype]) {
                lastMsg = @"[位置]";
            }
        }else if ([model.ut_cmd isEqualToString:@"2"]){
            
        }else if ([model.ut_cmd isEqualToString:@"3"]){
            
        }else if ([model.ut_cmd isEqualToString:@"4"]){
            
        }else if ([model.ut_cmd isEqualToString:@"5"]){
            if ([model.ut_type isEqualToString:@"G"]) {//群组
                
                if ([model.ut_mtype isEqualToString:@"P"]) {//任务发布
                    
                }else if ([model.ut_mtype isEqualToString:@"A"]) {//任务添加成员
                    
                }else if ([model.ut_mtype isEqualToString:@"F"]) {//任务结束通知
                    
                }else if ([model.ut_mtype isEqualToString:@"S"]) {//疑情发布通知
                    
                }else if ([model.ut_mtype isEqualToString:@"D"]) {//疑情人员删除通知
                    
                }else if ([model.ut_mtype isEqualToString:@"T"]) {// 添加轨迹通知
                    
                }else if ([model.ut_mtype isEqualToString:@"AC"]) {//未知消息
                    lastMsg=@"[未知消息]";
                }
            }
            
        }
        else if ([model.ut_cmd isEqualToString:@"6"]){
            if ([model.ut_mtype isEqualToString:@"O"]) {//上线提醒
                lastMsg = @"上线提醒";
            }else if ([model.ut_mtype isEqualToString:@"P"]) {
                lastMsg = @"发帖提醒";
            }
        }
    }
    return lastMsg;
}
// 得到大头针背景图片
+ (UIImage *)getZAnnotationIcon:(NSString *)my_type direction:(NSString *)direction type:(NSString *)type {

    UIImage *image = nil;
    switch ([my_type integerValue]) {
        case 0:
            image = [self getIntersignZAnnotationIcon:type];
            break;
        case 1:
            //记录背景图
            image = [UIImage imageNamed:@"recordmark"];
            break;
        case 2:
            
            image = [self getCameraZAnnotationIcon:type direction:direction];
            break;
        default:
            break;
    }
    return image;
}
// 得到标记大头针的背景图或地图中心标记icon
+ (UIImage *)getIntersignZAnnotationIcon:(NSString *)type {
    UIImage *image = nil;
    switch ([type integerValue]) {
        case 0:
            image = [UIImage imageNamed:@"mark_goodw"];
            break;
        case 1:
            image = [UIImage imageNamed:@"mark_footw"];
            break;
        case 2:
            image = [UIImage imageNamed:@"mark_carw"];
            break;
        case 3:
            image = [UIImage imageNamed:@"mark_manw"];
            break;
        case 4:
            image = [UIImage imageNamed:@"mark_suspectw"];
            break;
        case 5:
            image = [UIImage imageNamed:@"mark_bannerw"];
            break;
        default:
            break;
    }
    return image;
}
// 得到摄像头大头针背景图片
+ (UIImage *)getCameraZAnnotationIcon:(NSString *)type direction:(NSString *)direction {
    
    UIImage *image = nil;
    switch ([type integerValue]) {
        case 0:
            
            switch ([direction integerValue]) {
                case 0:
                    image = [UIImage imageNamed:@"mark_gong_square_down"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"mark_gong_square_left"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"mark_gong_square_up"];
                    break;
                case 3:
                    image = [UIImage imageNamed:@"mark_gong_square_right"];
                    break;
                case 4:
                    image = [UIImage imageNamed:@"mark_gong_square_left_down"];
                    break;
                case 5:
                    image = [UIImage imageNamed:@"mark_gong_square_left_up"];
                    break;
                case 6:
                    image = [UIImage imageNamed:@"mark_gong_square_right_up"];
                    break;
                case 7:
                    image = [UIImage imageNamed:@"mark_gong_square_right_down"];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            
            switch ([direction integerValue]) {
                case 0:
                    image = [UIImage imageNamed:@"mark_gong_cirle_down"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"mark_gong_cirle_left"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"mark_gong_cirle_up"];
                    break;
                case 3:
                    image = [UIImage imageNamed:@"mark_gong_cirle_right"];
                    break;
                case 4:
                    image = [UIImage imageNamed:@"mark_gong_cirle_left_down"];
                    break;
                case 5:
                    image = [UIImage imageNamed:@"mark_gong_cirle_left_up"];
                    break;
                case 6:
                    image = [UIImage imageNamed:@"mark_gong_cirle_right_up"];
                    break;
                case 7:
                    image = [UIImage imageNamed:@"mark_gong_cirle_right_down"];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            
            switch ([direction integerValue]) {
                case 0:
                    image = [UIImage imageNamed:@"mark_fei_square_down"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"mark_fei_square_left"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"mark_fei_square_up"];
                    break;
                case 3:
                    image = [UIImage imageNamed:@"mark_fei_square_right"];
                    break;
                case 4:
                    image = [UIImage imageNamed:@"mark_fei_square_left_down"];
                    break;
                case 5:
                    image = [UIImage imageNamed:@"mark_fei_square_left_up"];
                    break;
                case 6:
                    image = [UIImage imageNamed:@"mark_fei_square_right_up"];
                    break;
                case 7:
                    image = [UIImage imageNamed:@"mark_fei_square_right_down"];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            
            switch ([direction integerValue]) {
                case 0:
                    image = [UIImage imageNamed:@"mark_fei_cirle_down"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"mark_fei_cirle_left"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"mark_fei_cirle_up"];
                    break;
                case 3:
                    image = [UIImage imageNamed:@"mark_fei_cirle_right"];
                    break;
                case 4:
                    image = [UIImage imageNamed:@"mark_fei_cirle_left_down"];
                    break;
                case 5:
                    image = [UIImage imageNamed:@"mark_fei_cirle_left_up"];
                    break;
                case 6:
                    image = [UIImage imageNamed:@"mark_fei_cirle_right_up"];
                    break;
                case 7:
                    image = [UIImage imageNamed:@"mark_fei_cirle_right_down"];
                    break;
                default:
                    break;
            }
            break;
        case 4:
            
            switch ([direction integerValue]) {
                case 0:
                    image = [UIImage imageNamed:@"mark_yi_square_down"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"mark_yi_square_left"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"mark_yi_square_up"];
                    break;
                case 3:
                    image = [UIImage imageNamed:@"mark_yi_square_right"];
                    break;
                case 4:
                    image = [UIImage imageNamed:@"mark_yi_square_left_down"];
                    break;
                case 5:
                    image = [UIImage imageNamed:@"mark_yi_square_left_up"];
                    break;
                case 6:
                    image = [UIImage imageNamed:@"mark_yi_square_right_up"];
                    break;
                case 7:
                    image = [UIImage imageNamed:@"mark_yi_square_right_down"];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return image;
}
#pragma mark -
#pragma mark 得到工作列表的展示图片
+ (UIImage *)getIcon:(NSString *)my_type direction:(NSString *)direction type:(NSString *)type {
    UIImage *image = nil;
    switch ([my_type integerValue]) {//0 走访标记 1 快速记录 2 摄像头标记
        case 0:
            image = [self getIntersignZAnnotationIcon:type];
            break;
        case 2:
            image = [self getCameraIcon:type direction:direction];
            break;
        case 1:
            //记录背景图
            image = [UIImage imageNamed:@"recordmark"];
            break;
        default:
            break;
    }
    return image;
    
}
#pragma mark -
#pragma mark 得到工作列表de摄像头背景图片
+ (UIImage *)getCameraIcon:(NSString *)type direction:(NSString *)direction {
    
    UIImage *image = nil;
    switch ([type integerValue]) {
        case 0:
            image = [UIImage imageNamed:@"mark_gong_square"];
            break;
        case 1:
            image = [UIImage imageNamed:@"mark_gong_circle"];
            break;
        case 2:
            image = [UIImage imageNamed:@"mark_fei_square"];
            break;
        case 3:
            image = [UIImage imageNamed:@"mark_fei_circle"];
            break;
        case 4:
            image = [UIImage imageNamed:@"mark_yi_square"];
            break;
        default:
            break;
    }
    return image;
}

// 比较 新消息的时间  和  前一条消息的时间  间隔 是否大于3
+(BOOL)isTimeCompareWithTime:(NSString *)time WithBtime:(NSString *)bTime;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    //后来的时间
    NSDate *date = [formatter dateFromString:time];
    //之前的时间
    NSDate *begin =[formatter dateFromString:bTime];

    NSTimeInterval timeInterval = [date timeIntervalSinceDate:begin];

//    NSLog(@"min:%f",timeInterval/60);

    long long min = [[NSNumber numberWithDouble:timeInterval] longLongValue];

    if (min/60 < 3)
    {
        return NO;
    }
    else
    {
        return YES;
    }


}

// 比较 新消息的时间  和  前一条消息的时间  间隔 是否大于2
+(BOOL)isTimeCompareWithATime:(NSString *)atime WithBtime:(NSString *)bTime;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //后来的时间
    NSDate *date = [formatter dateFromString:atime];
    //之前的时间
    NSDate *begin =[formatter dateFromString:bTime];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:begin];
    
    //    NSLog(@"min:%f",timeInterval/60);
    
    long long min = [[NSNumber numberWithDouble:timeInterval] longLongValue];
    
    if (min/60 < 2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    
}

// 处理时间的业务
+(void)timeBusiness:(id)model
{
    ICometModel *iModel = model;
    
    UserlistModel *userListModel;
    
    if ([iModel.type isEqualToString:@"G"])
    {
        userListModel = [[[DBManager sharedManager] UserlistDAO] selectUserlistById:iModel.rid];
        
        if (userListModel)
        {
            if ([ChatBusiness isTimeCompareWithTime:iModel.beginTime WithBtime:userListModel.ut_time])
            {
                
                iModel.time = iModel.beginTime;
            }
            else
            {
                iModel.time = @"0";
            }
        }
        else
        {
            
            iModel.time = iModel.beginTime;
        }
    }
    else
    {
        //自己发的
        if ([iModel.sid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"] ])
        {
            userListModel = [[[DBManager sharedManager] UserlistDAO] selectUserlistById:iModel.rid];
            
            if (userListModel)
            {
                if ([ChatBusiness isTimeCompareWithTime:iModel.beginTime WithBtime:userListModel.ut_time])
                {
                    
                    iModel.time = iModel.beginTime;
                }
                else
                {
                    iModel.time = @"0";
                }
            }
            else
            {
                
                iModel.time = iModel.beginTime;
            }
        }
        
        else
        {
            UserlistModel *userListModel = [[[DBManager sharedManager] UserlistDAO] selectUserlistById:iModel.sid];
            
            if (userListModel)
            {
                if ([ChatBusiness isTimeCompareWithTime:iModel.beginTime WithBtime:userListModel.ut_time])
                {
                    
                    iModel.time = iModel.beginTime;
                }
                else
                {
                    iModel.time = @"0";
                }
            }
            else
            {
                
                iModel.time = iModel.beginTime;
            }
        }
    }


}
// 格式化摄像头方向
+ (NSInteger)getStandardDircation:(NSInteger)tag {
    NSInteger index = 0;
    switch (tag) {
        case 0:
            index = 5;
            break;
        case 1:
            index = 2;
            break;
        case 2:
            index = 6;
            break;
        case 3:
            index = 2;
            break;
        case 4:
            break;
        case 5:
            index = 3;
            break;
        case 6:
            index = 4;
            break;
        case 7:
            index = 0;
            break;
        case 8:
            index = 7;
            break;
        default:
            break;
    }
    return index;
}

+ (UIImage *)getIcon:(NSString *)my_type  type:(NSString *)type
{
    UIImage *image = nil;
    switch ([my_type integerValue]) {//0 走访标记 1 快速记录 2 摄像头标记
        case 0:
            image = [self getIntersignIcon:type];
            break;
        case 2:
            image = [self getCameraIcon:type];
            break;
        case 1:
            //记录背景图
            image = [UIImage imageNamed:@"drafts_recordmark"];
            break;
        default:
            break;
    }
    return image;
}
+ (UIImage *)getCameraIcon:(NSString *)type  {
    
    UIImage *image = nil;
    switch ([type integerValue]) {
        case 0:
            image = [UIImage imageNamed:@"drafts_mark_gong_square"];
            break;
        case 1:
            image = [UIImage imageNamed:@"drafts_mark_gong_circle"];
            break;
        case 2:
            image = [UIImage imageNamed:@"drafts_mark_fei_square"];
            break;
        case 3:
            image = [UIImage imageNamed:@"drafts_mark_fei_circle"];
            break;
        case 4:
            image = [UIImage imageNamed:@"drafts_mark_yi_square"];
            break;
        default:
            break;
    }
    return image;
}

+ (UIImage *)getIntersignIcon:(NSString *)type {
    UIImage *image = nil;
    switch ([type integerValue]) {
        case 0:
            image = [UIImage imageNamed:@"drafts_mark_goodw"];
            break;
        case 1:
            image = [UIImage imageNamed:@"drafts_mark_footw"];
            break;
        case 2:
            image = [UIImage imageNamed:@"drafts_mark_carw"];
            break;
        case 3:
            image = [UIImage imageNamed:@"drafts_mark_manw"];
            break;
        case 4:
            image = [UIImage imageNamed:@"drafts_mark_suspectw"];
            break;
        case 5:
            image = [UIImage imageNamed:@"drafts_mark_bannerw"];
            break;
        default:
            break;
    }
    return image;
}
@end
