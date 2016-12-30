//
//  IntersignModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "IntersignModel.h"

@implementation IntersignModel+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm"  : @"alarm",
             @"audio"    : @"audio",
             @"camera_direction"     : @"camera_direction",
             @"camera_id" : @"camera_id",
             @"content" : @"content",
             @"creattime" : @"creattime",
             @"gid" : @"gid",
             @"gps_h" : @"gps_h",
             @"gps_w" : @"gps_w",
             @"picture" : @"picture",
             @"posi" : @"posi",
             @"remote_id" : @"remote_id",
             @"title" : @"title",
             @"type" : @"type",
             @"video" : @"video",
             @"workid" : @"workid"
             };
}

@end
