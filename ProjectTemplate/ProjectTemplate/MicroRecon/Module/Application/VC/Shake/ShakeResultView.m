//
//  ShakeResultView.m
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import "ShakeResultView.h"

@interface ShakeResultView ()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, copy) ResultBlock block;
@end

@implementation ShakeResultView

- (instancetype)initWithFrame:(CGRect)frame block:(ResultBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        [self initView];
    }
    return self;
}
- (void)initView {
   
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path    =   maskPath.CGPath;
    borderLayer.fillColor  = [UIColor clearColor].CGColor;
    borderLayer.strokeColor    = [UIColor grayColor].CGColor;
    borderLayer.lineWidth      = 0.5;
    [self.layer addSublayer:borderLayer];
    
    self.backgroundColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.22 alpha:1.00];
    
    _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, CGRectGetWidth(self.frame)-60, CGRectGetHeight(self.frame))];
    _resultLabel.textColor = [UIColor whiteColor];
    _resultLabel.font = [UIFont systemFontOfSize:14];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_resultLabel];
    
    
    UIImageView *entre = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    entre.center = CGPointMake(CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)/2);
    entre.image = [UIImage imageNamed:@"entre_no"];
    [self addSubview:entre];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMe)];
    [self addGestureRecognizer:tap];
}
- (void)clickMe {
    self.block(self);
}
- (void)setResultStr:(NSString *)resultStr {
    _resultStr = resultStr;
    _resultLabel.text = _resultStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
