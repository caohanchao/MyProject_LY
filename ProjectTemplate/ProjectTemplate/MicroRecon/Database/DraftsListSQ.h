//
//  DraftsListSQ.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkAllTempModel.h"

@interface DraftsListSQ : NSObject

+ (instancetype)draftsListSQ;

// 插入一条信息到草稿箱列表
- (BOOL)insertDraftsList:(WorkAllTempModel *)model;

// 查询草稿
- (NSMutableArray *)selectDraftsList:(NSString *)gid;

// 删除草稿依据cuid
- (BOOL)deleteDraftsListByCuid:(NSString *)cuid;

//更新数据库
- (BOOL)updataDraftsList:(WorkAllTempModel*)model;
@end
