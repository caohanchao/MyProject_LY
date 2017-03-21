//
//  MessageBoardListModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "MessageBoardListModel.h"

@implementation MessageBoardListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm"  : @"alarm",
             @"audio"    : @"audio",
             @"content"    : @"content",
             @"head_pic"     : @"head_pic",
             @"mark_id" : @"mark_id",
             @"name" : @"name",
             @"picture" : @"picture",
             @"position"    : @"position",
             @"record_id"    : @"record_id",
             @"record_time"     : @"record_time",
             @"token" : @"token",
             @"type" : @"type",
             @"video" : @"video"
             };
}

@end
