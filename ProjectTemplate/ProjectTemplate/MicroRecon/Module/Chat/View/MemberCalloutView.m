//
//  MemberCalloutView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MemberCalloutView.h"

@implementation MemberCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame=CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skip:)];
        [self addGestureRecognizer:tap];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5, width(self.frame)-10, width(self.frame)-10)];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = (width(self.frame)-10)/2;
    [self addSubview:self.iconView];
    
}
#pragma mark - draw rect

- ( void )drawRect:( CGRect )rect{
    
    [ self drawInContext : UIGraphicsGetCurrentContext ()];
    
    self . layer . shadowColor = [[ UIColor clearColor ] CGColor ];
    
    self . layer . shadowOpacity = 1.0 ;
    
    self . layer . shadowOffset = CGSizeMake ( 0.0f , 0.0f );
    
}

- ( void )drawInContext:( CGContextRef )context

{
    
    CGContextSetLineWidth (context, 2.0 );
    
    CGContextSetFillColorWithColor (context,  [ UIColor whiteColor ]. CGColor ); //气泡填充色
    
    [ self getDrawPath :context];
    
}

// 气泡背景绘制

- ( void )getDrawPath:( CGContextRef )context

{
    
    CGRect rrect = self . bounds ;
    
    CGFloat radius = ( kCalloutHeight - kArrorHeight ) / 2.0 ;
    
    CGFloat midx = CGRectGetMidX (rrect);
    
    CGFloat maxy = CGRectGetMaxY (rrect) - kArrorHeight ; // 调节离底部的位置
    
    CGFloat midy = maxy / 2.0 ;
    
    CGContextSaveGState (context); // 保存上下文 1
    
    CGContextBeginPath (context);
    
    // 底部三角
    
    CGContextMoveToPoint (context, midx + kArrorHeight , maxy);
    
    CGContextAddLineToPoint (context, midx, maxy + kArrorHeight );
    
    CGContextAddLineToPoint (context, midx - kArrorHeight , maxy);
    
    CGContextFillPath (context); // 渲染三角形
    
    CGContextRestoreGState (context); // 还原上下文 1
    
    CGContextAddArc (context, midx, midy + 5 , radius, 0 , M_PI * 2 , 1 ); // 画圆
    
    CGContextFillPath (context); // 渲染圆形
    
    CGContextClosePath (context);
    
}
- (void)skip:(UITapGestureRecognizer *)tap {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"memberAnnotationViewNotification" object:self.alarm];
    
}
- (void)setImage:(UIImage *)image {
     self.iconView.image = image;
}
- (void)setAlarm:(NSString *)alarm {
    _alarm = alarm;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
