//
//  PostListBaseModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostListBaseModel.h"
#import "PostListModel.h"

@implementation PostListBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:PostListModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",dict);
    PostListBaseModel *model = [MTLJSONAdapter modelOfClass:[PostListBaseModel class]
                                              fromJSONDictionary:dict
                                                           error:nil];
    ZEBLog(@"%@",model.results);
    
    return model;
}

@end
