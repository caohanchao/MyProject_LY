//
//  PostListSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostListModel.h"

@interface PostListSQ : NSObject

+ (instancetype)PostListSQ;

// 插入一条信息到列表
- (BOOL)insertPostList:(PostListModel *)model;
//事务插入动态信息
- (void)transactionInsertPostListModel:(NSArray *)array;

// 查询所有
- (NSMutableArray *)selectPostList;
// 查询根据id
- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid;

// 删除
- (BOOL)deletePostListByPuid:(NSString *)puid;
//更新数据库
- (BOOL)updataPostList:(PostListModel*)model;

// 清除表
- (BOOL) clearPostList;


@end
