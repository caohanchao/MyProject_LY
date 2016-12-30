//
//  SuspectAlllistSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuspectlistModel.h"


@interface SuspectAlllistSQ : NSObject

+ (instancetype)suspectAlllistSQ;


- (BOOL)insertSuspectAlllist:(SuspectlistModel *)model;
// 查询队应群的任务列表
- (NSMutableArray *)selectSuspectlistByGid:(NSString *)gid;
- (void)transactionInsertSuspectAlllist:(NSArray *)array;
// 根据workid查询任务
- (SuspectlistModel *)selectSuspectByWorkId:(NSString *)workId;
@end
