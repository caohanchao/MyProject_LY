//
//  GroupInfoResponseModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GroupInfoResponseModel : BaseResponseModel

@property (nonatomic, nonnull, strong) NSArray *groups;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) groupInfoWithData:(nonnull NSData *)data;

@end

@interface GroupInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, copy) NSString *gname; // 群名称
@property (nonatomic, nonnull, copy) NSString *gtype; // 群类型

@end
