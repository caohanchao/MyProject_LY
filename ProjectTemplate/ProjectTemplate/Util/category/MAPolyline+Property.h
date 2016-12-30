//
//  MAPolyline+Property.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface MAPolyline (Property)

@property (nonatomic, copy) NSString *type; // 标记的类型 0 自己的  1 别人的
//@property (nonatomic, copy) NSString *cuid; // 线的唯一id

@end
