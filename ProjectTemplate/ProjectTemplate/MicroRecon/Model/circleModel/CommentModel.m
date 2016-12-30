//
//  CommentModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"alarm" : @"alarm",
             @"commentid"        : @"commentid",
             @"postuser"        : @"postuser",
             @"content"        : @"content",
             @"department"        : @"department",
             @"headpic" : @"headpic",
             @"mode"        : @"mode",
             @"pushtime"        : @"pushtime",
             @"name"        : @"name",
             @"postid"        : @"postid"
             };
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    CommentModel *model = [MTLJSONAdapter modelOfClass:[CommentModel class]
                                     fromJSONDictionary:data
                                                  error:nil];
    
    
    
    return model;
}

@end
