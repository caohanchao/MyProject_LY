//
//  WarningView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WarningView.h"

@interface WarningView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation WarningView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {

    _label = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zWhiteColor text:@"请输入提示信息"];
    _label.frame = CGRectMake(20, 0, kScreenWidth-HEIGHT-20, HEIGHT);
    _label.hidden = YES;
    [self addSubview:_label];
    
    _btn = [CHCUI createButtonWithtarg:self sel:@selector(dissmiss) titColor:zWhiteColor font:ZEBFont(16) image:nil backGroundImage:nil title:@""];
    _btn.frame = CGRectMake(kScreenWidth-HEIGHT, 0, HEIGHT, HEIGHT);
    _btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_btn setImage:[UIImage imageNamed:@"pathguanbi"] forState:UIControlStateNormal];
    _btn.hidden = YES;
    [self addSubview:_btn];
}
- (void)setWarn:(NSString *)warn {
    _warn = warn;
    _label.text = _warn;
}
- (void)show {
    CGRect rect = self.frame;
    rect.size.height = HEIGHT;
    _label.hidden = NO;
    _btn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
}
- (void)dissmiss {
    CGRect rect = self.frame;
    rect.size.height = 0;
    _label.hidden = YES;
    _btn.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
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
