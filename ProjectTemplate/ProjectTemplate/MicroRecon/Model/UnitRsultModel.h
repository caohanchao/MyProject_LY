//
//  UnitRsultModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface UnitRsultModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, strong) NSArray *departall;
@property (nonatomic, nonnull, strong) NSArray *userall;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;


@end
