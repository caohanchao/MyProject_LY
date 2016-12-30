//
//  VdTopView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdTopView.h"

@implementation VdTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    [self drawRect];
    }
    return self;
}
- (void)drawRect {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
//    CAShapeLayer *borderLayer=[CAShapeLayer layer];
//    borderLayer.path    =   maskPath.CGPath;
//    borderLayer.fillColor  = [UIColor clearColor].CGColor;
//    borderLayer.strokeColor    = [UIColor grayColor].CGColor;
//    borderLayer.lineWidth      = 0.5;
//    borderLayer.masksToBounds = NO;
//    borderLayer.shadowPath  = maskPath.CGPath;
//    borderLayer.shadowRadius = 10;
//    borderLayer.shadowColor = [UIColor whiteColor].CGColor;
//    borderLayer.shadowOpacity=0.3;
//    borderLayer.shadowOffset=CGSizeMake(0, 3);
//    [self.layer addSublayer:borderLayer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
