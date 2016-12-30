//
//  PostInfoModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostInfoModel.h"

@implementation PostInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"department" : @"department",
             @"alarm"        : @"alarm",
             @"name"        : @"name",
             @"headpic"        : @"headpic",
             @"time"        : @"time"
             };
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    PostInfoModel *model = [MTLJSONAdapter modelOfClass:[PostInfoModel class]
                                    fromJSONDictionary:data
                                                 error:nil];
    
    
    
    return model;
}

@end
