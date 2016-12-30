//
//  GetPathModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetPathModel.h"
#import "GetPathLocationModel.h"

@implementation GetPathModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm"  : @"alarm",
             @"end_latitude"    : @"end_latitude",
             @"end_longitude"    : @"end_longitude",
             @"end_posi"    : @"end_posi",
             @"end_time"    : @"end_time",
             @"gid"    : @"gid",
             @"head_pic"    : @"head_pic",
             @"location_list"    : @"location_list",
             @"name"    : @"name",
             @"position"    : @"position",
             @"route_id"    : @"route_id",
             @"route_title"    : @"route_title",
             @"start_latitude"    : @"start_latitude",
             @"start_longitude"    : @"start_longitude",
             @"start_posi"    : @"start_posi",
             @"start_time"    : @"start_time",
             @"task_id"    : @"task_id",
             @"token"    : @"token",
             @"type"    : @"type",
             @"describetion"    : @"describetion"
             };
}

    


+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"location_list"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:GetPathLocationModel.class];
    }
    return nil;
}
@end
