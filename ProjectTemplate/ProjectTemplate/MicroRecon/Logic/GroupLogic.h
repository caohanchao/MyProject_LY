//
//  GroupLogic.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupLogic : NSObject

/**
 *  业务逻辑管理组件单例
 *
 *  @return GroupLogic
 */
+ (nonnull instancetype)sharedManager;
NS_ASSUME_NONNULL_BEGIN//去警告
- (void) logicGetGroupInfoByGroupId:(NSString *)gid progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;
NS_ASSUME_NONNULL_END
@end
