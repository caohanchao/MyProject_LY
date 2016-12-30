//
//  UserAllModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserAllModel.h"

@implementation UserAllModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"RE_alarmNum"  : @"RE_alarmNum",
             @"RE_department"    : @"RE_department",
             @"RE_headpic"     : @"RE_headpic",
             @"RE_name" : @"RE_name",
             @"RE_nickname" : @"RE_nickname",
             @"RE_permission" : @"RE_permission",
             @"RE_phonenum" : @"RE_phonenum",
             @"RE_ptime" : @"RE_ptime",
             @"RE_status" : @"RE_status",
             @"RE_post" : @"RE_post",
             @"RE_useralarm" : @"RE_useralarm"
             };
}
+ (nonnull instancetype) getInfoWithData:(NSDictionary *)data {
    
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                         options:NSJSONReadingMutableContainers error:nil];
    //将JSON数据和Model的属性进行绑定
    ZEBLog(@"%@",data);
    UserAllModel *model = [MTLJSONAdapter modelOfClass:[UserAllModel class]
                                     fromJSONDictionary:data
                                                  error:nil];
    
    
    
    return model;
}

@end
