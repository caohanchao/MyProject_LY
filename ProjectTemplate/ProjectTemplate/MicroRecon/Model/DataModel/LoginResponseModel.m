//
//  LoginResponseModel.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "LoginResponseModel.h"

@implementation LoginResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:Login.class];
    
}

+ (nonnull instancetype) LoginWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dict);
    //将JSON数据和Model的属性进行绑定
    LoginResponseModel *model = [MTLJSONAdapter modelOfClass:[LoginResponseModel class]
                                              fromJSONDictionary:dict
                                                           error:nil];
    
    return model;
}

@end

@implementation Login

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"headpic"  : @"headpic",
             @"alarm"    : @"alarm",
             @"token"    : @"token",
             @"name"     : @"name",
             @"username" : @"username",
             @"useralarm": @"useralarm"
             };
}

@end