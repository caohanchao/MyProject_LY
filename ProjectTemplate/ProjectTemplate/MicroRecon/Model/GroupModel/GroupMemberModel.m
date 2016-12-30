//
//  GroupMemberModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupMemberModel.h"

@implementation GroupMemberModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"headpic" : @"headpic",
             @"ME_gid"        : @"ME_gid",
             @"ME_jointime"        : @"ME_jointime",
             @"ME_nickname"        : @"ME_nickname",
             @"ME_permission"        : @"ME_permission",
             @"ME_share"        : @"ME_share",
             @"ME_uid"        : @"ME_uid"
             };
}


@end
