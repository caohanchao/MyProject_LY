//
//  UINavigationBar+ChangeColor.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ChangeColor)


/**
 底线
 */
@property (nonatomic, weak) UIImageView *navBarHairlineImageView;

/**
 修改导航栏颜色

 @param backgroundColor 导航栏颜色
 */
- (void)zeb_setBackgroundColor:(UIColor *)backgroundColor;

/**
 修改导航栏透明度

 @param alpha 导航栏透明度
 */
- (void)zeb_setElementsAlpha:(CGFloat)alpha;

/**
 修改导航栏平移变量

 @param translationY 导航栏平移变量
 */
- (void)zeb_setTranslationY:(CGFloat)translationY;

/**
 还原导航栏
 */
- (void)zeb_reset;

/**
 得到导航栏底线 
 */
- (void)zeb_getNavBarHairlineImageView;


/**
 设置底线是否显示

 @param hidden 是否显示
 */
- (void)zeb_HairlineImageViewUnderSetHidden:(BOOL)hidden;
@end
