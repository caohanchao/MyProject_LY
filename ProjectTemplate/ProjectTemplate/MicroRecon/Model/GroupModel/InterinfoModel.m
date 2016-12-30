//
//  InterinfoModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "InterinfoModel.h"

@implementation InterinfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm"  : @"alarm",
             @"audio"    : @"audio",
             @"content"     : @"content",
             @"creattime" : @"creattime",
             @"gid" : @"gid",
             @"gps_h" : @"gps_h",
             @"gps_w" : @"gps_w",
             @"interid" : @"interid",
             @"picture" : @"picture",
             @"position" : @"position",
             @"pushtime" : @"pushtime",
             @"title" : @"title",
             @"video" : @"video",
             @"workid" : @"workid"
             };
}
@end
