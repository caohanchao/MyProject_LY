//
//  CardPostInfoModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CardPostInfoModel.h"

@implementation CardPostInfoModel

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

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    CardPostInfoModel *model = [MTLJSONAdapter modelOfClass:[CardPostInfoModel class]
                                    fromJSONDictionary:data
                                                 error:nil];
    
    return model;
}

@end
