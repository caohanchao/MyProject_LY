//
//  TaskFDataModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TaskFDataModel.h"

@implementation TaskFDataModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"workname"       : @"workname",
             @"workid"       : @"workid",
             @"dataid"       : @"dataid"
             };
}

@end
