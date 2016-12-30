//
//  UIButton+Layout.h
//  alertView
//
//  Created by TONY on 15/11/18.
//  Copyright © 2015年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Layout)

/**
    layout titleLabel and imageView in UIButton
 
    title     :   text in button
    titleFont :   text's font
    image     :   image in button
    gap       :   gap between button and image
    layType   :   0:title---left ,image---right
                  1:title---right ,image---left
                  2:title---down ,image---up
 */
-(void)layoutButtonForTitle:(NSString *)title
                  titleFont:(UIFont *)titleFont
                      image:(UIImage *)image
                 gapBetween:(CGFloat)gap
                    layType:(NSInteger)layType;
@end
