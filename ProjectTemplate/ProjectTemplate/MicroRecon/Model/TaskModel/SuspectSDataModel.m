//
//  SuspectSDataModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SuspectSDataModel.h"

@implementation SuspectSDataModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"gid"       : @"gid",
             @"suspectid"       : @"suspectid",
             @"name"       : @"name",
             @"suspectname" :   @"suspectname"
             };
}

@end
