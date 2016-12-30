//
//  ForwardMSGLogic.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ForwardMSGLogic.h"
#import "ICometModel.h"
#import "HttpsManager.h"
@implementation ForwardMSGLogic


+ (nonnull instancetype)sharedManager {
    
    static ForwardMSGLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}


- (void) forwardMessageWithQID:(NSInteger)qid withUsers:(NSArray *)users withGroups:(NSArray *)groups  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
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

- (void) forwardMessageWithUrl:(NSString*)imageUrl withUsers:(NSArray *)users withGroups:(NSArray *)groups  withgpsH:(NSString*)gpsH withgpsW:(NSString*)gpsW progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"transpond";
    paramDict[@"alarm"] = alarm;
    paramDict[@"mtype"] = @"P";
    paramDict[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    paramDict[@"msgdata"] = imageUrl;
    paramDict[@"users"] = [LZXHelper objArrayToJSON:users];
    paramDict[@"groups"] = [LZXHelper objArrayToJSON:groups];
    paramDict[@"gps_h"] =gpsH ;
    paramDict[@"gps_w"] = gpsW;
    
    
    [[HttpsManager sharedManager] post:MSGForwardUrl parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        
        progressBlock(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        successBlock(task, reponse);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(task,error);
        
    }];
}

@end
