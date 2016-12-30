//
//  VdCalloutView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdCalloutView.h"
#import "NSDateFormatter+Category.h"
#import "CBAutoScrollLabel.h"

#define leftMargin 5
#define topMargin 10

#define kArrorHeight        10
#define kWidth   180

@implementation VdCalloutView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame=CGRectMake(0, 0, kWidth, 95);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skip:)];
        [self addGestureRecognizer:tap];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
//    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 120)];
//    backView.backgroundColor=[UIColor clearColor];
//    [self addSubview:backView];
//    
    
    self.userInteractionEnabled=YES;
    
    CGFloat marginD = 8;
    
    // 经过日期
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, 110, 10)];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = CHCHexColor(@"000000");

    [self addSubview:self.dateLabel];
    
    
    //经过时刻
    self.momentLabel = [[UILabel alloc] init];
    self.momentLabel.frame = CGRectMake(leftMargin, maxY(self.dateLabel)+marginD, width(self.dateLabel.frame), 10);
    self.momentLabel.font = [UIFont systemFontOfSize:10];
    self.momentLabel.textColor = CHCHexColor(@"000000");
    [self addSubview:self.momentLabel];
    
    
    CGFloat marginL = 8;
    
    // 车道编号
    self.LaneNumberLabel = [[UILabel alloc] init];
    self.LaneNumberLabel.frame = CGRectMake(leftMargin, maxY(self.momentLabel)+marginL, width(self.dateLabel.frame), 10);
    self.LaneNumberLabel.font = [UIFont systemFontOfSize:10];
    self.LaneNumberLabel.textColor = CHCHexColor(@"000000");
    [self addSubview:self.LaneNumberLabel];
    
    CGFloat bw = [LZXHelper textWidthFromTextString:@"卡口名称：" height:15 fontSize:10];
    
    // 卡口名称
    self.bayonetNameLabel = [[UILabel alloc] init];
    self.bayonetNameLabel.frame = CGRectMake(leftMargin, maxY(self.LaneNumberLabel)+marginD, bw, 10);
    self.bayonetNameLabel.font = [UIFont systemFontOfSize:10];
    self.bayonetNameLabel.textColor = CHCHexColor(@"000000");
    self.bayonetNameLabel.text = @"卡口名称：";
    [self addSubview:self.bayonetNameLabel];
    
    
    // 跑马灯
    self.rollLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(maxX(self.bayonetNameLabel), minY(self.bayonetNameLabel), width(self.frame)-width(self.bayonetNameLabel.frame)-15, 10)];
    self.rollLabel.scrollSpeed = 20;
    self.rollLabel.textColor = CHCHexColor(@"000000");
    self.rollLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.rollLabel];
    
    CGFloat iconW = 50;
    
    self.icon = [[UIImageView alloc] init];
    self.icon.frame = CGRectMake(0, 0, iconW, iconW);
    self.icon.center = CGPointMake(maxX(self)-iconW/2-5, 5+iconW/2);
    self.icon.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.icon];
    

    
}
- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);

}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
    
    
}
- (void)setDate:(NSString *)date {
    _date = date;
    _dateLabel.text = [NSString stringWithFormat:@"经过日期：%@",[_date VdtimeChange]];
}
- (void)setMoment:(NSString *)moment {
    _moment = moment;
    _momentLabel.text = [NSString stringWithFormat:@"经过时刻：%@",[_moment timeChangeHHmm]];
}
- (void)setLaneNumber:(NSString *)LaneNumber {
    _LaneNumber = LaneNumber;
    _LaneNumberLabel.text = [NSString stringWithFormat:@"车道编号：%@",_LaneNumber];
}
- (void)setBayonetName:(NSString *)bayonetName {
    _bayonetName = bayonetName;
    if ([_bayonetName hasPrefix:@"湖北省武汉市"]) {
        NSArray *baarray = [_bayonetName componentsSeparatedByString:@"湖北省武汉市"];
        if (baarray.count > 0) {
            if ([baarray[0] isEqualToString:@""]) {
                if (baarray.count > 1) {
                     _bayonetName = baarray[1];
                }
            }
        }
        
    }
    self.rollLabel.text = _bayonetName;
   
}

- (void)setIconUrl:(NSString *)iconUrl {
    _iconUrl = iconUrl;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_iconUrl]];
}
- (void)skip:(UITapGestureRecognizer *)tap {
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"VdModel"] = self.model;
    
    [LYRouter openURL:@"ly://VehicleDetectionViewControllerSkipVehicleDetectionDesViewController" withUserInfo:parm completion:^(id result) {
        
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
