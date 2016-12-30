//
//  MAPointAnnotation+Property.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MAPointAnnotation+Property.h"
#import <objc/message.h>


@implementation MAPointAnnotation (Property)

- (void)setTime:(NSString *)time {

    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(time), time, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
- (NSString *)time {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(time));
}

- (void)setType:(NSString *)type {
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(type), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
- (NSString *)type {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(type));
}
- (void)setPosi:(NSString *)posi {
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(posi), posi, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)posi {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(posi));
}
@end
