//
//  PulsingHaloLayer.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//
/*
 ios水波纹雷达效果 外部调用
 //对封装的动画初始化
 PulsingHaloLayer *animationlayer = [PulsingHaloLayer layer];
 //设置动画的位置(根据需要自己修改)
 animationlayer.position = CGPointMake(0,0) ;
 //将动画添加到显示动画的视图的layer层上
 [subView.layer insertSublayer:animationlayer below:subView.layer];
 */
#import <QuartzCore/QuartzCore.h>
//继承自CALayer
@interface PulsingHaloLayer : CALayer
//雷达扩散最大半径,默认:20pt
@property (nonatomic, assign) CGFloat radius;
//雷达扩散的背景颜色
@property (nonatomic, strong) UIColor *color;
// 雷达扩散效果持续时间, 默认:3s
@property (nonatomic, assign) NSTimeInterval animationDuration;
//雷达效果脉冲间隔,默认0秒(一个脉冲消失后,下一个脉冲才出现)
@property (nonatomic, assign) NSTimeInterval pulseInterval; // 默认 is 0s
@end
