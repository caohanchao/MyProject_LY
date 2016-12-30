//
//  MapCancelNextView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MapCancelNextView.h"

@interface MapCancelNextView ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation MapCancelNextView

- (instancetype)initWithFrame:(CGRect)frame nextBlock:(NextClickBlock)block cancelBlock:(CancelClickBlock)cBlock {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.cBlock = cBlock;
        self.block = block;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 0, 60, 60);
    [_cancelBtn setBackgroundColor:[UIColor blackColor]];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor]];
    [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.titleLabel.font = ZEBFont(13);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_cancelBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(30, 30)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = _cancelBtn.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _cancelBtn.layer.mask = maskLayer;
    
    _cancelBtn.alpha = 0.7;
    
    [self addSubview:_cancelBtn];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(maxX(_cancelBtn)+10, 0, 60, 60);
    [_nextBtn setBackgroundColor:zNavColor];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitleColor:[UIColor whiteColor]];
    _nextBtn.titleLabel.font = ZEBFont(13);
    UIBezierPath *nextMaskPath = [UIBezierPath bezierPathWithRoundedRect:_nextBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(30, 30)];
    
    CAShapeLayer *nextMaskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    nextMaskLayer.frame = _nextBtn.bounds;
    //设置图形样子
    nextMaskLayer.path = nextMaskPath.CGPath;
    _nextBtn.layer.mask = nextMaskLayer;
    
    _nextBtn.alpha = 0.7;
    
    [self addSubview:_nextBtn];
}
#pragma mark -
#pragma mark 取消
- (void)cancel:(UIButton *)btn {
    [self dismiss];
    self.cBlock(self);
}
#pragma mark -
#pragma mark 下一步
- (void)next:(UIButton *)btn {
    self.block(self);
}
- (void)dismiss {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
