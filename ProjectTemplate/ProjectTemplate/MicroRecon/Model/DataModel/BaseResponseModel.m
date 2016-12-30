//
//  BaseResponseModel.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@implementation BaseResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage"
             };
}

+ (nonnull instancetype)ResponseWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    
    ZEBLog(@"发送新消息:%@",dict);
    //将JSON数据和Model的属性进行绑定
    BaseResponseModel *model = [MTLJSONAdapter modelOfClass:[BaseResponseModel class]
                                     fromJSONDictionary:dict
                                                  error:nil];
    
    return model;
}


@end
