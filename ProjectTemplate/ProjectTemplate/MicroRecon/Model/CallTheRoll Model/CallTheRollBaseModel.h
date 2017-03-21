//
//  CallTheRollBaseModel.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface CallTheRollBaseModel : BaseResponseModel


@property (nonatomic, strong, nonnull) NSDictionary *results;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;

@end
