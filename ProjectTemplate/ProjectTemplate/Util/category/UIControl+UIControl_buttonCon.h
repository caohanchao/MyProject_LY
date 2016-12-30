//
//  UIControl+UIControl_buttonCon.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/10/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultInterval .5  //默认时间间隔

@interface UIControl (UIControl_buttonCon)

@property (nonatomic, assign) NSTimeInterval timeInterval; // 用这个给重复点击加间隔
@property (nonatomic, assign) BOOL isIgnoreEvent; //YES 不允许点击   NO 允许点击

@end
