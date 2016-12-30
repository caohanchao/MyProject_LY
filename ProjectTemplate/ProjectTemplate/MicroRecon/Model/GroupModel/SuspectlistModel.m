//
//  SuspectlistModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SuspectlistModel.h"

@implementation SuspectlistModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"create_time"  : @"create_time",
             @"createuser"    : @"createuser",
             @"gid"     : @"gid",
             @"gname" : @"gname",
             @"headpic" : @"headpic",
             @"suspectdec" : @"suspectdec",
             @"suspectid" : @"suspectid",
             @"suspectname" : @"suspectname",
             @"suspecttype" : @"suspecttype",
             @"username" : @"username"
             };
}
@end
