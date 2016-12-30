//
//  FriendsListModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface FriendsListModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *headpic; // 头像
@property (nonatomic, nonnull, copy) NSString *alarm; // 身份唯一标识
@property (nonatomic, nonnull, copy) NSString *phone; // 手机号
@property (nonatomic, nonnull, copy) NSString *name; // 名称
@property (nonatomic, nonnull, copy) NSString *nickname; // 名称
@property (nonatomic, nonnull, copy) NSString *useralarm; // 警号

@end
