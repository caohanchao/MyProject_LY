//
//  CustomCalloutView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CustomCalloutView.h"
#import "NSDateFormatter+Category.h"

#define leftMargin 10
#define topMargin 5

#define kArrorHeight        10
#define kWidth   220
@implementation CustomCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame=CGRectMake(0, 0, kWidth, 125);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skip:)];
        [self addGestureRecognizer:tap];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 120)];
    backView.backgroundColor=[UIColor clearColor];
    
    [self addSubview:backView];
    
    
    self.userInteractionEnabled=YES;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, 80, 25)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor grayColor];
    
    
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width(self.frame)-100, topMargin, width(self.frame)-2*leftMargin-width(self.nameLabel.frame)-10, 25)];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:11];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.timeLabel];
    
    
    
    
    // 添加标题，
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin , maxY(self.nameLabel), width(self.frame)-2*leftMargin, 30)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    
    [backView addSubview:self.titleLabel];
    
    // 添加副标题
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin , maxY(self.titleLabel), width(self.frame)-3*leftMargin, 50)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.numberOfLines = 2;
    
    [backView addSubview:self.subtitleLabel];
    
    
}
- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
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

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}
- (void)setTime:(NSString *)time {
    
    if (![[LZXHelper isNullToString:time] isEqualToString:@""]) {
        
        self.timeLabel.text = [time AnnoationtimeChage];
    }
   
}
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
- (void)setSubtitle:(NSString *)subtitle {
    self.subtitleLabel.text = subtitle;
}
- (void)skip:(UITapGestureRecognizer *)tap {
    
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    parma[@"GetrecordByGroupModel"] = self.gModel;
    [LYRouter openURL:@"ly://skiprecorddesviewcontroller" withUserInfo:parma completion:nil];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
