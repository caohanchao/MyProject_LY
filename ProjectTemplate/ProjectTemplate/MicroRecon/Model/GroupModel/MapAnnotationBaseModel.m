//
//  MapAnnotationBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MapAnnotationBaseModel.h"

@implementation MapAnnotationBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"linesignModel"  : @"linesign",
             @"intersignModel"    : @"intersign",
             @"interinfoModel"    : @"interinfo",
             @"trackinfoModel"    : @"trackinfo"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:@"linesignModel"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:LinesignModel.class];
    }else if ([key isEqualToString:@"intersignModel"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:IntersignModel.class];
    }else if ([key isEqualToString:@"interinfoModel"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:InterinfoModel.class]; 
    }else if ([key isEqualToString:@"trackinfoModel"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:TrackinfoModel.class];
    }
    return nil;
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    //ZEBLog(@"%@",data);
    MapAnnotationBaseModel *model = [MTLJSONAdapter modelOfClass:[MapAnnotationBaseModel class]
                                      fromJSONDictionary:data
                                                   error:nil];
    
    
    
    return model;
}

@end
