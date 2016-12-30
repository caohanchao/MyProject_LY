//
//  PostCommentSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

@interface PostCommentSQ : NSObject
+ (instancetype)PostCommentSQ;

// 插入一条信息到列表
- (BOOL)insertPostComment:(CommentModel *)model;
//事务插入动态信息
- (void)transactionInsertPostCommentModel:(NSArray *)array;

// 查询所有
- (NSMutableArray *)selectPostCommentWithPostID:(NSString*)postID;
//// 查询根据id
//- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid;

// 删除这条动态所有评论
- (BOOL)deletePostListByPuid:(NSString *)postID;
////更新数据库
//- (BOOL)updataPostList:(CommentModel*)model;

// 清除表
- (BOOL) clearPostList;
@end
