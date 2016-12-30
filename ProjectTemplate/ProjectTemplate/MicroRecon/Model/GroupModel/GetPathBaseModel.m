//
//  GetPathBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetPathBaseModel.h"

@implementation GetPathBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:GetPathModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",dict);
    GetPathBaseModel *model = [MTLJSONAdapter modelOfClass:[GetPathBaseModel class]
                                        fromJSONDictionary:dict
                                                     error:nil];
    
    //ZEBLog(@"%@",model.results);
    
    return model;
}

@end
