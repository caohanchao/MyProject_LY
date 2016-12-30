//
//  FriendLogic.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendLogic : NSObject

/**
 *  业务逻辑管理组件单例
 *
 *  @return FriendLogic
 */
+ (nonnull instancetype)sharedManager;

/**
 *  添加好友请求
 */
NS_ASSUME_NONNULL_BEGIN//去警告
- (void) logicAddFriend:(NSString *)fid message:(NSString *)data progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 *  同意添加好友请求
 */
- (void) logicAgreeFriend:(NSString *)fid progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;
NS_ASSUME_NONNULL_END
@end
