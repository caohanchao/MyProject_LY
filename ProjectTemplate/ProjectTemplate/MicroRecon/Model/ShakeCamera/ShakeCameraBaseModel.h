//
//  ShakeCameraBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface ShakeCameraBaseModel : BaseResponseModel

@property (nonatomic, strong, nonnull) NSArray *results;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
