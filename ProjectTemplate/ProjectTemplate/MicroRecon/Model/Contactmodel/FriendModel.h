//
//  FriendModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FriendModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *RE_alarmNum;
@property (nonatomic, nonnull, copy) NSString *RE_headpic;
@property (nonatomic, nonnull, copy) NSString *RE_name;
@property (nonatomic, nonnull, copy) NSString *RE_nickname;
@property (nonatomic, nonnull, copy) NSString *RE_sex;
@property (nonatomic, nonnull, copy) NSString *RE_post;
@property (nonatomic, nonnull, copy) NSString *RE_department;

@end
