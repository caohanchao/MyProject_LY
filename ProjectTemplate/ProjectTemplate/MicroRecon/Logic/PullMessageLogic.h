//
//  PullMessageLogic.h
//  ProjectTemplate
//
//  Created by pullShit on 2016.8
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PullMSGCompletionBlock)(_Nonnull id aResponseObject,NSError * _Nullable  anError);

@interface PullMessageLogic : NSObject

@property (nonatomic)BOOL isFristPull;

/**
 *  拉取消息逻辑管理组件单例
 *
 *  @return LogicManager
 */
+ (nonnull instancetype)sharedManager;

/**
 * 获取历史消息
 */
NS_ASSUME_NONNULL_BEGIN

- (void) logicPullHistoryMessage:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock completion:(PullMSGCompletionBlock)completionBlock;


NS_ASSUME_NONNULL_END

@end
