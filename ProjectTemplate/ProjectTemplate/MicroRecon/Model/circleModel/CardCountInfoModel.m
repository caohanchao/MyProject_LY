//
//  CardCountInfoModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CardCountInfoModel.h"

@implementation CardCountInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"fansNum" : @"fansNum",
             @"focusNum"        : @"focusNum",
             @"publicNum"        : @"publicNum"
             };
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    CardCountInfoModel *model = [MTLJSONAdapter modelOfClass:[CardCountInfoModel class]
                                    fromJSONDictionary:data
                                                 error:nil];
    
    
    
    return model;
}

@end
