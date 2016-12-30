//
//  FriendLogic.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendLogic.h"
#import "HttpsManager.h"

@implementation FriendLogic
//@"http://112.74.129.54:80/MicroRecon/1.1/friendadd?osType=ios&action=friendadd&alarm=%@&token=%@&sid=%@&rid=%@&data=%@"
/**
 *  业务逻辑管理组件单例
 *
 *  @return FriendLogic
 */
+ (nonnull instancetype)sharedManager {
    static FriendLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

- (void) logicAddFriend:(NSString *)fid message:(NSString *)data progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"friendadd";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"sid"] = alarm;
    paramDict[@"data"] = data;
    paramDict[@"rid"] = fid;
    
    [[HttpsManager sharedManager] post:FriendAddURL parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

/**
 *  同意添加好友请求
 */
- (void) logicAgreeFriend:(NSString *)fid progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"friendagree";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"sid"] = alarm;
    paramDict[@"rid"] = fid;
    
    [[HttpsManager sharedManager] post:FriendAgreeURL parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

@end
