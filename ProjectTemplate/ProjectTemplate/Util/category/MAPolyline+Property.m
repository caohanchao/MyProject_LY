//
//  MAPolyline+Property.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MAPolyline+Property.h"

@implementation MAPolyline (Property)

- (void)setType:(NSString *)type {
    // 动态添加属性的本质是:让对象的某个属性与值产生关联
    objc_setAssociatedObject(self, @selector(type), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (NSString *)type {
    // 获取对应属性的值
    return objc_getAssociatedObject(self, @selector(type));
}
//- (void)setCuid:(NSString *)cuid {
//    // 动态添加属性的本质是:让对象的某个属性与值产生关联
//    objc_setAssociatedObject(self, @selector(cuid), cuid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSString *)cuid {
//    // 获取对应属性的值
//    return objc_getAssociatedObject(self, @selector(cuid));
//}
@end
