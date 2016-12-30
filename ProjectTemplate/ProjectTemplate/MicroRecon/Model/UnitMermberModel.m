//
//  UnitMermberModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitMermberModel.h"

@implementation UnitMermberModel



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"RE_alarmNum"  : @"RE_alarmNum",
             @"RE_department"    : @"RE_department",
             @"RE_headpic"     : @"RE_headpic",
             @"RE_name" : @"RE_name",
             @"RE_nickname" : @"RE_nickname",
             @"RE_office" : @"RE_office",
             @"RE_phonenum" : @"RE_phonenum",
             @"RE_ptime" : @"RE_ptime",
             @"RE_status" : @"RE_status"
             };
}

@end
