//
//  RevisePassWordRequest.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/24.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "RevisePassWordRequest.h"

@implementation RevisePassWordRequest

+ (void)revisePasswordWithParam:(nonnull NSDictionary *)param success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *alarm = [user objectForKey:@"alarm"];
    NSString *token = [user objectForKey:@"token"];

//    NSString *url = [NSString stringWithFormat:ChangePassword_URL,alarm,token,param[@"oldpasswd"],param[@"newpasswd"],param[@"confirmpasswd"]];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"action"] = @"changepasswd";
    parameter[@"alarm"] = alarm;
    parameter[@"token"] = token;
    parameter[@"oldpasswd"] = param[@"oldpasswd"];
    parameter[@"newpasswd"] = param[@"newpasswd"];
    parameter[@"confirmpasswd"] = param[@"confirmpasswd"];
    

    [[HttpsManager sharedManager] post:ChangePassword_URL parameters:parameter progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response                                                             options:NSJSONReadingMutableContainers error:nil];
        successBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
    
}



@end
