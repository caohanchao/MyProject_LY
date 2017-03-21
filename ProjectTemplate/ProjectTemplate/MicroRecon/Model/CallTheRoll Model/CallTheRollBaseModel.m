//
//  CallTheRollBaseModel.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollBaseModel.h"
#import "CallTheRollDetailModel.h"

@implementation CallTheRollBaseModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}
+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:CallTheRollDetailModel.class];

}



+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    //  ZEBLog(@"%@",dict);
    CallTheRollBaseModel *model = [MTLJSONAdapter modelOfClass:[CallTheRollBaseModel class]
                                         fromJSONDictionary:dict
                                                      error:nil];
    NSLog(@"%@",model.results);
    
    return model;
}

@end
