//
//  VdBaseResultModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface VdBaseResultModel : BaseResponseModel


@property (nonatomic, strong, nonnull) NSArray *results;
//@property (nonatomic, copy, nonnull) NSString *footer;
//@property (nonatomic, copy, nonnull) NSString *total;
/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;

@end
