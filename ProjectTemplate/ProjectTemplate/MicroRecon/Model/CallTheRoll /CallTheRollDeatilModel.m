//
//  CallTheRollDeatilModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollDeatilModel.h"

@implementation CallTheRollDeatilModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"active_state"  : @"active_state",
             @"create_time"    : @"create_time",
             @"end_time"    : @"end_time",
             @"isrepeat"     : @"isrepeat",
             @"keeptime" : @"keeptime",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"position"    : @"position",
             @"ptime"    : @"ptime",
             @"publish_alarm"     : @"publish_alarm",
             @"publish_head_pic" : @"publish_head_pic",
             @"publish_name" : @"publish_name",
             @"rallcallid" : @"rallcallid",
             @"sign_state" : @"sign_state",
             @"start_time" : @"start_time",
             @"title" : @"title",
             @"userAllNum" : @"userAllNum",
             @"userlatitude" : @"userlatitude",
             @"userlist" : @"userlist",
             @"userlongitude" : @"userlongitude",
             @"week" : @"week",
             @"workid" : @"workid"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:@"userlist"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:CallTheRollUserListModel.class];
    } else if ([key isEqualToString:@"userAllNum"]) {
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


@implementation CallTheRollUserListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"department"  : @"department",
             @"position"    : @"position",
             @"report_alarm"    : @"report_alarm",
             @"report_headpic"     : @"report_headpic",
             @"report_name" : @"report_name",
             @"report_time" : @"report_time",
             @"self_state" : @"self_state",
             @"usergpsh"    : @"usergpsh",
             @"usergpsw"    : @"usergpsw",
             @"alarm" : @"alarm",
             @"ptime"    : @"ptime"
             };
}

- (void)setAlarm:(NSString *)alarm {
    _alarm = alarm;
    _report_alarm = _alarm;
}
@end
