//
//  ShakeCameraBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeCameraBaseModel.h"
#import "ShakeCameraModel.h"

@implementation ShakeCameraBaseModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}
+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:ShakeCameraModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    ShakeCameraBaseModel *model = [MTLJSONAdapter modelOfClass:[ShakeCameraBaseModel class]
                                         fromJSONDictionary:data
                                                      error:nil];
    
    
    return model;
}


@end
