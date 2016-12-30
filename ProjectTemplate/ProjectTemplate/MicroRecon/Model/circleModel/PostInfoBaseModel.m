//
//  PostInfoBaseModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostInfoBaseModel.h"
#import "PostInfoModel.h"
#import "CommentModel.h"

@implementation PostInfoBaseModel

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
             @"praiseuser"        : @"praiseuser",
             @"commentinfo"        : @"commentinfo",
             @"publishname"        : @"publishname",
             @"pushtime"        : @"pushtime",
             @"text"        : @"text"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:@"praiseuser"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:PostInfoModel.class];
    }
    else if ([key isEqualToString:@"commentinfo"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:CommentModel.class];
    }
    return nil;
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",dict);
    PostInfoBaseModel *model = [MTLJSONAdapter modelOfClass:[PostInfoBaseModel class]
                                      fromJSONDictionary:dict[@"response" ]
                                                   error:nil];
    
    ZEBLog(@"%@",model);
    
    return model;
}


@end
