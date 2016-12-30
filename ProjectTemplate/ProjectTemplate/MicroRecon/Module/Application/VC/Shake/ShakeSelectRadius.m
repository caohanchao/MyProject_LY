//
//  ShakeSelectRadius.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeSelectRadius.h"


@interface ShakeSelectRadius ()

@end

@implementation ShakeSelectRadius


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        self.backgroundColor = CHCHexColor(@"3c3d3f");
    }
    return self;
}
- (void)initView {

    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(height(self.frame)/2, height(self.frame)/2)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path    =   maskPath.CGPath;
    borderLayer.fillColor  = [UIColor clearColor].CGColor;
    borderLayer.strokeColor    = zGrayColor.CGColor;
    borderLayer.lineWidth      = 0.5;
    [self.layer addSublayer:borderLayer];
    
    NSArray *arr = @[@"50 M",@"100 M",@"200 M",@"500 M"];
    NSInteger i = 0;
    NSInteger count = arr.count;
    CGFloat leftMargin = 20;
    CGFloat marginC = 10;
    CGFloat btnW = 40;
    
    for (NSString *radius in arr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftMargin+(btnW+marginC*2+0.5)*i, 0, btnW, height(self.frame));
        btn.tag = 10000+i;
        [btn setTitleColor:zWhiteColor];
        btn.titleLabel.font = ZEBFont(12);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:radius forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i < count -1) {
            UILabel *line  = [[UILabel alloc] initWithFrame:CGRectMake(maxX(btn)+10, height(self.frame)/2-6, 0.5, 12)];
            line.backgroundColor = CHCHexColor(@"808080");
            [self addSubview:line];
        }
        
        i++;
    }
}
- (void)btnClick:(UIButton *)btn {
    
    
    [self dissmiss];
    NSInteger index = btn.tag - 10000;
    if (_delegate && [_delegate respondsToSelector:@selector(shakeSelectRadius:index:radius:)]) {
        [_delegate shakeSelectRadius:self index:index radius:[btn currentTitle]];
    }
}
- (void)show {
    
    CGRect rect = self.frame;
    rect.origin.x = kScreenWidth-shakeSelectH;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dissmiss {
    CGRect rect = self.frame;
    rect.origin.x = kScreenWidth;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
