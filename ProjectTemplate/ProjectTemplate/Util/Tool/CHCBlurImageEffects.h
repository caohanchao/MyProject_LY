//
//  PDBlurImageEffects.h
//  PDBlurImage
//
//  Created by chc on 16/9/5.
//  Copyright © 2016年 caohanchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHCBlurImageEffects : NSObject

/**
 *  不同效果的图片输出
 */
+ (UIImage *)pd_imageEffectLightFromImage:(UIImage *)inputImage;
+ (UIImage *)pd_imageEffectExtraLightFromImage:(UIImage *)inputImage;
+ (UIImage *)pd_imageEffectDarkFromImage:(UIImage *)inputImage;
+ (UIImage *)pd_imageEffectTintFromImage:(UIImage *)inputImage andEffectColor:(UIColor *)tintColor;

@end
