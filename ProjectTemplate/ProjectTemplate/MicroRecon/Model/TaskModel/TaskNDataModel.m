//
//  TaskNDataModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TaskNDataModel.h"

@implementation TaskNDataModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"workname"       : @"workname",
             @"workid"        : @"workid",
             @"dataid"        : @"dataid",
             @"content"       : @"content",
             @"picture"       : @"picture",
             @"audio"         : @"audio",
             @"type"          : @"type",
             @"video"         : @"video",
             @"title"         : @"title",
             @"markType"      : @"markType",
             @"direction"     : @"direction"
             };
}

@end
