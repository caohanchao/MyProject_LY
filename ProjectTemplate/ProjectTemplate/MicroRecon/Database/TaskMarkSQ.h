//
//  TaskMarkSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetrecordByGroupModel.h"
#import "ICometModel.h"

@interface TaskMarkSQ : NSObject

+ (instancetype)taskMarkSQ;

//从ICometModel中插入一个任务标记model
- (BOOL)insertTaskMarkFormICometModel:(ICometModel *)model;
//从ChatModel中插入一个任务标记model
- (BOOL)insertTaskMarkFormChatModel:(chatModel *)model;

- (GetrecordByGroupModel *)selectTaskMarkByInterid:(NSString *)interid;
// 插入一条信息到消息列表
- (BOOL)insertTaskMark:(GetrecordByGroupModel *)model;
// 查询队应群的任务标记
- (NSMutableArray *)selectTaskMarkByGid:(NSString *)gid;

- (void)transactionInsertTaskMark:(NSArray *)array;
@end
