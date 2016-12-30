//
//  UploadingSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICometModel.h"
#import "UserlistModel.h"


@interface UploadingSQ : NSObject


+ (instancetype)uploadingDAO;
// 插入一条信息到列表
- (BOOL)insertUploading:(ICometModel *)model;
// 删除指定cuid的消息
- (BOOL)deleteUploading:(NSString *)cuid;
// 查询所有的消息
- (NSMutableArray *)selectUploading;
//- (NSMutableArray *)selectUploadingUserlistModel;
/// 根据cuid查询在消息列表对应的信息
- (ICometModel *)selectUploading:(NSString *)cuid;
@end
