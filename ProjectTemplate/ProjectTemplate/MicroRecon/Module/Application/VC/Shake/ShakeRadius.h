//
//  ShakeRadius.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShakeRadius;

typedef void(^clickBlock)(ShakeRadius *view);

@interface ShakeRadius : UIView

- (instancetype)initWithFrame:(CGRect)frame block:(clickBlock)block;
/**
 设置半径

 @param radius 设置半径
 */
- (void)setRadius:(NSString *)radius;
- (void)show;
- (void)dissmiss;
@end
