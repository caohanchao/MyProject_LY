//
//  HWProgressView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWProgressView.h"

#define KProgressColor [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1]

@interface HWProgressView ()

@property (nonatomic, weak) UIView *tView;

@end

@implementation HWProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //边框
        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.backgroundColor = KProgressColor;
        [self addSubview:borderView];
        
        //进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = zWhiteColor;
        [self addSubview:tView];
        self.tView = tView;
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
  //  CGFloat margin = KProgressBorderWidth + KProgressPadding;
    CGFloat maxWidth = self.bounds.size.width;
    CGFloat heigth = self.bounds.size.height;
    
    _tView.frame = CGRectMake(0, 0, maxWidth * progress, heigth);
}

@end

