//
//  MAPointAnnotation+Property.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface MAPointAnnotation (Property)

@property (nonatomic, copy) NSString *type; // 标记的类型 0 普通 1 开始 2 结束
@property (nonatomic, copy) NSString *time; // 标记的时间
@property (nonatomic, copy) NSString *posi; // 文字地理信息
@end
