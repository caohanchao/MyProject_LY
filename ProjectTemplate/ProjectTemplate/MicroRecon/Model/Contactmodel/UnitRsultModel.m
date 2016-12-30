//
//  UnitRsultModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitRsultModel.h"
#import "UnitListModel.h"
#import "UserAllModel.h"

@implementation UnitRsultModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"departall"  : @"departall",
             @"userall"    : @"userall"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {

    if ([key isEqualToString:@"departall"]) {
       return [MTLJSONAdapter arrayTransformerWithModelClass:UnitListModel.class];
    }
    return [MTLJSONAdapter arrayTransformerWithModelClass:UserAllModel.class];
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    UnitRsultModel *model = [MTLJSONAdapter modelOfClass:[UnitRsultModel class]
                                  fromJSONDictionary:data
                                               error:nil];
    
    
    
    return model;
}


@end
