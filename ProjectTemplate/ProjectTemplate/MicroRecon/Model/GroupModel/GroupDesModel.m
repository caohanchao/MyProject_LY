//
//  GroupDesModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupDesModel.h"

@implementation GroupDesModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"count" : @"count",
             @"description1"        : @"description",
             @"gadmin"        : @"gadmin",
             @"gcreatetime"        : @"gcreatetime",
             @"gid"        : @"gid",
             @"gname"        : @"gname",
             @"gtype"        : @"gtype"
             };
}

@end
