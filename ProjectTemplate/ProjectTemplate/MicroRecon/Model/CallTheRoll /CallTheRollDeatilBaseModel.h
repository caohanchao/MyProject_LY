//
//  CallTheRollDeatilBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "CallTheRollDeatilModel.h"

@interface CallTheRollDeatilBaseModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *resultcode; // 返回码
@property (nonatomic, nonnull, copy) NSString *resultmessage; // 返回信息
@property (nonatomic, strong, nonnull) CallTheRollDeatilModel *deatilModel;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
