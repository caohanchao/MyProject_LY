//
//  ZEBBubbleView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBBubbleView.h"

@implementation ZEBBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        
        self.lbTitle = [[UILabel alloc] init];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.font = [UIFont systemFontOfSize:14];
        self.lbTitle.textColor = [UIColor whiteColor];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.numberOfLines = 0;
        [_contentView addSubview:self.lbTitle];
        

    }
    return self;
}

//默认数据配置
- (void)initData {
    self.color = self.color ? self.color : kLFBubbleViewColor;
    self.cornerRadius = self.cornerRadius > 0 ? self.cornerRadius : kLFBubbleViewCornerRadius;
    self.triangleH = self.triangleH > 0 ? self.triangleH : kLFBubbleViewTriangleH;
    self.triangleW = self.triangleW > 0 ? self.triangleW : kLFBubbleViewTriangleW;
    if (self.triangleXY < 1) {
        if (self.triangleXYScale == 0) {
            self.triangleXYScale = 0.5;
        }
        if (self.direction == TriangleDirection_Left) {
            self.triangleXY = self.triangleXYScale * self.frame.size.width;
        } else {
            self.triangleXY = self.triangleXYScale * self.frame.size.height;
        }
        
    }
}

- (void)drawRect:(CGRect)rect {
    
    //默认数据配置
    [self initData];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    rect.origin.x = rect.origin.x + self.borderWidth;
    rect.origin.y = rect.origin.y + self.borderWidth;
    rect.size.width = rect.size.width - 2*self.borderWidth;
    rect.size.height = rect.size.height - 2*self.borderWidth;
    
    switch (self.direction) {
        case TriangleDirection_Down:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.triangleW/2,
                                 rect.origin.y + rect.size.height - self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.triangleW/2,
                                 rect.origin.y + rect.size.height - self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                                 rect.origin.y + rect.size.height - self.triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
        }
            break;
        case TriangleDirection_Up:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius + self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.triangleH + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.triangleH + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.triangleW/2,
                                 rect.origin.y + self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.triangleW/2,
                                 rect.origin.y + self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.triangleH + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
        }
            break;
        case TriangleDirection_Left:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x + self.triangleH, rect.origin.y + self.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH, rect.origin.y + self.triangleXY - self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x,
                                 rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH,
                                 rect.origin.y + self.triangleXY + self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH,
                                 rect.origin.y + rect.size.height - self.cornerRadius);
            
            CGPathAddArc(path, NULL, rect.origin.x + self.triangleH + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,
                                 rect.origin.y + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            
            
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH + self.cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.triangleH + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
        }
            break;
        case TriangleDirection_Right:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH - self.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.triangleH - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH,
                                 rect.origin.y + self.triangleXY + self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,
                                 rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH,
                                 rect.origin.y + self.triangleXY - self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH,
                                 rect.origin.y + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.triangleH - self.cornerRadius, rect.origin.y + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius,
                                 rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
            
        }
            break;
        default:
            break;
    }
    
    
    CGPathCloseSubpath(path);
    
    //填充气泡
    [self.color setFill];
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    //    CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // 边缘线
    if (self.borderColor && self.borderWidth > 0) {
        [self.borderColor setStroke];
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    
    CGPathRelease(path);
    CGColorSpaceRelease(space);
    
}

-(void)showInPoint:(CGPoint)point {
    //默认数据配置
    [self initData];
    
    //contentView与self的边距
    CGFloat padding = self.cornerRadius - self.cornerRadius/M_SQRT2 + self.borderWidth;
    switch (self.direction) {
        case TriangleDirection_Down:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding, self.frame.size.height - 2 * padding - self.triangleH);
            
        }
            break;
        case TriangleDirection_Up:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding + self.triangleH, self.frame.size.width - 2 * padding, self.frame.size.height - 2 * padding - self.triangleH);
        }
            break;
        case TriangleDirection_Left:
        {
            self.frame = CGRectMake(point.x, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(self.triangleH + padding, padding, self.frame.size.width - 2 * padding - self.triangleH, self.frame.size.height - 2 * padding);
        }
            break;
        case TriangleDirection_Right:
        {
            self.frame = CGRectMake(point.x - self.frame.size.width, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding - self.triangleH, self.frame.size.height - 2 * padding);
        }
            break;
        default:
            break;
    }
    
    self.lbTitle.frame = CGRectMake(5, 5, self.contentView.frame.size.width - 10, self.contentView.frame.size.height - 10);
}
- (void)dismiss
{
    [self fadeOut];
}


//弹出层
- (void)fadeOut
{

   [self removeFromSuperview];
    
}

@end
