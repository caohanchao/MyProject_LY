//
//  GetreportuserbydayBaseModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "GetreportuserbydayBaseModel.h"
#import "CallTheRollDeatilModel.h"


@implementation GetreportuserbydayBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}
+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:CallTheRollUserListModel.class];
    
}

+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    GetreportuserbydayBaseModel *model = [MTLJSONAdapter modelOfClass:[GetreportuserbydayBaseModel class]
                                                 fromJSONDictionary:data
                                                              error:nil];
    
    
    return model;
}


@end
