//
//  GroupLogic.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupLogic.h"
#import "HttpsManager.h"

@implementation GroupLogic

+ (nonnull instancetype)sharedManager {
    
    static GroupLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

- (void) logicGetGroupInfoByGroupId:(NSString *)gid progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    NSString *urlString = Group_URL;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"getgroupinfo";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = @"xxx";
    paramDict[@"gid"] = gid;
    
    [[HttpsManager sharedManager] post:urlString parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

@end
