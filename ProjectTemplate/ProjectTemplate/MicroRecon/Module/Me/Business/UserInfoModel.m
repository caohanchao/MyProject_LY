//
//  UserInfoModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"headpic" : @"headpic",
             @"name"        : @"name",
             @"sex"        : @"sex",
             @"age"        : @"age",
             @"post"        : @"post",
             @"department"        : @"department",
             @"alarm"        : @"alarm",
             @"phonenum"        : @"phonenum",
             @"identitycard"        : @"identitycard",
             @"useralarm"           : @"RE_useralarm"
             };
}
- (nonnull instancetype)initWithFriendsListModel:(nonnull FriendsListModel *)model {
    self = [super init];
    if (self) {
        self.headpic = model.headpic;
        self.name = model.name;
        self.alarm = model.alarm;
        self.useralarm = model.useralarm;
        self.phonenum = model.phone;
    }
    return self;
}
@end
