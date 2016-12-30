//
//  DepartmentlistSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UnitListModel.h"

@interface DepartmentlistSQ : NSObject


//根据FMDatabase获取UserlistDAO对象
+ (instancetype)departmentlistDAO;

// 插入一条信息到消息列表
- (BOOL)insertDepartmentlist:(UnitListModel *)model;
//事务插入消息（处理大量数据）
- (void)transactionInsertDepartmentlist:(NSArray *)array;
//// 更新消息列表信息
//- (BOOL)updateFrirndlist:(FriendsListModel *)model;

// 根据id查询在消息列表对应的消息
- (UnitListModel *)selectDepartmentlistById:(NSString *)Id;


//// 删除指定id的消息
//- (BOOL)deleteDepartmentlist:(NSString *)chatId;

// 查询所有的消息
- (NSMutableArray *)selectDepartmentlists;

//查询列表数
- (NSInteger)getCountsFromDB;

@end
