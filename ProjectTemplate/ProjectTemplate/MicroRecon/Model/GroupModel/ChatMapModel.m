//
//  ChatMapModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatMapModel.h"

@implementation ChatMapModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm" : @"alarm",
             @"department"        : @"department",
             @"gps_h"        : @"gps_h",
             @"gps_w"        : @"gps_w",
             @"headpic"        : @"headpic",
             @"name"        : @"name",
             @"phonenum"        : @"phonenum",
             @"status"        : @"status",
             @"time"        : @"time"
             };
}

@end
