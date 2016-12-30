//
//  ZEBBubbleView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


//默认背景色
#define kLFBubbleViewColor          [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]
//默认圆角
#define kLFBubbleViewCornerRadius   5
//默认三角形高
#define kLFBubbleViewTriangleH      10
//默认三角形底边长
#define kLFBubbleViewTriangleW      10

typedef NS_ENUM(NSInteger, TriangleDirection) {
    TriangleDirection_Down,
    TriangleDirection_Left,
    TriangleDirection_Right,
    TriangleDirection_Up
};

@interface ZEBBubbleView : UIView


@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;//圆角
@property (nonatomic, assign) CGFloat triangleH;//三角形高
@property (nonatomic, assign) CGFloat triangleW;//三角形底边长
@property (nonatomic, strong) UIView *contentView;//容器，可放自定义视图，默认装文字
@property (nonatomic, strong) UILabel *lbTitle;//提示文字
@property (nonatomic) TriangleDirection direction;//三角方向，默认朝下

//优先使用triangleXY。如果triangleXY和triangleXYScale都不设置，则三角在中间
@property (nonatomic, assign) CGFloat triangleXY;//三角的x或y。
@property (nonatomic, assign) CGFloat triangleXYScale;//三角的中心x或y位置占边长的比例，如0.5代表在中间

/**
 *  消失
 */
- (void)dismiss;

/**
 *  显示
 *
 *  @param point 三角顶端位置
 */
- (void)showInPoint:(CGPoint)point;



@end
