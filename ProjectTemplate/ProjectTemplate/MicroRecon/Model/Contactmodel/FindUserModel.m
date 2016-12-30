//
//  FindUserModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FindUserModel.h"

@implementation FindUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"RE_alarmNum" : @"RE_alarmNum",
             @"RE_department"        : @"RE_department",
             @"RE_headpic"        : @"RE_headpic",
             @"RE_nickname"        : @"RE_nickname",
             @"RE_phonenum"        : @"RE_phonenum",
             @"RE_useralarm"       : @"RE_useralarm"
             };
}

@end
