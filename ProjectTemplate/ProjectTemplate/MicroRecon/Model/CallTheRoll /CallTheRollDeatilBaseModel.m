//
//  CallTheRollDeatilBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollDeatilBaseModel.h"

@implementation CallTheRollDeatilBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"deatilModel"        : @"response"
             };
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    CallTheRollDeatilBaseModel *model = [MTLJSONAdapter modelOfClass:[CallTheRollDeatilBaseModel class]
                                                 fromJSONDictionary:data
                                                              error:nil];
    
    
    return model;
}


@end
