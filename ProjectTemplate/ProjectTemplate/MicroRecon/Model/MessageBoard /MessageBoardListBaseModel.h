//
//  MessageBoardListBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"
#import "MessageBoardListModel.h"

@interface MessageBoardListBaseModel : BaseResponseModel

@property (nonatomic, strong, nonnull) NSArray *results;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
