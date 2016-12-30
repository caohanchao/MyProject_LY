//
//  PrivacyPostListSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostListModel.h"

@interface PrivacyPostListSQ : NSObject

+ (instancetype)PrivacyPostListSQ;

// 插入一条信息到私密列表
- (BOOL)insertPrivacyPostList:(PostListModel *)model;
//事务插入动态信息
- (void)transactionInsertPostListModel:(NSArray *)array;
// 查询私密动态
- (NSMutableArray *)selectPrivacyPostList;
// 查询根据id
- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid;
// 删除私密动态依据ppuid
- (BOOL)deletePrivacyPostListByPPuid:(NSString *)ppuid;
//更新私密数据库
- (BOOL)updataPrivacyPostList:(PostListModel*)model;

// 清除表
- (BOOL) clearPrivacyPostPost;

@end
