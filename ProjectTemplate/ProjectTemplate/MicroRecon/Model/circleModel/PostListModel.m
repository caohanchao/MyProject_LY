//
//  PostListModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostListModel.h"

@implementation PostListModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm" : @"alarm",
             @"comment"        : @"comment",
             @"department"        : @"department",
             @"headpic"        : @"headpic",
             @"ispraise"        : @"ispraise",
             @"mode"        : @"mode",
             @"picture"        : @"picture",
             @"position"        : @"position",
             @"postid"        : @"postid",
             @"posttype"        : @"posttype",
             @"praisenum"        : @"praisenum",
             @"publishname"        : @"publishname",
             @"pushtime"        : @"pushtime",
             @"text"        : @"text"
             };
}

@end
