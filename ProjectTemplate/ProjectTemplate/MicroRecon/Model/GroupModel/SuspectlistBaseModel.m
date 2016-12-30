//
//  SuspectlistBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SuspectlistBaseModel.h"

@implementation SuspectlistBaseModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:SuspectlistModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    //ZEBLog(@"%@",data);
    SuspectlistBaseModel *model = [MTLJSONAdapter modelOfClass:[SuspectlistBaseModel class]
                                        fromJSONDictionary:data
                                                     error:nil];
    
    //ZEBLog(@"%@",model.results);
    
    return model;
}

@end
