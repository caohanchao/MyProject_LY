//
//  WorkAllTempModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkAllTempModel.h"


@implementation WorkAllTempModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm"  : @"alarm",
             @"audio"    : @"audio",
             @"content"     : @"content",
             @"create_time" : @"create_time",
             @"department" : @"department",
             @"direction" : @"direction",
             @"gid" : @"gid",
             @"headpic" : @"headpic",
             @"interid" : @"interid",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"orderid" : @"orderid",
             @"mode" : @"mode",
             @"picture" : @"picture",
             @"position" : @"position",
             @"realname" : @"realname",
             @"title" : @"title",
             @"type" : @"type",
             @"video" : @"video"
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

- (nonnull instancetype)initWithGetrecordByGroupModel:(nonnull GetrecordByGroupModel *)model {
    self = [super init];
    if (self) {
        self.alarm = model.alarm;
        self.audio = model.audio;
        self.content = model.content;
        self.create_time = model.create_time;
        self.department = model.department;
        self.direction = model.direction;
        self.gid = model.gid;
        self.headpic = model.headpic;
        self.interid = model.interid;
        self.latitude = model.latitude;
        self.longitude = model.longitude;
        self.orderid = model.orderid;
        self.mode = model.mode;
        self.picture = model.picture;
        self.position = model.position;
        self.realname = model.realname;
        self.title = model.title;
        self.type = model.type;
        self.video = model.video;
        self.workId = model.workid;
    }
    return self;
    
}
- (nonnull instancetype)initWithICometModel:(nonnull ICometModel *)model {
    self = [super init];
    if (self) {
        self.alarm = model.sid;
        self.audio = model.taskNDataModel.audio;
        self.content = model.taskNDataModel.content;
        self.create_time = model.beginTime;
        self.department = @"";
        self.direction = model.taskNDataModel.direction;
        self.gid = model.rid;
        self.headpic = model.headpic;
        self.interid = model.taskNDataModel.dataid;
        self.latitude = model.latitude;
        self.longitude = model.longitude;
        self.orderid = @"";
        self.mode = model.taskNDataModel.type;
        self.picture = model.taskNDataModel.picture;
        self.position = @"";
        self.realname = @"";
        self.title = model.taskNDataModel.title;
        self.type = model.taskNDataModel.markType;
        self.video = model.taskNDataModel.video;
        self.workId = model.taskNDataModel.workid;
    }
    return self;
}
@end
