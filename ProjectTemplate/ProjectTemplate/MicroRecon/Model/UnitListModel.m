//
//  UnitListModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitListModel.h"



@implementation UnitListModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"DE_count"  : @"DE_count",
             @"DE_level"    : @"DE_level",
             @"DE_sjnumber"     : @"DE_sjnumber",
             @"DE_name" : @"DE_name",
             @"DE_number" : @"DE_number",
             @"DE_describe1" : @"DE_describe1",
             @"DE_describe2" : @"DE_describe2",
             @"DE_mermber" : @"DE_mermber",
             @"DE_type"    :   @"DE_type"
             };
}
+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    UnitListModel *model = [MTLJSONAdapter modelOfClass:[UnitListModel class]
                                  fromJSONDictionary:data
                                               error:nil];
    
    
    
    return model;
}

@end
