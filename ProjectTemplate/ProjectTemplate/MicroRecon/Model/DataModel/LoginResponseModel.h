//
//  LoginResponseModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface LoginResponseModel : BaseResponseModel

@property (nonatomic, nonnull, strong) NSArray *results;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) LoginWithData:(nonnull NSData *)data;

@end

@interface Login : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, copy) NSString *headpic; // 头像
@property (nonatomic, nonnull, copy) NSString *alarm; // 唯一标识
@property (nonatomic, nonnull, copy) NSString *token; // 登录成功返回的token
@property (nonatomic, nonnull, copy) NSString *name; // 名称
@property (nonatomic, nonnull, copy) NSString *username; // 名称
@property (nonatomic, nonnull, copy) NSString *useralarm;//警号

@end
