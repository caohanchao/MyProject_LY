//
//  GetPathBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"
#import "GetPathModel.h"


@interface GetPathBaseModel : BaseResponseModel


@property (nonatomic, nonnull, strong) NSArray *results;
/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;

@end
