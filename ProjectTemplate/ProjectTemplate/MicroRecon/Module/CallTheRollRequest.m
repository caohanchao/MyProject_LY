//
//  CallTheRollRequest.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollRequest.h"
#import "CallTheRollBaseModel.h"
@implementation CallTheRollRequest

+ (void)getCallTheRollList:(nonnull NSString *)typeParam success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:GetRallcalllist_URL,alarm,token,typeParam];
//    NSString *url = @"http://112.74.129.54/MicroRecon/1.2/rallcalllist?type=0&token=1f0f1b5260c400d779b8f18d54ef8fab&action=rallcalllist&alarm=VzVbuUizer2i3FzIEqEN";
    NSDictionary *param = [NSDictionary dictionary];
    [[HttpsManager sharedManager] get:url parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        CallTheRollBaseModel*baseModel = [CallTheRollBaseModel getInfoWithData:response];
        
        successBlock(baseModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
}

+ (void)GetReportActive:(nonnull NSString *)activestate withReportId:(nonnull NSString *)reportId success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:GetReportActive_URL,alarm,token,reportId,activestate];
    
    NSDictionary *param = [NSDictionary dictionary];
    [[HttpsManager sharedManager] get:url parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        successBlock(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
}

+ (void)GetReport:(nonnull NSDictionary *)info success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:ReportRall_URL,alarm,token,info[@"rallcallid"],info[@"latitude"],info[@"longitude"],info[@"position"]];
    NSDictionary *param = [NSDictionary dictionary];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[HttpsManager sharedManager] get:url parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        successBlock(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
    
}


@end
