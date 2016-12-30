//
//  HomePageListModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "HomePageListModel.h"

@implementation HomePageListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"department" : @"department",
             @"alarm"        : @"alarm",
             @"name"        : @"name",
             @"headpic"        : @"headpic",
             @"time"        : @"time"
             };
}

@end
