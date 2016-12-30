//
//  GetPathLocationModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetPathLocationModel.h"

@implementation GetPathLocationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"angle"  : @"angle",
             @"latitude"    : @"latitude",
             @"longitude"    : @"longitude",
             @"time"    : @"time",
             @"type"    : @"type"
             };
}
@end
