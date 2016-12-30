//
//  AccountLogic.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AccountLogic.h"
#import "HttpsManager.h"
#import "FMDB.h"

@implementation AccountLogic

+ (nonnull instancetype)sharedManager {
    
    static AccountLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

- (void) logicLogin:(NSString *)username password:(NSString *)password progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"userlogind";
    paramDict[@"alarm"] = username;
    paramDict[@"passwd"] = password;
    paramDict[@"serialnumber"] = @"213487123";

    
    [[HttpsManager sharedManager] post:Account_Login_URL parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];

    
}

- (void) logicReconnect:(NSString *)alarm token:(NSString *)token progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"connect";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    
    [[HttpsManager sharedManager] post:Account_URL parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

- (void) logicLogout:(NSString *)alarm token:(NSString *)token progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"userloginout";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    
    [[HttpsManager sharedManager] post:Account_URL parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        successBlock(task, reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

//发送验证码
- (void) logicSendTestCode:(NSString *)phoneNum  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_num"] = phoneNum;
    
    [[HttpsManager sharedManager] post:SendTestCode_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        successBlock(task, reponse);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self showHint:@"获取验证码失败"];
        failureBlock(task, error);
    }];

}
//下一步验证 验证码是否与手机号匹配或超时
- (void) logicTestCodeNext:(NSString *)phoneNum code:(NSString *)messageCode password:(NSString *)password success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phonenum"] = phoneNum;
    param[@"msgcode"] = messageCode;
    param[@"passwd"] = password;
    
    [[HttpsManager sharedManager] post:TestCode_URl parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        successBlock(task, reponse);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failureBlock(task, error);
    }];

}

//忘记密码
- (void) logicSendTestCodeWithForget:(NSString *)phoneNum  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_num"] = phoneNum;
    param[@"action"] = @"forget";
    param[@"appKey"] = @"23532292";
    param[@"appSecret"] = @"f9e68f9b4435054d53eba99cb70c86bf";
    param[@"url"] = @"http://gw.api.taobao.com/router/rest";
    param[@"TempCode"] = @"SMS_34430338";
    param[@"SignName"] = @"猎鹰";
    param[@"Extend"] = @"123456";
    param[@"SmsType"] = @"normal";
    param[@"arg1"] = @"wjwreg";
    
    [[HttpsManager sharedManager] post:SendTestCode_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        successBlock(task, reponse);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

//忘记密码下一步验证 验证码是否与手机号匹配或超时
- (void) logicTestCodeWithForgetNext:(NSString *)phoneNum code:(NSString *)messageCode password:(NSString *)password  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phonenum"] = phoneNum;
    param[@"password"] = password;
    param[@"msgcode"] = messageCode;
    param[@"action"] = @"forget";
    
    [[HttpsManager sharedManager] post:ForgetPassWord_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        successBlock(task, reponse);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

//注册信息
- (void) logicRegister:(NSDictionary *)info progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"]        = @"register";
    param[@"phonenum"]     = info[@"phonenum"];
    param[@"name"]          = info[@"name"];
    param[@"sex"]           = info[@"sex"];
    param[@"alarm"]         = info[@"alarm"];
    param[@"picture"]       = info[@"picture"];
    param[@"identitycard"]  = info[@"identitycard"];
    param[@"serialnumber"]  = info[@"serialnumber"];
    param[@"passwd"]        = info[@"passwd"];
    param[@"post"]          = info[@"post"];
    param[@"department"]    = info[@"department"];
//    param[@"mode"] = @"1";
    [[HttpsManager sharedManager] post:NewRegister_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        successBlock(task, reponse);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

@end
