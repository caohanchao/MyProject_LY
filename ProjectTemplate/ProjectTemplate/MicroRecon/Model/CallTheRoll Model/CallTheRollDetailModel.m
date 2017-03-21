//
//  CallTheRollDetailModel.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollDetailModel.h"

@implementation CallTheRollDetailModel



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"rallcallend"    : @"rallcallend",
             @"rallcalled" : @"rallcalled",
             @"rallcalling"        : @"rallcalling",
             @"rallcallfinish" :@"rallcallfinish"
             };
}


+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CallTheRollListDetailModel.class];
}

@end


@implementation CallTheRollListDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"active_state"    : @"active_state",
             @"self_state"    : @"self_state",
             @"sign_state"    : @"sign_state",
             @"title"    : @"title",
             @"publish_head_pic"    : @"publish_head_pic",
             @"latitude" : @"latitude",
             @"reportNum"        : @"reportNum",
             @"publish_name" :@"publish_name",
             @"countdown" :@"countdown",
             @"publish_alarm" :@"publish_alarm",
             @"week" :@"week",
             @"rallcallid" :@"rallcallid",
             @"userAllNum" :@"userAllNum",
             @"create_time" :@"create_time",
             @"workid" :@"workid",
             @"isrepeat" :@"isrepeat",
             @"start_time" :@"start_time",
             @"end_time" :@"end_time",
             @"keeptime" :@"keeptime",
             @"userlist" :@"userlist"
             };
}

//+ (NSValueTransformer *)latitudeJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:
//            ^id(NSNumber *number)
//            {
//                return [NSString stringWithFormat:@"%@",number];
//            } reverseBlock:^id(NSString *d) {
//                return @[d];
//            }];
//    
//}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"latitude"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:
                ^id(NSNumber *number)
                {
                    return [NSString stringWithFormat:@"%@",number];
                } reverseBlock:^id(NSString *d) {
                    return @[d];
                }];
    }
    if ([key isEqualToString:@"reportNum"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:
                ^id(NSNumber *number)
                {
                    return [NSString stringWithFormat:@"%@",number];
                } reverseBlock:^id(NSString *d) {
                    return @[d];
                }];
    }
    if ([key isEqualToString:@"countdown"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:
                ^id(NSNumber *number)
                {
                    return [NSString stringWithFormat:@"%@",number];
                } reverseBlock:^id(NSString *d) {
                    return @[d];
                }];
    }
    if ([key isEqualToString:@"userAllNum"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:
                ^id(NSNumber *number)
                {
                    return [NSString stringWithFormat:@"%@",number];
                } reverseBlock:^id(NSString *d) {
                    return @[d];
                }];
    }
//    if ([key isEqualToString:@"userlist"]) {
//        return [MTLJSONAdapter arrayTransformerWithModelClass:CallTheRollListUserListDetailModel.class];
//    }
    return nil;
}

//+ (NSValueTransformer *)reportNumJSONTransformer {
//    
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:
//            ^id(NSNumber *number)
//            {
//                return [NSString stringWithFormat:@"%@",number];
//            } reverseBlock:^id(NSString *d) {
//                return @[d];
//            }];
//    
//}
//+ (NSValueTransformer *)countdownJSONTransformer {
//    
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:
//            ^id(NSNumber *number)
//            {
//                return [NSString stringWithFormat:@"%@",number];
//            } reverseBlock:^id(NSString *d) {
//                return @[d];
//            }];
//    
//    
//}
//+ (NSValueTransformer *)userAllNumJSONTransformer {
//    
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:
//            ^id(NSNumber *number)
//            {
//                return [NSString stringWithFormat:@"%@",number];
//            } reverseBlock:^id(NSString *d) {
//                return @[d];
//            }];
//    
//}

//+ (NSValueTransformer *)userlistJSONTransformer {
//    
//    return [MTLJSONAdapter arrayTransformerWithModelClass:CallTheRollListUserListDetailModel.class];
//    
//}

@end

@implementation CallTheRollListUserListDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"report_name"    : @"report_name",
             @"report_alarm" : @"report_alarm",
             @"self_state"        : @"self_state"
             };
}


@end
