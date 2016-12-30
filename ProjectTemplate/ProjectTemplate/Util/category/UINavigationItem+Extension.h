//
//  UINavigationItem+Extension.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Extension)

- (NSArray<UIBarButtonItem *> *)leftItemsWithBarButtonItem:(UIBarButtonItem *)item WithSpace:(CGFloat)space;

- (NSArray<UIBarButtonItem *> *)rightItemsWithBarButtonItem:(UIBarButtonItem *)item WithSpace:(CGFloat)space;
@end
