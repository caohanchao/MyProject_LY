//
//  CallHelpAlertView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpAlertView.h"

#define AlertW 250
#define AlertH 130
@interface CallHelpAlertView ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) buttonClick block;
@property (nonatomic, assign) NSInteger time;
/** 弹窗 */
@property(nonatomic,retain) UIView *alertView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation CallHelpAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self initView];
        [self initTimer];
      
    }
    return self;
}
- (void)initTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openCountdown) userInfo:nil repeats:YES];
    //先关闭  防止动画耗时
    [self stopNStimer];
}
- (void)initView {
    
    self.alertView = [[UIView alloc]init];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 5.0;
    self.alertView.layer.position = self.center;
    self.alertView.frame = CGRectMake(0, 0, AlertW, AlertH);
    [self addSubview:self.alertView];
    
    
    CGFloat timeLabelW = 60;
    
    self.timeLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(18) textColor:CHCHexColor(@"ee4444") text:@"5"];
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = timeLabelW/2;
    self.timeLabel.layer.borderWidth = 1;
    self.timeLabel.layer.borderColor = CHCHexColor(@"ee4444").CGColor;
    
    UILabel *line1  = [[UILabel alloc] init];
    line1.backgroundColor = zGrayColor;
    
    self.cancelBtn = [CHCUI createButtonWithtarg:self sel:@selector(ClickButton:) titColor:zBlueColor font:ZEBFont(15) image:nil backGroundImage:nil title:@"取消"];
    self.cancelBtn.tag = ButtonClickCancel;
    
    UILabel *line2  = [[UILabel alloc] init];
    line2.backgroundColor = zGrayColor;
    
    self.confirmBtn = [CHCUI createButtonWithtarg:self sel:@selector(ClickButton:) titColor:zBlueColor font:ZEBFont(15) image:nil backGroundImage:nil title:@"发送"];
    self.confirmBtn.tag = ButtonClickConfirm;
    
    [self.alertView addSubview:self.timeLabel];
    [self.alertView addSubview:line1];
    [self.alertView addSubview:self.cancelBtn];
    [self.alertView addSubview:line2];
    [self.alertView addSubview:self.confirmBtn];
    
    CGFloat margin = 10;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView.mas_top).offset(margin);
        make.centerX.equalTo(self.alertView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(timeLabelW, timeLabelW));
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView.mas_left);
        make.right.equalTo(self.alertView.mas_right);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(margin);
        make.height.mas_equalTo(0.5);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self.alertView.mas_left);
        make.right.equalTo(self.alertView.mas_centerX).offset(-0.25);
        make.bottom.equalTo(self.alertView.mas_bottom);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.centerX.equalTo(self.alertView.mas_centerX);
        make.bottom.equalTo(self.alertView.mas_bottom);
        make.width.mas_equalTo(0.5);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self.alertView.mas_centerX).offset(0.25);
        make.right.equalTo(self.alertView.mas_right);
        make.bottom.equalTo(self.alertView.mas_bottom);
    }];
    
}

- (void)ClickButton:(UIButton *)btn
{
    [self hide];
    if (self.block) {
        self.block((int)btn.tag);
    }
    
}
- (void)hide
{
    [self stopNStimer];
    [self removeFromSuperview];
}
- (void)show {
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    
}

-(void)creatShowAnimation
{
    self.timeLabel.text = @"5";
    self.time = 5;
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self startNStimer];
    }];
    
}

- (void)click:(buttonClick) block
{
    self.block = block;
}
// 开启倒计时效果
-(void)openCountdown{
    
    if(self.time < 0){ //倒计时结束，关闭

        self.timeLabel.text = @"0";
        self.block((int)ButtonClickConfirm);
        [self hide];
        
    }else{
        
        self.timeLabel.text = [NSString stringWithFormat:@"%ld",self.time];
        self.time--;
    }

}
-(void)startNStimer
{
    [self.timer setFireDate:[NSDate distantPast]];
}

-(void)stopNStimer
{
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
