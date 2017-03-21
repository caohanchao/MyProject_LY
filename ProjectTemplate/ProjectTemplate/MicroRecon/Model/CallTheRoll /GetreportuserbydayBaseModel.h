//
//  GetreportuserbydayBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetreportuserbydayBaseModel : BaseResponseModel

@property (nonatomic, strong, nonnull) NSArray *results;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
