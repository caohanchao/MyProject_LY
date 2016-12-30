//
//  ChatLogic.h
//  ProjectTemplate
//
//  Created by Jomper Chow on 16/7/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(_Nonnull id aResponseObject,NSError * _Nullable  anError);

@interface ChatLogic : NSObject

/**
 *  业务逻辑管理组件单例
 *
 *  @return LogicManager
 */
+ (nonnull instancetype)sharedManager;

/**
 * 发送消息
 */
- (void) logicSendMessage:(nonnull NSString *)content progress:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 * 获取历史消息
 */
- (void) logicGetHistoryMessage:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 * 切换消息推送方式:0.长连接通道 1.APNS
 */
- (void) switchPushLogicWithPushType:(nonnull NSString *)pushType success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 * 心跳包
 */
- (void) logicSendHeartWithLatitude:(nonnull NSString *)latitude WithLongitude:(nonnull NSString *)longitude success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 *  处理转发的业务逻辑
 */
- (void) forwardMessageWithQID:(NSInteger)qid withUsers:(nonnull NSArray *)users withGroups:(nonnull NSArray *)groups  progress:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 *保存发送失败的消息

 @param message 发送失败的消息
 */
- (void) saveMessageWithMessageOfSendFailureState:(nonnull NSDictionary *)message WithMessageType:(nonnull NSString *)mtype WithCuid:(nonnull NSString *)cuid;

@end
