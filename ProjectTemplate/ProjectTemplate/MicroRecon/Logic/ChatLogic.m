//
//  ChatLogic.m
//  ProjectTemplate
//
//  Created by Jomper Chow on 16/7/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatLogic.h"
#import "HttpsManager.h"
#import "BaseResponseModel.h"


@implementation ChatLogic

+ (nonnull instancetype)sharedManager {
    
    static ChatLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

- (void) logicSendMessage:(NSString *)content progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    NSString *urlString = Message_URL;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"sendmessage";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = @"xxx";
    paramDict[@"content"] = content;
    
    [[HttpsManager sharedManager] post:urlString parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        BaseResponseModel *baseModel = [BaseResponseModel ResponseWithData:reponse];
        
        if ([baseModel.resultcode isEqualToString:@"1016"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *chatId = [user objectForKey:@"chatId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHindNotfication" object:@"你们已经不是好友关系，无法直接发送消息"];
            
            [[[DBManager sharedManager] personnelInformationSQ] deletePersonelInfomationFriendsListModel:chatId];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFriendsNotification object:nil];
        }

        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

- (void) logicGetHistoryMessage:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"gethistory";
    paramDict[@"alarm"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    paramDict[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    paramDict[@"qid"] = [NSString stringWithFormat:@"%ld", [[[DBManager sharedManager] MessageDAO] getMaxQid]];
    [[HttpsManager sharedManager] get:Message_URL parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

- (void) switchPushLogicWithPushType:(nonnull NSString *)pushType success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"action"] = @"switchpush";
    parameters[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    parameters[@"device_info"] =[[NSUserDefaults standardUserDefaults] objectForKey:@"OSInfo"];
    parameters[@"os_info"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceInfo"];
    parameters[@"push_type"] = pushType;
    parameters[@"deviceToken"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    
    parameters[@"provider_url"] = Provider_URL;
    
    [[HttpsManager sharedManager] post:SwitchPushMessageUrl parameters:parameters progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
//        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
        
        successBlock(task, reponse);
        //        NSLog(@"------result:%@",dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(task, error);
    }];

    
}

- (void) logicSendHeartWithLatitude:(nonnull NSString *)latitude WithLongitude:(nonnull NSString *)longitude success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"token"] = token;
    params[@"alarm"] = alarm;
    
    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"])
    if ([model.locationSet boolValue]){
        if (![latitude isEqualToString:@""]){
            params[@"gps_h"] =longitude;
            
        }
        if (![longitude isEqualToString:@""]){
            params[@"gps_w"] =latitude;
        }
    }
//    if ([model.locationSet boolValue]){
//        params[@"gps_h"] = longitude;
//        params[@"gps_w"] = latitude;
//        
//    }else {
//        params[@"gps_h"] = @"";
//        params[@"gps_w"] = @"";
//    }
    [[HttpsManager sharedManager] post:Heart_URL parameters:params progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        successBlock(task,reponse);
        // ZEBLog(@"成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(task,error);
    }];
    
    
    
}

- (void) forwardMessageWithQID:(NSInteger)qid withUsers:(nonnull NSArray *)users withGroups:(nonnull NSArray *)groups  progress:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    
    ICometModel *iModel = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
    
    
    NSLog(@"%@",iModel);
    
    
    NSString *url = MSGForwardUrl;
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"transpond";
    paramDict[@"alarm"] = alarm;
    paramDict[@"mtype"] = iModel.mtype;
    paramDict[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    paramDict[@"msgdata"] = iModel.data;
    paramDict[@"users"] = [LZXHelper objArrayToJSON:users];
    paramDict[@"groups"] = [LZXHelper objArrayToJSON:groups];
    paramDict[@"gps_h"] = iModel.latitude;
    paramDict[@"gps_w"] = iModel.longitude;
    
    
    [[HttpsManager sharedManager] post:url parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        
        progressBlock(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        
        successBlock(task, reponse);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        failureBlock(task,error);
        
    }];
    
}

- (void) saveMessageWithMessageOfSendFailureState:(nonnull NSDictionary *)message WithMessageType:(nonnull NSString *)mtype WithCuid:(nonnull NSString *)cuid{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatType = [user objectForKey:@"chatType"];
    NSString *chatId = [user objectForKey:@"chatId"];
    NSString *alarm = [user objectForKey:@"alarm"];
    NSString *DE_type = [user objectForKey:DEType];
    NSString *DE_name = [user objectForKey:DEName];
    NSString *atAlarm = [user objectForKey:atAlarms];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    
    ICometModel *model = [[ICometModel alloc] init];
    UserInfoModel *userModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    NSInteger maxQid;
    if ([@"S" isEqualToString:chatType]) {
        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
    } else if ([@"G" isEqualToString:chatType]) {
        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
    }
   
    
    model.cmd = @"1";
    model.sid = alarm;
    model.atAlarm = atAlarm;
    model.rid = chatId;
    model.type = chatType;
    model.longitude = @"112";
    model.latitude = @"30";
    model.mtype = mtype;
    model.DE_type = DE_type;
    model.DE_name = DE_name;
    model.sname = userModel.name;
    model.headpic = userModel.headpic;
    model.time = time;
    model.qid = maxQid;
    model.cuid = cuid;
    
    model.messageState = @"2";
    
    if ([mtype isEqualToString:@"T"]) {
        model.data = message[kXMNMessageConfigurationTextKey];
        
    } else if ([mtype isEqualToString:@"P"]) {
        UIImage *image = message[kXMNMessageConfigurationImageKey];
        model.data = [LZXHelper stringWithUIImage:image];
        
    } else if ([mtype isEqualToString:@"S"]) {
        model.data = message[kXMNMessageConfigurationVoiceKey];
        model.voicetime = message[kXMNMessageConfigurationVoiceSecondsKey];
        
    } else if ([mtype isEqualToString:@"L"]) {
        NSString *locationText = message[kXMNMessageConfigurationTextKey];
        NSString *locationUrl = message[kXMNMessageConfigurationLocationKey];
        model.data = [NSString stringWithFormat:@"locationUrl=%@&locationText=%@", locationUrl, locationText];
        
    } else if ([mtype isEqualToString:@"V"]) {
        if ([message[kXMNMessageConfigurationImageKey] isKindOfClass:[UIImage class]]) {
            UIImage *image = message[kXMNMessageConfigurationImageKey];
            model.videopic = [LZXHelper stringWithUIImage:image];
            
        } else if ([message[kXMNMessageConfigurationImageKey] isKindOfClass:[NSString class]]) {
            model.videopic = message[kXMNMessageConfigurationImageKey];
        }
        
        model.data = [message[kXMNMessageConfigurationVideoKey] absoluteString];
        if ([message[kXMNMessageConfigurationVideoKey] isKindOfClass:[NSURL class]]) {
            model.data = [message[kXMNMessageConfigurationVideoKey] absoluteString];
            
        } else if ([message[kXMNMessageConfigurationVideoKey] isKindOfClass:[NSString class]]) {
            model.data = message[kXMNMessageConfigurationVideoKey];
        }

    }
    
    [[[DBManager sharedManager] messageResendSQ] insertMessage:model];
    
}

@end
