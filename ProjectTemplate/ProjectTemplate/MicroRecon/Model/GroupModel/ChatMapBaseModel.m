//
//  ChatMapBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatMapBaseModel.h"


@implementation ChatMapBaseModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:ChatMapModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data {
    
    //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
     //                                                        options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    //ZEBLog(@"%@",data);
    ChatMapBaseModel *model = [MTLJSONAdapter modelOfClass:[ChatMapBaseModel class]
                                         fromJSONDictionary:data
                                                      error:nil];
    
    //ZEBLog(@"%@",model.results);
    
    return model;
}

@end
