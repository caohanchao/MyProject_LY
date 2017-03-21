//
//  RevisePassWordRequest.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/24.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevisePassWordRequest : NSObject

/**
 获取点名列表
 
 @param typeParam "0" 标示我接受的 "1" 标示我创建的
 @param successBlock  成功回调
 @param failureBlock  失败回调
 */

/**
  获取点名列表

 @param param oldpasswd, newpasswd, confirmpasswd
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)revisePasswordWithParam:(nonnull NSDictionary *)param success:(nonnull void(^)(id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;


@end
