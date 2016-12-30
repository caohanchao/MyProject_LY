//
//  UserFansSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageListModel.h"

@interface UserFansSQ : NSObject

+ (instancetype)UserFansSQ;

// 插入一条信息到列表
- (BOOL)insertUserFans:(HomePageListModel *)model withUserAlarm:(NSString*)userAlarm;

//事务插入动态信息
- (void)transactionInsertHomePageListModel:(NSArray *)array withUserAlarm:(NSString*)userAlarm;

// 查询
- (NSMutableArray *)selectUserFansWithUserAlarm:(NSString*)userAlarm;

// 删除
- (BOOL)deleteUserFansWithUserAlarm:(NSString*)userAlarm withAlarm:(NSString*)alarm;

- (BOOL)deleteUserFansWithPostid:(NSString*)postID;
// 清除表
- (BOOL) clearUserFans;

@end
