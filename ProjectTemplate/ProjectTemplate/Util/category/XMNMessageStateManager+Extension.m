//
//  XMNMessageStateManager+Extension.m
//  ProjectTemplate
//
//  Created by 绿之云 on 2016/12/9.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "XMNMessageStateManager+Extension.h"
#import <objc/runtime.h>
@implementation XMNMessageStateManager (Extension)

//+ (void)load{
//    //方法交换应该被保证，在程序中只会执行一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        //获得viewController的生命周期方法的selector
//        SEL systemSel = @selector(updateMessageSendState:forArray:);
//        //自己实现的将要被交换的方法的selector
//        SEL XMNSel = @selector(XMNUpdateMessageSendState:forArray:);
//        //两个方法的Method
//        Method systemMethod = class_getInstanceMethod([self class], systemSel);
//        Method XMNMethod = class_getInstanceMethod([self class], XMNSel);
//        
//        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
//        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(XMNMethod), method_getTypeEncoding(XMNMethod));
//        if (isAdd) {
//            //如果成功，说明类中不存在这个方法的实现
//            //将被交换方法的实现替换到这个并不存在的实现
//            class_replaceMethod(self, XMNMethod, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//        }else{
//            //否则，交换两个方法的实现
//            method_exchangeImplementations(systemMethod, XMNMethod);
//        }
//        
//    });
//}

- (NSMutableArray *)getPropertiesArray {
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([XMNMessageStateManager class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i<count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [propertiesArray addObject:name];
    }
    
    free(properties);
    ZEBLog(@"%@",propertiesArray);
    return propertiesArray;
    

}

- (void)XMNUpdateMessageSendState:(XMNMessageSendState)messageSendState forArray:(NSArray *)dataArray{
    
    NSMutableArray *property = [self getPropertiesArray];

    for (NSString * name in property) {
        if ([name isEqualToString:@"messageSendStateDict"]) {
            NSMutableDictionary * propertyValue = [self valueForKey:name];
            
            NSMutableDictionary *oldMessageSendStateDict = propertyValue;
            for (int i = 0; i<dataArray.count; i++) {
                propertyValue[@(i)] = @(messageSendState);
            }
            for (int j = 0; j<oldMessageSendStateDict.count; j++) {
        
                propertyValue[@(dataArray.count+j)] = oldMessageSendStateDict[@(j)];
            }
            ZEBLog(@"id :%@",propertyValue);
            object_setIvar([XMNMessageStateManager shareManager] ,(__bridge Ivar)(name), propertyValue);
        }
    }

}


@end
