//
//  VdBaseResultModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdBaseResultModel.h"
#import "VdResultModel.h"

@implementation VdBaseResultModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}
+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:VdResultModel.class];
    
}



+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
  //  ZEBLog(@"%@",dict);
    VdBaseResultModel *model = [MTLJSONAdapter modelOfClass:[VdBaseResultModel class]
                                         fromJSONDictionary:dict
                                                              error:nil];
 //   NSLog(@"%@",model.results);
    
    return model;
}


@end
