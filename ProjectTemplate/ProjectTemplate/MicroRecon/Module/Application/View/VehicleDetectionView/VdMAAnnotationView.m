//
//  VdMAAnnotationView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  气泡

#import "VdMAAnnotationView.h"
#import "VdAnnotation.h"
#import "VdCalloutView.h"

#define kCalloutWidth       170.0
#define kCalloutHeight      70.0


@interface VdMAAnnotationView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation VdMAAnnotationView


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.image = [UIImage imageNamed:@"vd_annotation"];
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width(self.frame), height(self.frame)-4)];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = ZEBFont(12);
//        self.titleLabel.textColor = zWhiteColor;
//        [self addSubview:self.titleLabel];
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        self.image = [UIImage imageNamed:@"vd_annotation_se"];
        if (self.calloutView == nil)
        {
            self.calloutView = [[VdCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        self.calloutView.date = [LZXHelper isNullToString:self.aannotation.date];
        self.calloutView.moment = [LZXHelper isNullToString:self.aannotation.moment];
        self.calloutView.LaneNumber = [LZXHelper isNullToString:self.aannotation.LaneNumber];
        self.calloutView.bayonetName = [LZXHelper isNullToString:self.aannotation.bayonetName];
        self.calloutView.iconUrl = [LZXHelper isNullToString:self.aannotation.iconUrl];
        
        self.calloutView.model = self.aannotation.model;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        self.image = [UIImage imageNamed:@"vd_annotation"];
        [self.calloutView removeFromSuperview];
        
    }
    
    [super setSelected:selected animated:animated];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
//- (void)setAannotation:(VdAnnotation *)aannotation {
//    _aannotation = aannotation;
//    if (_aannotation.index+1 >= 100) {
//        self.titleLabel.font = ZEBFont(10);
//    }else {
//        self.titleLabel.font = ZEBFont(12);
//    }
//    self.titleLabel.text = [NSString stringWithFormat:@"%ld",_aannotation.index+1];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
