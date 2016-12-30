//
//  SystemUpdataSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsPatchModel.h"


@interface SystemUpdataSQ : NSObject

+ (instancetype)systemUpdataSQ;

// 插入一条信息到消息列表
- (BOOL)insertSystemUpdatalist:(JsPatchModel *)model;
// 查询所有的消息
- (NSMutableArray *)selectSystemUpdatalist;
// 删除指定的消息
- (BOOL)deleteSystemUpdata:(NSString *)appVersion jsVersion:(NSString *)jsVersion;
@end
