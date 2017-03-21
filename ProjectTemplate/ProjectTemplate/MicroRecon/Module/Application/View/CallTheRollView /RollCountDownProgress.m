//
//  RollCountDownProgress.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#define ProgressRedColor    [UIColor colorWithRed:0.92 green:0.27 blue:0.29 alpha:1.00]
#define ProgressGrayColor   [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00]
#import "RollCountDownProgress.h"

@interface RollCountDownProgress ()

@property (nonatomic,strong)UIBezierPath *trackPath;
@property (nonatomic,strong)UIBezierPath *progressPath;
@property (nonatomic,strong)CAShapeLayer *trackLayer;
@property (nonatomic,strong)CAShapeLayer *progressLayer;

@property (nonatomic,strong)UILabel *countLabel;

@property (nonatomic,assign)double multiple;
@end

@implementation RollCountDownProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
    }
    return self;
}

- (void)setCount:(NSString *)count {
    _count = count;
    _countLabel.text = _count;
}



- (void)setCallTheRolling:(NSString *)callTheRolling {
    _callTheRolling = callTheRolling;
    if ([_callTheRolling isEqualToString:@"0"]) {
        _countLabel.textColor = ProgressRedColor;
        _progressLayer.hidden = NO;
    } else {
        _progressLayer.hidden = YES;
        _countLabel.textColor =ProgressGrayColor;
    }
}
- (void)setKeepTime:(NSString *)keepTime {
    _keepTime = keepTime;
    self.multiple = [_count doubleValue]/[_keepTime doubleValue];
    if (self.multiple==0) {
        _progressLayer.hidden = YES;
    }
}

- (void)initSubViews {
    self.countLabel = [CHCUI createLabelWithbackGroundColor:zWhiteColor textAlignment:1 font:ZEBFont(10) textColor:ProgressGrayColor text:@"40"];
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    [_trackPath removeAllPoints];
    [_trackLayer removeFromSuperlayer];

    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake((rect.origin.x+rect.size.width)/2, (rect.origin.y+rect.size.height)/2) radius:(rect.size.width - 0.7)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
//    NSLog(@"%lf,%lf",self.center.x,self.center.y);
    
    _trackLayer = [CAShapeLayer new];
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor=ProgressGrayColor.CGColor;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth=4;
    _trackLayer.frame = rect;
    //内圆
    if ([self.callTheRolling isEqualToString:@"0"]) {
        [_progressPath removeAllPoints];
        [_progressLayer removeFromSuperlayer];
        
        _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake((rect.origin.x+rect.size.width)/2, (rect.origin.y+rect.size.height)/2) radius:(rect.size.width - 0.7)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * self.multiple - M_PI_2 clockwise:YES];
        _progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor=ProgressRedColor.CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.path = _progressPath.CGPath;
        _progressLayer.lineWidth=4;
        _progressLayer.frame = rect;
    }
    
    
    // Drawing code
}


@end
