//
//  UIImage+Color.h
//  ProjectTemplate
//
//  Created by 戴小斌 on 2016/10/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
