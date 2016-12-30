//
//  GetorgbyregisterBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetorgbyregisterBaseModel.h"
#import "GetorgbyregisterModel.h"


@implementation GetorgbyregisterBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}
+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:GetorgbyregisterModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    GetorgbyregisterBaseModel *model = [MTLJSONAdapter modelOfClass:[GetorgbyregisterBaseModel class]
                                                 fromJSONDictionary:data
                                                              error:nil];
    
    ZEBLog(@"%@",model.results);
    
    return model;
}

@end
