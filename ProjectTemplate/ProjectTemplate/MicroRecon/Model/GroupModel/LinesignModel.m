//
//  LinesignModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "LinesignModel.h"

@implementation LinesignModel+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"SG_alarm"  : @"SG_alarm",
             @"SG_audio"    : @"SG_audio",
             @"SG_camera_direction"     : @"SG_camera_direction",
             @"SG_camera_id" : @"SG_camera_id",
             @"SG_content" : @"SG_content",
             @"SG_gid" : @"SG_gid",
             @"SG_gps_h" : @"SG_gps_h",
             @"SG_gps_position" : @"SG_gps_position",
             @"SG_gps_w" : @"SG_gps_w",
             @"SG_picture" : @"SG_picture",
             @"SG_signid" : @"SG_signid",
             @"SG_signtime" : @"SG_signtime",
             @"SG_title" : @"SG_title",
             @"SG_type" : @"SG_type",
             @"SG_video" : @"SG_video",
             @"SG_workid" : @"SG_workid"
             };
}

@end
