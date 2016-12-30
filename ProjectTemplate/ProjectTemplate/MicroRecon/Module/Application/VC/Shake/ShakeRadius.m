//
//  ShakeRadius.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  默认半径

#import "ShakeRadius.h"

@interface ShakeRadius ()

@property (nonatomic, weak) UILabel *radiusLabel;
@property (nonatomic, copy) clickBlock block;

@end

@implementation ShakeRadius

- (instancetype)initWithFrame:(CGRect)frame block:(clickBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.22 alpha:1.00];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
        
        self.block = block;
        [self initView];
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

    UILabel *label = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(12) textColor:zWhiteColor text:@"100 M"];
    [self addSubview:label];
    
    self.radiusLabel = label;
    
    UIImageView *imageView = [CHCUI createImageWithbackGroundImageV:@"entre_se"];
    [self addSubview:imageView];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(7, 11));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(imageView.mas_left).offset(-10);
        
    }];
    
}
- (void)click:(UITapGestureRecognizer *)recognizer {
    self.block(self);
}
- (void)setRadius:(NSString *)radius {
    self.radiusLabel.text = radius;
}
- (void)show {
    
    CGRect rect = self.frame;
    rect.origin.x = kScreenWidth-85;
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
