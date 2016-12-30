//
//  PhysicsRequest.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhysicsRequest : NSObject

/**
获取轨迹

 @param alarm 警号
 @param gid 群id
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
//+ (void)postPhysicsWithAlarm:(nonnull NSString *)alarm WithGid:(nonnull NSString *)gid WithWorkID:(nonnull NSString *)workId success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;



/**
上传轨迹

 @param param 传递字段
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)postUploadPhysicsWithParam:(nonnull NSDictionary *)param success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

@end
