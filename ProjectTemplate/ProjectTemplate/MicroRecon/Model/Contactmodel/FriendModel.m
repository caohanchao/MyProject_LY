//
//  FriendModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"RE_alarmNum"  : @"RE_alarmNum",
             @"RE_headpic"    : @"RE_headpic",
             @"RE_name"    : @"RE_name",
             @"RE_nickname"     : @"RE_nickname",
             @"RE_sex" : @"RE_sex",
             @"RE_post" : @"RE_post",
             @"RE_department" : @"RE_department"
             };
}


@end
