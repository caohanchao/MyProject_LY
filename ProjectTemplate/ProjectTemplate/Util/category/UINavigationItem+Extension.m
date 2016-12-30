//
//  UINavigationItem+Extension.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UINavigationItem+Extension.h"

@implementation UINavigationItem (Extension)

- (NSArray<UIBarButtonItem *> *)leftItemsWithBarButtonItem:(UIBarButtonItem *)item WithSpace:(CGFloat)space {
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    spacer.width = -space;
    
    [self setLeftBarButtonItems:[NSArray arrayWithObjects:spacer,item, nil]];
    
    return self.leftBarButtonItems;
    
    
}

- (NSArray<UIBarButtonItem *> *)rightItemsWithBarButtonItem:(UIBarButtonItem *)item WithSpace:(CGFloat)space {
 
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    spacer.width = -space;
    
    [self setRightBarButtonItems:[NSArray arrayWithObjects:spacer,item, nil]];
    
    return self.rightBarButtonItems;

}
@end
