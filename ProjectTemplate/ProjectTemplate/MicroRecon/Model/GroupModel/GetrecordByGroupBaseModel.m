//
//  GetrecordByGroupBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetrecordByGroupBaseModel.h"

@implementation GetrecordByGroupBaseModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:GetrecordByGroupModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    GetrecordByGroupBaseModel *model = [MTLJSONAdapter modelOfClass:[GetrecordByGroupBaseModel class]
                                            fromJSONDictionary:data
                                                         error:nil];
    
    //ZEBLog(@"%@",model.results);
    
    return model;
}

@end
