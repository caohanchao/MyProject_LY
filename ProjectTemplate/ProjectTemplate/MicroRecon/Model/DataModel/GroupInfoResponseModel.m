//
//  GroupInfoResponseModel.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupInfoResponseModel.h"

@implementation GroupInfoResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    // {"resultcode":"0","response":[{"gtype":"0","gname":"组队00000","description":"gggg","gid":"yV2MfMmJaZ2aQmfEyyqJ","count":"24","gcreatetime":"2016-06-14 23:26:58","gadmin":"01006"}],"resultmessage":"成功"}
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"groups"        : @"response"
             };
}

+ (NSValueTransformer *)groupsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:GroupInfo.class];
    
}

+ (nonnull instancetype) groupInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dict);
    //将JSON数据和Model的属性进行绑定
    GroupInfoResponseModel *model = [MTLJSONAdapter modelOfClass:[GroupInfoResponseModel class]
                                      fromJSONDictionary:dict
                                                   error:nil];
    
    return model;
}

@end

@implementation GroupInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    // {"resultcode":"0","response":[{"gtype":"0","gname":"组队00000","description":"gggg","gid":"yV2MfMmJaZ2aQmfEyyqJ","count":"24","gcreatetime":"2016-06-14 23:26:58","gadmin":"01006"}],"resultmessage":"成功"}
    
    return @{
             @"gname"    : @"gname",
             @"gtype"    : @"gtype"
             };
}

@end