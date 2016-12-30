//
//  ForwardMSGLogic.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForwardMSGLogic : NSObject
/**
 *  业务逻辑管理组件单例
 *
 *  @return ForwardMSGLogic
 */
+ (nonnull instancetype)sharedManager;

/**
 *  处理转发的业务逻辑
 */

NS_ASSUME_NONNULL_BEGIN//去警告

- (void) forwardMessageWithQID:(NSInteger)qid withUsers:(NSArray *)users withGroups:(NSArray *)groups  progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

- (void) forwardMessageWithUrl:(NSString*)imageUrl withUsers:(NSArray *)users withGroups:(NSArray *)groups  withgpsH:(NSString*)gpsH withgpsW:(NSString*)gpsW progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

NS_ASSUME_NONNULL_END


@end
