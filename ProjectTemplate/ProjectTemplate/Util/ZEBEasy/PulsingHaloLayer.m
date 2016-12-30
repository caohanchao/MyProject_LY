//
//  PulsingHaloLayer.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PulsingHaloLayer.h"

@interface PulsingHaloLayer ()
//添加私有属性
@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@end

@implementation PulsingHaloLayer
//初始化方法
- (id)init {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        // 配置默认参数
        self.radius = 20;
        self.animationDuration = 3;
        self.pulseInterval = 0;
        //配置背景颜色
        self.backgroundColor = [zNavColor CGColor];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self setupAnimationGroup];
            if(self.pulseInterval != INFINITY) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self addAnimation:self.animationGroup forKey:@"pulse"];
                });
            }
        });
    }
    return self;
}
//重新配置背景颜色
- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = _color.CGColor;
}
//radius的setter方法,配置动画启动位置和半径
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    CGPoint tempPos = self.position;
    CGFloat diameter = self.radius * 2;
    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
}
- (void)setupAnimationGroup {
    //   速度控制函数(CAMediaTimingFunction)
    //   1.kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
    //   2.kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
    //   3.kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
    //   4.kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    //配置组合动画CAAnimationGroup
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;//每次持续时长
    self.animationGroup.repeatCount = INFINITY;//重复次数
    self.animationGroup.removedOnCompletion = NO;//结束后是否移除
    self.animationGroup.timingFunction = defaultCurve;//时间函数控制动画节奏
    //使用CABasicAnimation控制脉冲的大小
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = self.animationDuration;
    //使用CAKeyframeAnimation来设置透明度渐变
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@0.45, @0.45, @0];
    opacityAnimation.keyTimes = @[@0, @0.2, @1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    self.animationGroup.animations = animations;
}
@end
