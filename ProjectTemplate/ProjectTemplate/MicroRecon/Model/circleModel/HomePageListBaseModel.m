//
//  HomePageListBaseModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "HomePageListBaseModel.h"
#import "HomePageListModel.h"

@implementation HomePageListBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:HomePageListModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",dict);
    HomePageListBaseModel *model = [MTLJSONAdapter modelOfClass:[HomePageListBaseModel class]
                                         fromJSONDictionary:dict
                                                      error:nil];
    ZEBLog(@"%@",model.results);
    
    return model;
}

@end
