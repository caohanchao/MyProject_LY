//
//  TeamsListModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TeamsListModel.h"

@implementation TeamsListModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"admin"  : @"admin",
             @"count"    : @"count",
             @"creattime"    : @"creattime",
             @"gid"     : @"gid",
             @"gname" : @"gname",
             @"type" : @"type"
             };
}


@end
