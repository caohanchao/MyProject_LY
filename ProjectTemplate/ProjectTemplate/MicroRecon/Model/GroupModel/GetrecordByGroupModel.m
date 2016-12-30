//
//  GetrecordByGroupModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetrecordByGroupModel.h"

@implementation GetrecordByGroupModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm"  : @"alarm",
             @"content"    : @"content",
             @"create_time"     : @"create_time",
             @"department" : @"department",
             @"direction" : @"direction",
             @"gid" : @"gid",
             @"headpic" : @"headpic",
             @"interid" : @"interid",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"mode" : @"mode",
             @"orderid" : @"orderid",
             @"picture" : @"picture",
             @"position" : @"position",
             @"realname" : @"realname",
             @"title" : @"title",
             @"type" : @"type",
             @"video" : @"video",
             @"audio" : @"audio",
             @"workid" : @"workid"
             };
}
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"direction"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:
                ^id(NSNumber *number)
                {
                    return [NSString stringWithFormat:@"%@",number];
                } reverseBlock:^id(NSString *d) {
                    return @[d];
                }];
    }
    return nil;
}

@end
