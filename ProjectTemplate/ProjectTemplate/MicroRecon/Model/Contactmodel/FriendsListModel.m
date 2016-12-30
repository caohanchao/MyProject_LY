//
//  FriendsListModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendsListModel.h"

@implementation FriendsListModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"headpic"  : @"headpic",
             @"alarm"    : @"alarm",
             @"phone"    : @"phone",
             @"name"     : @"name",
             @"nickname" : @"nickname",
             @"useralarm": @"useralarm"
             };
}

@end
