//
//  UserCountInfoSQ.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardCountInfoModel.h"

@interface UserCountInfoSQ : NSObject

+ (instancetype)UserCountInfoSQ;


// 插入一条信息到列表
- (void)insertUserCount:(CardCountInfoModel *)model withUserAlarm:(NSString*)userAlarm;

// 查询
- (NSMutableArray *)selectUserCountWithUserAlarm:(NSString*)userAlarm;

//更新数据库
- (BOOL)updataUsrCount:(CardCountInfoModel*)model withUserAlarm:(NSString*)userAlarm;

// 清除表
- (BOOL) clearUserCount;

@end
