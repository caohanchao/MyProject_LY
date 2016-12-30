//
//  GrouplistSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamsListModel.h"
#import "GroupDesModel.h"

@interface GrouplistSQ : NSObject

//根据FMDatabase获取UserlistDAO对象
+ (instancetype)grouplistDAO;

// 插入一条信息到消息列表
- (BOOL)insertGrouplist:(TeamsListModel *)model;
// 创建群成功插入一条信息到消息列表
- (BOOL)insertGrouplistGroupSuccess:(NSString *)gid gname:(NSString *)gname gadmin:(NSString *)gadmin gcreatetime:(NSString *)gcreatetime gtype:(NSString *)gtype gusercount:(NSString *)gusercount;
//事务插入消息（处理大量数据）
- (void)transactionInsertGrouplist:(NSArray *)array;
//更新群成员
- (BOOL)updateGroupMembers:(NSString *)member gid:(NSString *)gid;
// 根据id查询在消息列表对应的消息
- (TeamsListModel *)selectGrouplistById:(NSString *)chatId;

//// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
//- (BOOL)insertOrUpdateGrouplist:(TeamsListModel *)model;
- (void)transactionInsertOrUpdataGrouplist:(NSArray *)array;
// 删除指定id的消息
- (BOOL)deleteGrouplist:(NSString *)gid;
//更新名称
- (BOOL)updateGroupName:(NSString *)name gid:(NSString *)gid;
// 查询所有的消息
- (NSMutableArray *)selectGrouplists;

- (BOOL)updateGroupIsRemindSet:(NSString *)set gid:(NSString *)gid;
// 插入一条信息到列表
- (BOOL)insertGrouplistByGroupDesModel:(GroupDesModel *)model;
- (BOOL)insertOrUpdataGrouplistByGroupDesModel:(GroupDesModel *)model;
//查询列表数
- (NSInteger)getCountsFromDB;
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistGroupForGid:(NSString *)gid;
//更新群成员数量
- (BOOL)updateGroupMemberCount:(NSString *)count gid:(NSString *)gid;

@end
