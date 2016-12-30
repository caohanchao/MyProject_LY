//
//  ShakeCameraModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeCameraModel.h"

@implementation ShakeCameraModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"ADDRESS"  : @"ADDRESS",
             @"CGH"    : @"CGH",
             @"FJID"    : @"FJID",
             @"FL"     : @"FL",
             @"gps_h" : @"gps_h",
             @"gps_w" : @"gps_w",
             @"IP" : @"IP",
             @"NAME"    : @"NAME",
             @"OBJECTID"    : @"OBJECTID",
             @"PCSID"     : @"PCSID",
             @"PHONE" : @"PHONE",
             @"PNAME" : @"PNAME"
             };
}

@end
