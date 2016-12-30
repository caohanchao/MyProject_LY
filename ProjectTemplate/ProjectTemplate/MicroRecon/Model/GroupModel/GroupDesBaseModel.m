//
//  GroupDesBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupDesBaseModel.h"
#import "GroupDesModel.h"

@implementation GroupDesBaseModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:GroupDesModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    GroupDesBaseModel *model = [MTLJSONAdapter modelOfClass:[GroupDesBaseModel class]
                                    fromJSONDictionary:data
                                                 error:nil];
    
    ZEBLog(@"%@",model.results);
    
    return model;
}

@end
