//
//  JsPatchModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "JsPatchModel.h"

@implementation JsPatchModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"appVersion"  : @"appVersion",
             @"jsDetailedInf"    : @"jsDetailedInf",
             @"jsUrl"     : @"jsUrl",
             @"jsVersion" : @"jsVersion",
             @"resultCode" : @"resultCode"
             };
}

@end
