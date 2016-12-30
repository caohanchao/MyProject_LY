//
//  SuspectModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SuspectModel.h"

@implementation SuspectModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"workid"  : @"id",
             @"suspectname"    : @"suspectname"
             };
}


@end
