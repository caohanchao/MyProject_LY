//
//  UploadModel.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UploadModel.h"

@implementation UploadModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
// {"resultcode":0,"response":{"md5":"3b6097ba721ce9889021a37a361e0d9d","url":"http:\/\/112.74.129.54\/tax00\/M00\/09\/01\/QUIPAFeV2UyAJktoAKtQ5jWRTDw656.png"},"resultmessage":"成功"}
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"url"           : @"response.url",
             @"md5"           : @"response.md5"
             };
}

+ (nonnull instancetype) uploadWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    UploadModel *model = [MTLJSONAdapter modelOfClass:[UploadModel class]
                                      fromJSONDictionary:dict
                                                   error:nil];
    
    return model;
}

@end
