//
//  UserFollowSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageListModel.h"

@interface UserFollowSQ : NSObject

+ (instancetype)UserFollowSQ;

// 插入一条信息到列表
- (BOOL)insertUserFollow:(HomePageListModel *)model withUserAlarm:(NSString*)userAlarm;

//事务插入动态信息
- (void)transactionInsertHomePageListModel:(NSArray *)array withUserAlarm:(NSString*)userAlarm;

// 查询
- (NSMutableArray *)selectUserFollowWithUserAlarm:(NSString*)userAlarm;

// 删除
- (BOOL)deleteUserFollowWithUserAlarm:(NSString*)userAlarm withAlarm:(NSString*)alarm;
- (BOOL)deleteUserFollowWithPostid:(NSString*)postID;

// 清除表
- (BOOL) clearUserFollow;

@end
