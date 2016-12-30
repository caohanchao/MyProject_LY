//
//  AccountLogic.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountLogic : NSObject


/**
 *  业务逻辑管理组件单例
 *
 *  @return AccountLogic
 */
+ (nonnull instancetype)sharedManager;
NS_ASSUME_NONNULL_BEGIN//去警告
- (void) logicLogin:(NSString *)username password:(NSString *)password progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) logicReconnect:(NSString *)alarm token:(NSString *)token progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) logicLogout:(NSString *)alarm token:(NSString *)token progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;


- (void) logicSendTestCode:(NSString *)phoneNum  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) logicTestCodeNext:(NSString *)phoneNum code:(NSString *)messageCode password:(NSString *)password success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) logicSendTestCodeWithForget:(NSString *)phoneNum  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) logicTestCodeWithForgetNext:(NSString *)phoneNum code:(NSString *)messageCode password:(NSString *)password  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) logicRegister:(NSDictionary *)info progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;



NS_ASSUME_NONNULL_END
@end
