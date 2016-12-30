//
//  JspatchBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "JspatchBaseModel.h"


@implementation JspatchBaseModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"jsPatch"        : @"response"
             };
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    JspatchBaseModel *model = [MTLJSONAdapter modelOfClass:[JspatchBaseModel class]
                                  fromJSONDictionary:dict
                                               error:nil];
    

    
    return model;
}



@end
