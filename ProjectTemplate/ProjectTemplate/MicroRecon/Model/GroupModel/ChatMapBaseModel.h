//
//  ChatMapBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"
#import "ChatMapModel.h"

@interface ChatMapBaseModel : BaseResponseModel

@property (nonatomic, nonnull, strong) NSArray *results;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;
@end
