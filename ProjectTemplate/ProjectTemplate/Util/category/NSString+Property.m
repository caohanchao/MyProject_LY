//
//  NSString+Property.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "NSString+Property.h"
#import <objc/message.h>

@implementation NSString (Property)

- (void)setMyId:(NSString *)myId {
    // 保存myId
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(myId), myId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)myId {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(myId));
}
- (NSString *)open {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(open));
}
- (void)setOpen:(NSString *)open {
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(open), open, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
