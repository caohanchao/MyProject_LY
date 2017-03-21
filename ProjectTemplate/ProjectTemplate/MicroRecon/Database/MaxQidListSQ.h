//
//  MaxQidListSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/7.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICometModel.h"

@interface MaxQidListSQ : NSObject

+ (instancetype)maxQidlistSQ;

// 插入一条信息到列表
- (BOOL)insertMaxQid:(NSInteger)qid;
// 插入一条信息到列表
- (BOOL)insertMaxQidlist:(ICometModel *)model;
//事务插入（处理大量数据）
- (void)transactioninsertMaxQidlist:(NSArray *)array;
// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateMaxQidlist:(ICometModel *)model;
//更新数据库
- (BOOL)updataMaxQidlist:(ICometModel*)model;
// 根据id查询在消息列表对应的消息
- (NSInteger)selectMaxQidByChatId:(NSString *)Id;
// 查询最大qid
- (NSInteger)selectmaxQid;
// 清除表
- (BOOL) clearMaxQidlist;

@end
