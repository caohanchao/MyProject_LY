//
//  UIImage+Property.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/3.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "UIImage+Property.h"

@implementation UIImage (Property)


- (void)setType:(NSString *)type {
    // 保存type
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(type), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)type {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(type));
    
}
- (void)setBytes:(NSString *)Bytes {
    objc_setAssociatedObject(self, @selector(Bytes), Bytes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)Bytes {
    return objc_getAssociatedObject(self, @selector(Bytes));
}
- (void)setImageData:(NSData *)imageData {
    objc_setAssociatedObject(self, @selector(imageData), imageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSData *)imageData {
    return objc_getAssociatedObject(self, @selector(imageData));
}

@end
