//
//  UserCardModel.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserCardModel.h"
#import "CardCountInfoModel.h"
#import "CardPostInfoModel.h"

@implementation UserCardModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"isfocus" : @"isfocus",
             @"department"        : @"department",
             @"headpic"        : @"headpic",
             @"countInfo"        : @"countInfo",
             @"postInfo"        : @"postInfo",
             @"name"        : @"name",
             @"honorNum"        : @"honorNum"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:@"postInfo"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:CardPostInfoModel.class];
    }
//    else if ([key isEqualToString:@"countInfo"]) {
//        return [MTLJSONAdapter dictionaryTransformerWithModelClass:CardCountInfoModel.class];
//    }
    return nil;
}

+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",dict);
    UserCardModel *model = [MTLJSONAdapter modelOfClass:[UserCardModel class]
                                         fromJSONDictionary:dict[@"response" ]
                                                      error:nil];
    
    ZEBLog(@"%@",model);
    
    return model;
}

@end
