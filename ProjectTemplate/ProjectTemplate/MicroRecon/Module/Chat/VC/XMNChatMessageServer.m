//
//  XMNChatServerExample.m
//  XMChatBarExample
//
//  Created by shscce on 15/11/23.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatMessageServer.h"
#import "ICometModel.h"
#import "ChatLogic.h"
#import "HttpsManager.h"
#import "UploadModel.h"
#import "MessageDAO.h"
#import "UserInfoModel.h"
#import "UserAllModel.h"
#import "DisplayContentLogic.h"
#import "UIImage+UIImageScale.h"
#import "UIImage+Property.h"
#import "ZEBURLSessionWrapperOperation.h"

@interface XMNChatMessageServer ()

{
    BOOL _isNotBegin;
    NSString * _beginTime;
}
@end

@implementation XMNChatMessageServer
@synthesize delegate = _delegate;

- (instancetype) init {
    if (self = [super init]){
        // 注册观察者
        // 观察者 self 在收到名为 @"NOTIFICATION_NAME" 的事件是执行 @selector(execute:)，最后一个参数是表示会对哪个发送者对象发出的事件作出响应，nil 时表示接受所有发送者的事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute:) name: @"ReceiveChatMessage" object:nil];
       
    }
    
    return self;
}

- (void)dealloc {
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/**
 * 定义一个事件到来时执行的方法
 */
- (void)execute:(NSNotification *)notification {
    
    if(notification.object && [notification.object isKindOfClass:[ICometModel class]]){
        //do something
        ICometModel *model = notification.object;
        
//        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
//        if ([alarm isEqualToString:model.sid]) {
//            return;
//        }
        
        [self receiveMessage:model];
    }
}


- (NSDictionary *)sendMessageLocation {
    //获取用户信息
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *latitude = [LZXHelper isNullToString:appDelegate.latitude];
    NSString *longitude = [LZXHelper isNullToString:appDelegate.longitude];
    
    if ([[LZXHelper isNullToString:latitude] isEqualToString:@""] || [[LZXHelper isNullToString:longitude] isEqualToString:@""]) {
        latitude = @"0";
        longitude = @"0";
    }
    NSDictionary *locationDict = @{@"latitude":latitude,@"longitude":longitude};
    return locationDict;
}


- (void)sendMessage:(NSDictionary *)message withProgressBlock:(XMNChatServerProgressBlock)progressBlock completeBlock:(XMNChatServerCompleteBlock)completeBlock {
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatType = [user objectForKey:@"chatType"];
    NSString *chatId = [user objectForKey:@"chatId"];
    NSString *alarm = [user objectForKey:@"alarm"];
    NSString *DE_type = [user objectForKey:DEType];
    NSString *DE_name = [user objectForKey:DEName];
    NSString *fire = [message objectForKey:kXMNMessageConfigurationFireKey];
    
    //获取用户信息
    NSDictionary *location = [self sendMessageLocation];
    NSString *latitude = location[@"latitude"];
    NSString *longitude = location[@"longitude"];
    
    
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
//    30.612758 114.257640
//    ZEBLog(@"%@,%@",latitude,longitude);
    NSString *data = nil;
    
    if ([chatType isEqualToString:@"S"]) {
      BOOL ret = [[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:chatId];
        if (!ret) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHindNotfication" object:@"你们已经不是好友关系，无法直接发送消息"];
            return;
        }
    }else if ([chatType isEqualToString:@"G"]) {
        BOOL ret = [[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:chatId];
        if (!ret) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHindNotfication" object:@"你已经不在该群，无法直接发送消息"];
           
            return;
        }
        
    }

    
    NSString *cuid = message[kXMNMessageConfigurationCUIDKey];
    

    NSNumber *number = message[kXMNMessageConfigurationTypeKey];
    switch ([number unsignedIntegerValue]) {
        case XMNMessageTypeEmotions:
        {
            data = message[kXMNMessageConfigurationTextKey];
            
            NSString *atAlarm = [user objectForKey:atAlarms];
            
            
            NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
            
            NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"ATALARM\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"T\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"DISPLAY_CONTENT\":\"%@\",\"FIRE\":\"%@\"}}", alarm,atAlarm, chatId, cuid ,chatType,longitude,latitude,data, DE_type, DE_name,displayContent,fire];
            
            [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                
                
                completeBlock(XMNMessageSendStateSending);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                
                completeBlock(XMNMessageSendSuccess);
                [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(XMNMessageSendFail);
                
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"T" WithCuid:cuid];
                
            }];
        }
            break;
        case XMNMessageTypeText:
        {
            data = message[kXMNMessageConfigurationTextKey];
            
            NSString *atAlarm = [user objectForKey:atAlarms];
            
        
            NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
            
           NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"ATALARM\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"T\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"DISPLAY_CONTENT\":\"%@\",\"FIRE\":\"%@\"}}", alarm,atAlarm, chatId,cuid,chatType,longitude,latitude,data, DE_type, DE_name,displayContent,fire];

            [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                
                
                completeBlock(XMNMessageSendStateSending);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            
                completeBlock(XMNMessageSendSuccess);
                [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(XMNMessageSendFail);
                
                
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"T" WithCuid:cuid];

            }];
        }
            break;
        case XMNMessageTypeImage:
        {
            UIImage *image = message[kXMNMessageConfigurationImageKey];
            
            //生成唯一标志
//            NSString *cuid = [LZXHelper createCUID];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *time = [formatter stringFromDate:[NSDate date]];
            NSInteger maxQid;
            if ([@"S" isEqualToString:chatType]) {
                maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
            } else if ([@"G" isEqualToString:chatType]) {
                maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
            }
            if (maxQid == 0) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *chatId = [user objectForKey:@"chatId"];
                maxQid = [[[DBManager sharedManager] maxQidListSQ] selectMaxQidByChatId:chatId];
            }
            ICometModel *model = [[ICometModel alloc] init];
            UserInfoModel *userModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
            model.cmd = @"1";
            model.sid = alarm;
            model.rid = chatId;
            model.type = chatType;
            model.sname = userModel.name;
            model.headpic = userModel.headpic;
            model.longitude = @"112";
            model.latitude = @"30";
            model.mtype = @"P";
            model.data = @"";
            model.qid = maxQid;
            model.time = time;
            model.cuid = cuid;
            
            [[[DBManager sharedManager] uploadingSQ] insertUploading:model];
            //[[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
            
            
          NSURLSessionUploadTask* uploadTask = [[HttpsManager sharedManager] uploadImage:image progress:^(NSProgress * _Nonnull progress) {
                progressBlock(progress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response, UIImage * _Nullable theImage) {
                
                UploadModel *model = [UploadModel uploadWithData:response];
                
                NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
                NSString *url = model.url;
                //缓存
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                UIImage *tempImage = [UIImage imageWithData:theImage.imageData];
                if ([theImage.type isEqualToString:@"original"]) { //包含原图
                    
                    [ZEBCache originalImageCacheUrlString:tempImage url:model.url];
                    [manager saveImageToCache:[tempImage newOriginalOfChat] forURL:[NSURL URLWithString:model.url]];
                    
                    url = [NSString stringWithFormat:@"%@?type=1&size=%@&width=10&height=10",model.url,theImage.Bytes];
                }else {
                    
                    [manager saveImageToCache:tempImage forURL:[NSURL URLWithString:model.url]];
                }

                NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"P\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"DISPLAY_CONTENT\":\"%@\",\"FIRE\":\"%@\"}}", alarm, chatId,cuid,chatType,longitude,latitude, url, DE_type, DE_name,displayContent,fire];
                
                
                [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                    completeBlock(XMNMessageSendStateSending);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                    completeBlock(XMNMessageSendSuccess);
                    [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    completeBlock(XMNMessageSendFail);
                    [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
                    [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"P" WithCuid:cuid];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                completeBlock(XMNMessageSendFail);
                [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"P" WithCuid:cuid];
            }];
            
        }
            break;
        case XMNMessageTypeFireImage:
        {
            UIImage *image = message[kXMNMessageConfigurationImageKey];
            
            //生成唯一标志
            //            NSString *cuid = [LZXHelper createCUID];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *time = [formatter stringFromDate:[NSDate date]];
            NSInteger maxQid;
            if ([@"S" isEqualToString:chatType]) {
                maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
            } else if ([@"G" isEqualToString:chatType]) {
                maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
            }
            
            ICometModel *model = [[ICometModel alloc] init];
            UserInfoModel *userModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
            model.cmd = @"1";
            model.sid = alarm;
            model.rid = chatId;
            model.type = chatType;
            model.sname = userModel.name;
            model.headpic = userModel.headpic;
            model.longitude = @"112";
            model.latitude = @"30";
            model.mtype = @"P";
            model.data = @"";
            model.qid = maxQid;
            model.time = time;
            model.cuid = cuid;
            
            [[[DBManager sharedManager] uploadingSQ] insertUploading:model];
            //[[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
            
            
            NSURLSessionUploadTask* uploadTask = [[HttpsManager sharedManager] uploadImage:image progress:^(NSProgress * _Nonnull progress) {
                progressBlock(progress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response, UIImage * _Nullable theImage) {
                
                UploadModel *model = [UploadModel uploadWithData:response];
                
                NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
                NSString *url = model.url;
                //缓存
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                UIImage *tempImage = [UIImage imageWithData:theImage.imageData];
                if ([theImage.type isEqualToString:@"original"]) { //包含原图
                    
                    [ZEBCache originalImageCacheUrlString:tempImage url:model.url];
                    [manager saveImageToCache:[tempImage newOriginalOfChat] forURL:[NSURL URLWithString:model.url]];
                    
                    url = [NSString stringWithFormat:@"%@?type=1&size=%@&width=10&height=10",model.url,theImage.Bytes];
                }else {
                    
                    [manager saveImageToCache:tempImage forURL:[NSURL URLWithString:model.url]];
                }
                
                NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"P\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"DISPLAY_CONTENT\":\"%@\",\"FIRE\":\"%@\"}}", alarm, chatId,cuid,chatType,longitude,latitude, url, DE_type, DE_name,displayContent,fire];
                
                
                [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                    completeBlock(XMNMessageSendStateSending);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                    completeBlock(XMNMessageSendSuccess);
                    [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    completeBlock(XMNMessageSendFail);
                    [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
                    [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"P" WithCuid:cuid];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                completeBlock(XMNMessageSendFail);
                [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"P" WithCuid:cuid];
            }];
            
        }
            break;
        case XMNMessageTypeVoice:
        {
            NSString *voicePath = message[kXMNMessageConfigurationVoiceKey];
            NSNumber *voiceTime = message[kXMNMessageConfigurationVoiceSecondsKey];
            
            [[HttpsManager sharedManager] uploadFile:voicePath progress:^(NSProgress * _Nonnull progress) {
                progressBlock ? progressBlock(progress.fractionCompleted) : nil;
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
                
                UploadModel *model = [UploadModel uploadWithData:response];
                
                
                NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
                
                NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"S\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"VOICETIME\":\"%d\",\"DISPLAY_CONTENT\":\"%@\",\"FIRE\":\"%@\"}}", alarm, chatId,cuid, chatType,longitude,latitude, model.url, DE_type,DE_name , (int)voiceTime.doubleValue,displayContent,fire];
                
                [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                
                [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                    completeBlock(XMNMessageSendStateSending);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                    completeBlock(XMNMessageSendSuccess);
                    [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    completeBlock(XMNMessageSendFail);
                    [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"S" WithCuid:cuid];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(XMNMessageSendFail);
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"S" WithCuid:cuid];
            }];
        }
            break;
        case XMNMessageTypeLocation:
        {
            NSString *locationText = message[kXMNMessageConfigurationTextKey];
            NSString *locationUrl = message[kXMNMessageConfigurationLocationKey];
            
            
            NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
            

            data = [NSString stringWithFormat:@"locationUrl=%@&locationText=%@", locationUrl, locationText];
            
            NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"L\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"DISPLAY_CONTENT\":\"%@\"}}", alarm, chatId,cuid, chatType,longitude,latitude, data, DE_type,DE_name, displayContent];
            

            
            [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                completeBlock(XMNMessageSendStateSending);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                completeBlock(XMNMessageSendSuccess);
                [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(XMNMessageSendFail);
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"L" WithCuid:cuid];
            }];

        }
            break;
        case XMNMessageTypeVideo:
        {
            // 上传图片
            UIImage *image = message[kXMNMessageConfigurationImageKey];
            [[HttpsManager sharedManager] upload:image progress:^(NSProgress * _Nonnull progress) {
                progressBlock(progress.fractionCompleted*0.3);
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
                
                NSString *videoImageUrl = [UploadModel uploadWithData:response].url;

                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *time = [formatter stringFromDate:[NSDate date]];
                //生成唯一标志
//                NSString *cuid = [LZXHelper createCUID];
                
                
                NSInteger maxQid = [message[kXMNMessageConfigurationQIDKey] integerValue];
                
                if (!maxQid) {
                    if ([@"S" isEqualToString:chatType]) {
                        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
                    } else if ([@"G" isEqualToString:chatType]) {
                        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
                    }
                } 
                
                
                ICometModel *model = [[ICometModel alloc] init];
                UserInfoModel *userModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
                model.cmd = @"1";
                model.sid = alarm;
                model.rid = chatId;
                model.type = chatType;
                model.sname = userModel.name;
                model.headpic = userModel.headpic;
                model.longitude = @"";
                model.latitude = @"";
                model.mtype = @"V";
                model.qid = maxQid;
                model.time = time;
                model.videopic = videoImageUrl;
                model.cuid = cuid;
                model.data = @"";
                

                [[[DBManager sharedManager] uploadingSQ] insertUploading:model];
                //[[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
                
                // 上传视频
                NSURL *videoURL = message[kXMNMessageConfigurationVideoKey];
                
                
                [[HttpsManager sharedManager] uploadVideo:videoURL progress:^(NSProgress * _Nonnull progress) {
                    
                    progressBlock ? progressBlock(0.3 + progress.fractionCompleted * 0.7) : nil;

                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
                    [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
                    [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                    
                    NSString *videoUrl = [UploadModel uploadWithData:response].url;
                    
                    NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
                    
                     NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"V\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"VIDEOPIC\":\"%@\",\"DISPLAY_CONTENT\":\"%@\"}}", alarm, chatId,cuid,chatType,longitude,latitude, videoUrl, DE_type,DE_name, videoImageUrl,displayContent];
                    

                    // 发送消息
                    [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                        completeBlock(XMNMessageSendStateSending);
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                        completeBlock(XMNMessageSendSuccess);
                        [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        completeBlock(XMNMessageSendFail);
                        [[[DBManager sharedManager] uploadingSQ] deleteUploading:model.cuid];
                        
                        NSMutableDictionary *msg =[NSMutableDictionary dictionaryWithDictionary:message];
                        msg[kXMNMessageConfigurationImageKey] = videoImageUrl;
                        msg[kXMNMessageConfigurationVideoKey] = videoUrl;
                        [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:msg WithMessageType:@"V" WithCuid:cuid];
                    }];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                    completeBlock(XMNMessageSendFail);
                    [[[DBManager sharedManager] uploadingSQ] deleteUploading:model.cuid];
                    
                    NSMutableDictionary *msg =[NSMutableDictionary dictionaryWithDictionary:message];
                    msg[kXMNMessageConfigurationImageKey] = videoImageUrl;
                    [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:msg WithMessageType:@"V" WithCuid:cuid];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(XMNMessageSendFail);
                [[ChatLogic sharedManager] saveMessageWithMessageOfSendFailureState:message WithMessageType:@"V" WithCuid:cuid];
            }];
            
        }
            break;
        case XMNMessageTypeFiles:
        {
            
            CJFileObjModel *model = message[kXMNMessageConfigurationFileKey];
            
            NSString *filePath = model.filePath;
            
            NSString *fileName = model.name;
            NSString *fileSize = model.fileSize;
            NSString *fileBytes = [NSString stringWithFormat:@"%lf", model.fileSizefloat];
            
            [[HttpsManager sharedManager] uploadFilesWithURL:filePath withFileName:fileName progress:^(NSProgress * _Nonnull progress) {
                progressBlock(progress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                UploadModel *uploadModel = [UploadModel uploadWithData:reponse];
                
                NSInteger maxQid = [message[kXMNMessageConfigurationQIDKey] integerValue];
                
                if (!maxQid) {
                    if ([@"S" isEqualToString:chatType]) {
                        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
                    } else if ([@"G" isEqualToString:chatType]) {
                        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
                    }
                }
                
                NSString *displayContent =[[DisplayContentLogic sharedManager] displayContentLogicWithChatType:chatType withChatID:chatId withMessageType:[number unsignedIntegerValue] withData:data];
                
                NSString *data = [NSString stringWithFormat:@"{\\\"fileurl\\\":\\\"%@\\\",\\\"filename\\\":\\\"%@\\\",\\\"filesize\\\":\\\"%@\\\",\\\"filelocalpath\\\":\\\"%@\\\",\\\"filebytes\\\":\\\"%@\\\"}",uploadModel.url,fileName,fileSize,filePath,fileBytes];
                
//                NSString *data = [NSString stringWithFormat:@"{\"fileurl\":\"%@\",\"filename\":\"%@\",\"filesize\":\"%@\",\"filelocalpath\":\"%@\",\"filebytes\":\"%@\"}",uploadModel.url,fileName,fileSize,filePath,fileBytes];
                
                NSString *content = [NSString stringWithFormat:@"{\"CMD\":\"1\",\"SID\":\"%@\",\"RID\":\"%@\",\"CUID\":\"%@\",\"TYPE\":\"%@\",\"GPS\":{\"H\":\"%@\",\"W\":\"%@\"},\"MSG\":{\"MTYPE\":\"D\",\"DATA\":\"%@\",\"DE_type\":\"%@\",\"DE_name\":\"%@\",\"DISPLAY_CONTENT\":\"%@\"}}", alarm, chatId,cuid, chatType,longitude,latitude, data, DE_type,DE_name, displayContent];
                
                
                //存数据库
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *time = [formatter stringFromDate:[NSDate date]];
                
                ICometModel *model = [[ICometModel alloc] init];
                UserInfoModel *userModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
                model.cmd = @"1";
                model.sid = alarm;
                model.rid = chatId;
                model.type = chatType;
                model.sname = userModel.name;
                model.headpic = userModel.headpic;
                model.longitude = @"";
                model.latitude = @"";
                model.mtype = @"D";
                model.qid = maxQid;
                model.time = time;
                model.videopic = @"";
                model.cuid = cuid;
                model.data = data;
                [[[DBManager sharedManager] uploadingSQ] insertUploading:model];
                
                // 发送消息
                [[ChatLogic sharedManager] logicSendMessage:content progress:^(NSProgress * _Nonnull progress) {
                    completeBlock(XMNMessageSendStateSending);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                    completeBlock(XMNMessageSendSuccess);
                    [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
//                    [[[DBManager sharedManager] messageResendSQ] deleteMessageByCuid:cuid];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    completeBlock(XMNMessageSendFail);
                    [[[DBManager sharedManager] uploadingSQ] deleteUploading:cuid];
                    

                }];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(XMNMessageSendFail);
            }];
            
        }
            break;
            
        case XMNMessageTypeSystem:
        {
            
        }
            break;
        case XMNMessageTypeUnknow:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)receiveMessage:(ICometModel *) model {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    
    XMNMessageType messageType = XMNMessageTypeImage;
    if ([model.FIRE containsString:@"LOCK"]) {
        if ([model.mtype isEqualToString:@"P"])
        {
            messageType = XMNMessageTypeFireImage;
        }
        
    }
    
    
    if ([@"T" isEqualToString:model.mtype]) {
        if ([model.data rangeOfString:@"[img]file:///storage/emulated/0/MicroRecon/Emoticons/"].location == NSNotFound) {
            messageType = XMNMessageTypeText;
        }else {
            messageType = XMNMessageTypeEmotions;
        }
    } else if ([@"P" isEqualToString:model.mtype]) {
        messageType = XMNMessageTypeImage;
    } else if ([@"S" isEqualToString:model.mtype]) {
        messageType = XMNMessageTypeVoice;
    } else if ([@"L" isEqualToString:model.mtype]) {
        messageType = XMNMessageTypeLocation;
    } else if ([@"V" isEqualToString:model.mtype]) {
        messageType = XMNMessageTypeVideo;
    } else if ([@"D" isEqualToString:model.mtype]) {
        messageType = XMNMessageTypeFiles;
    } else {
        messageType = XMNMessageTypeSystem;
    }
//    XMNMessageType messageType = random() % 5 + 1;
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    
    messageDict[kXMNMessageConfigurationQIDKey] = @(model.qid);//添加消息体qid
    
    switch (messageType) {
        case XMNMessageTypeText:
            messageDict[kXMNMessageConfigurationTextKey] = model.data;
            break;
        case XMNMessageTypeEmotions:
            messageDict[kXMNMessageConfigurationTextKey] = model.data;
            break;
        case XMNMessageTypeImage:
            
            messageDict[kXMNMessageConfigurationImageKey]= model.data;
            break;
        case XMNMessageTypeFireImage:
            
            messageDict[kXMNMessageConfigurationImageKey]= model.data;
            break;
        case XMNMessageTypeVoice:
            messageDict[kXMNMessageConfigurationVoiceKey]= model.data;
            messageDict[kXMNMessageConfigurationVoiceSecondsKey]= @([model.voicetime doubleValue]);
            break;
        case XMNMessageTypeLocation:
        {
            NSRange rangeU = [model.data rangeOfString:@"locationUrl="];
            NSRange rangeT = [model.data rangeOfString:@"&locationText="];
            NSRange locationUrl = NSMakeRange(rangeU.location+rangeU.length, rangeT.location-rangeU.location-rangeU.length);
            messageDict[kXMNMessageConfigurationLocationKey] = [model.data substringWithRange:locationUrl];
            messageDict[kXMNMessageConfigurationTextKey] = [model.data substringFromIndex:(rangeT.location+rangeT.length)];
          
        }
            break;
        case XMNMessageTypeVideo:
        {
            
            messageDict[kXMNMessageConfigurationVideoKey]= model.data;
            messageDict[kXMNMessageConfigurationImageKey]= model.videopic;
        }
            
            break;
        case XMNMessageTypeFiles:
        {
            messageDict[kXMNMessageConfigurationFileKey] = model.data;
            messageDict[kXMNMessageConfigurationFileStateKey] = @(0); //收消息后为未接收
//            messageDict[kXMNMessageConfigurationVideoKey]= model.data;
//            messageDict[kXMNMessageConfigurationImageKey]= model.videopic;
        }
            
            break;
        case XMNMessageTypeSystem:
//            messageDict[kXMNMessageConfigurationTextKey] = @"2015-11-22";

        default:
            break;
    }
    
    
    messageDict[kXMNMessageConfigurationAlarmKey] = model.sid;
    messageDict[kXMNMessageConfigurationTimeKey] = model.time;
    
//    messageDict[kXMNMessageConfigurationTimeScopeKey] = [self isTimeScopeType:model.time withDict:messageDict] ? @"begin" : @"during";
    
    messageDict[kXMNMessageConfigurationTypeKey] = @(messageType);
    
    messageDict[kXMNMessageConfigurationOwnerKey] = @(messageType == XMNMessageTypeSystem ? XMNMessageOwnerSystem : XMNMessageOwnerOther);
    if ([model.sid isEqualToString:alarm]) {
        messageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    }
    messageDict[kXMNMessageConfigurationGroupKey] = @([@"G" isEqualToString:model.type] ? XMNMessageChatGroup : XMNMessageChatSingle);
    
    UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:model.sid];
    messageDict[kXMNMessageConfigurationAvatarKey] = uModel.RE_headpic;
    messageDict[kXMNMessageConfigurationNicknameKey] = uModel.RE_name;
    messageDict[kXMNMessageConfigurationDETypeKey] = model.DE_type;
    messageDict[kXMNMessageConfigurationDENameKey] = model.DE_name;

    
    
    if ([@"1" isEqualToString:model.cmd])
    {
        if ([model.FIRE containsString:@"LOCK"]) {
            messageDict[kXMNMessageConfigurationFireKey] = @"LOCK";
             if ([model.mtype isEqualToString:@"P"])
             {
                  messageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeFireImage);
             }
           
        }
    }
    else if ([@"2" isEqualToString:model.cmd])
    {
        
    }
    else if ([@"3" isEqualToString:model.cmd])
    {
        messageDict[kXMNMessageConfigurationTextKey] = model.data;
        messageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
        messageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
    }
    else if ([@"4" isEqualToString:model.cmd])
    {
        if ([model.mtype isEqualToString:@"7"]){
            messageDict[kXMNMessageConfigurationTextKey] = model.data;
            messageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeSystem);
            messageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSystem);
        }
    }
    
    if ([@"5" isEqualToString:model.cmd]) {//任务
        
        messageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeReleaseTask);
        messageDict[kXMNMessageConfigurationTextKey] = model.data;
        if ([model.sid isEqualToString:alarm]) {
            // 自己发送的消息
            messageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
        } else {
            // 别人发送的消息
            messageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerOther);
        }
        
        if ([model.mtype isEqualToString:@"S"]) {//疑情
            
            messageDict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([model.mtype isEqualToString:@"X"]) {;//聊天群创建侦察任务群
            
            messageDict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([model.mtype isEqualToString:@"N"]) {//通知（新增记录，标记）
            
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            messageDict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",model.taskNDataModel.workname];
        }else if ([model.mtype isEqualToString:@"P"]) {// "P":任务发布
            
            messageDict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([model.mtype isEqualToString:@"C"]) {//案件
            
            messageDict[kXMNMessageConfigurationWorkNameKey] = [NSString stringWithFormat:@"[发布新任务]"];
            
        }else if ([model.mtype isEqualToString:@"T"]) {//轨迹上传提醒
            
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            messageDict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",model.taskTDataModel.workname];
            
        }else if ([model.mtype isEqualToString:@"F"]) {// "F":任务结束通知
            NSMutableString *str = [NSMutableString stringWithString:@"[通知]"];
            messageDict[kXMNMessageConfigurationWorkNameKey] = [str stringByAppendingFormat:@"%@",model.taskFDataModel.workname];
            
        }else if ([model.mtype isEqualToString:@"A"]) {// "A":任务添加成员
            
            
        }else if ([model.mtype isEqualToString:@"D"]) {//删除疑情列表人员
            
        }
    }
    
    [self.delegate recieveMessage:messageDict];
}



-(BOOL)isTimeScopeType:(NSString *)time withDict:(NSMutableDictionary *)dict
{
//    if (!_isNotBegin) {
//        _isNotBegin = YES;
//        _beginTime = time;
//        dict[kXMNMessageConfigurationBeginTimeKey] = time;
//        
//        return YES;
//    }
//    
//    else
//    {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        
//        //后来的时间
//        NSDate *date = [formatter dateFromString:time];
//        //之前的时间
//        NSDate *begin =[formatter dateFromString:_beginTime];
//        
//        NSTimeInterval timeInterval = [begin timeIntervalSinceDate:date];
//        
//        NSLog(@"min:%f",timeInterval/60);
//        
//        long  min = [[NSNumber numberWithDouble:timeInterval] longValue];
//        
//        if (min/60 < 3)
//        {
//            dict[kXMNMessageConfigurationBeginTimeKey] = time;
//            return NO;
//        }
//        else
//        {
//            dict[kXMNMessageConfigurationBeginTimeKey] = time;
//            _beginTime = [formatter stringFromDate:date];
//            _isNotBegin =NO;
//            return YES;
//        }
//    }
    return YES;
}

// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}
#pragma mark - 保存图片
- (void) saveImage:(UIImage *)image withName:(NSString *)pngPath
{
    // Write image to PNG
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
}

@end
