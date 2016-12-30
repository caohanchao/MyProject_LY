//
//  SuspectBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"
#import "SuspectModel.h"

@interface SuspectBaseModel : BaseResponseModel
@property (nonatomic, nonnull, strong) NSArray *results;
/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;
@end
