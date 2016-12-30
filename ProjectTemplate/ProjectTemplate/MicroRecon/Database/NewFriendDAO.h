//
//  NewFriendlistSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  新朋友数据库操作类

#import <Foundation/Foundation.h>
#import "NewFriendModel.h"

@interface NewFriendDAO : NSObject

//根据FMDatabase获取NewFriendDAO对象
+ (instancetype)newFriendDAO;

// 添加新朋友信息
- (BOOL)insertNewFriend:(NewFriendModel *)model;

// 查询指定警号的新朋友信息
- (NewFriendModel *)selectNewFriendByAlarm:(NSString *)alarm;

// 获取新朋友列表
- (NSArray *)selectNewFriends;

// 更新新朋友信息
- (BOOL)updateNewFriend:(NewFriendModel *)model;

// 删除新朋友信息
- (BOOL)deleteNewFriend:(NSString *)fid;

// 插入或更新新朋友数据
- (BOOL)insertOrUpdateNewFriend:(NewFriendModel *)model;

// 添加新朋友
- (BOOL)addNewFriend:(ICometModel *)model;

// 同意添加好友
- (BOOL)agree:(ICometModel *)model;

@end
