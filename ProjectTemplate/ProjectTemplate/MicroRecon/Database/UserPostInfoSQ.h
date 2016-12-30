//
//  UserPostInfoSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardPostInfoModel.h"

@interface UserPostInfoSQ : NSObject

+ (instancetype)UserPostInfoSQ;

//事务插入动态信息
- (void)transactionInsertUserPostInfoModel:(NSArray *)array;

// 查询所有
- (NSMutableArray *)selectUserPostInfoWithAlarm:(NSString*)alarm;
//更新数据库
- (BOOL)updataUserPostInfo:(CardPostInfoModel*)model;

// 删除
- (BOOL)deleteUserPostInfoByPuid:(NSString *)puid;

- (BOOL)deleteUserPostInfoByAlarm:(NSString *)alarm;

// 查询根据id
- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid;

// 清除表
- (BOOL) clearUserPostInfo;
@end
