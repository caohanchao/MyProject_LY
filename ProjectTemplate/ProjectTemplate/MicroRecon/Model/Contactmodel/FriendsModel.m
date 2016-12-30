//
//  FriendsModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendsModel.h"
#import "FriendsListModel.h"

@implementation FriendsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:FriendsListModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
//                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    FriendsModel *model = [MTLJSONAdapter modelOfClass:[FriendsModel class]
                                          fromJSONDictionary:data
                                                       error:nil];
    
    ZEBLog(@"%@",model.results);
    
    return model;
}

@end
