//
//  UserlistDAO.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  对消息列表操作的DAO

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ICometModel.h"
#import "UserlistModel.h"

@interface UserlistDAO : NSObject

//根据FMDatabase获取UserlistDAO对象
+ (instancetype)userlistDAO;

// 插入一条信息到消息列表
- (BOOL)insertUserlist:(ICometModel *)model;

// 更新消息列表信息
- (BOOL)updateUserlist:(ICometModel *)model;

// 根据id查询在消息列表对应的消息
- (UserlistModel *)selectUserlistById:(NSString *)chatId;

// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateUserlist:(ICometModel *)model;

// 删除指定id的消息
- (BOOL)deleteUserlist:(NSString *)chatId;

// 查询所有的消息
- (NSMutableArray *)selectUserlists;

// 清除新消息数量
- (BOOL)clearNewMsgCout:(NSString *)chatId;

// 根据id获取对应的新消息数量
- (NSInteger)selectNewMsgCountById:(NSString *)chatId;
// 清除@我的消息
- (void)clearAtAlarmMsg:(NSString *)chatId;
// 清除表
- (BOOL) clearUserlist;
@end
