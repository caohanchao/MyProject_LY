//
//  CallTheRollRequest.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallTheRollRequest : NSObject

/**
 获取点名列表

 @param typeParam "0" 标示我接受的 "1" 标示我创建的
 @param successBlock  成功回调
 @param failureBlock  失败回调
 */
+ (void)getCallTheRollList:(nonnull NSString *)typeParam success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;


/**
 激活或关闭点名

 @param activestate (0 未激活,1 激活)
 @param reportId 点名ID
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)GetReportActive:(nonnull NSString *)activestate withReportId:(nonnull NSString *)reportId success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;


/**
 报道接口

 @param Info   @"reportId"  点名的id  @"position"  位置的中文  @"latitude"  纬度  @"longitude" 经度
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)GetReport:(nonnull NSDictionary *)Info success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;



@end
