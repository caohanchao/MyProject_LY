//
//  GetorgbyregisterModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetorgbyregisterModel.h"

@implementation GetorgbyregisterModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"descriptions" : @"description",
             @"Id"        : @"id",
             @"name"        : @"name",
             @"parent_id"        : @"parent_id"
             };
}
- (instancetype)initWithParentId : (NSString *)descriptions Id : (NSString *)Id name : (NSString *)name parent_id : (NSString *)parent_id {
    
    self = [self init];
    if (self) {
        self.descriptions = descriptions;
        self.Id = Id;
        self.name = name;
        self.parent_id = parent_id;
    }
    return self;
}
@end
