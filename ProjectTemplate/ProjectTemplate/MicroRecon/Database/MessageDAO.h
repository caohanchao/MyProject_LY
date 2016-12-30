//
//  MessageDAO.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  对聊天记录表操作的DAO

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ICometModel.h"
#import "UserChatModel.h"

@interface MessageDAO : NSObject

//根据FMDatabase获取MessageDAO对象
+ (instancetype)messageDAO;

// 插入一条新的消息
- (BOOL)insertMessage:(ICometModel *)model;

//获取系统提醒消息
- (NSMutableArray *)selectSystemMessageByPage:(NSInteger)page;

// 根据qid查询消息
- (ICometModel *)selectMessageByQid:(NSInteger)qid;
// 根据msgid查询消息
- (ICometModel *)selectMessageByMsgid:(NSString *)msgid;
// 获取指定页码的消息列表
- (NSArray *)selectMessages:(NSString *)chatType maxQid:(NSInteger)maxQid page:(NSInteger)page;

// 获取消息分页
- (int)getSelectMessagesCount:(NSString *)chatType;


// 获取最大Qid
- (NSInteger)getMaxQid;
- (NSInteger)getMaxQidSingle;
- (NSInteger)getMaxQidGroup;


//删除指定的应用数据 根据指定的ID
- (BOOL)clearGroupMessage:(NSString *)_id ;
// 更新消息信息
- (BOOL)updateQidfireUserlist:(NSString *)qid fire:(NSString *)fire;
// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateUserlist:(ICometModel *)model;
// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateUserlistOfchatModel:(chatModel *)model;
// 插入一条新的消息
- (BOOL)insertMessageOfchatModell:(chatModel *)model;
// 更新消息信息
- (BOOL)updateUserlistOfchatModel:(chatModel *)model;
// 获取最小Qid
- (NSInteger)getMinQidSingle;
// 获取最小Qid
- (NSInteger)getMinQidGroup;
// 根据messageID更新消息信息
//- (BOOL)updateUserlist:(ICometModel *)model messageID:(NSString *)messageID;
//- (void)updateMessage:(ICometModel *)model;
// 根据Msgid删除消息
- (BOOL)deleteMessageForMsgid:(NSString *)msgid;
- (BOOL)updateMsgfireUserlist:(NSString *)msgid fire:(NSString *)fire  ;
- (BOOL)updateMsgTimeUserlist:(NSString *)msgid fire:(NSString *)timerStr;
// 根据msgid查询消息
- (chatModel *)selectChatMessageByMsgid:(NSString *)msgid;

@end
