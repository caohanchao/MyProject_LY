//
//  PostPraiseUserSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostInfoModel.h"

@interface PostPraiseUserSQ : NSObject
+ (instancetype)PostPraiseUserSQ;

// 插入一条信息到列表
- (BOOL)insertPostPraise:(PostInfoModel *)model withPostID:(NSString*)postID;
//事务插入动态信息
- (void)transactionInsertPostPraiseModel:(NSArray *)array withPostID:(NSString*)postID;

// 查询所有
- (NSMutableArray *)selectPostPraiseWithPostid:(NSString*)postID;
//// 查询根据id
//- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid;

// 删除
- (BOOL)deletePostListByPuid:(NSString *)puid WithPostid:(NSString*)postID;

// 删除这条动态所有点赞
- (BOOL)deletePostListWithPostid:(NSString*)postID;

////更新数据库
//- (BOOL)updataPostList:(PostInfoModel*)model;

// 清除表
- (BOOL) clearPostPraise;
@end
