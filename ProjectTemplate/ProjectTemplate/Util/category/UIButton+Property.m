//
//  UIButton+Property.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  动态给按钮添加属性

#import "UIButton+Property.h"
#import <objc/message.h>

@implementation UIButton (Property)

- (void)setFormat:(NSString *)format {
    // 保存format
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(format), format, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)format {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(format));
}

- (void)setType:(NSString *)type {
    // 保存type
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(type), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)type {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(type));
    
}
- (void)setButtons:(NSMutableArray *)buttons {
    // 保存type
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(buttons), buttons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSMutableArray *)buttons {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(buttons));
}
- (void)setMy_type:(NSString *)my_type {
    objc_setAssociatedObject(self, @selector(my_type), my_type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)my_type {
    return objc_getAssociatedObject(self, @selector(my_type));
}
@end
