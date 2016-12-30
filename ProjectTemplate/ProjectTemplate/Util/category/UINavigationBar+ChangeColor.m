//
//  UINavigationBar+ChangeColor.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UINavigationBar+ChangeColor.h"
#import <objc/runtime.h>


@implementation UINavigationBar (ChangeColor)

static char overlayKey;


- (UIImageView *)navBarHairlineImageView {
    return objc_getAssociatedObject(self, @selector(navBarHairlineImageView));
    
}
- (void)setNavBarHairlineImageView:(UIImageView *)navBarHairlineImageView {
    
    objc_setAssociatedObject(self, @selector(navBarHairlineImageView), navBarHairlineImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)overlay

{
    return objc_getAssociatedObject(self, &overlayKey);
    
}
- (void)setOverlay:(UIView *)overlay

{
    
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (void)zeb_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        
        self.overlay.userInteractionEnabled = NO;
        
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:self.overlay atIndex:0];
        
    }
    
    self.overlay.backgroundColor = backgroundColor;
    
}

- (void)zeb_setElementsAlpha:(CGFloat)alpha {
    
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        
        view.alpha = alpha;
        
    }];
    
    
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        
        view.alpha = alpha;
        
    }];
    
    
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    
    titleView.alpha = alpha;
    
    //    when viewController first load, the titleView maybe nil
    
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            
            obj.alpha = alpha;
            
            *stop = YES;
            
        }
        
    }];
}

- (void)zeb_setTranslationY:(CGFloat)translationY {
    
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
    
}

- (void)zeb_reset {
    
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.overlay removeFromSuperview];
    
    self.overlay = nil;
}

- (void)zeb_getNavBarHairlineImageView {
    
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self];
}
- (void)zeb_HairlineImageViewUnderSetHidden:(BOOL)hidden {
    
    if (!self.navBarHairlineImageView) {
        //得到底线
        [self zeb_getNavBarHairlineImageView];
    }
    [self.navBarHairlineImageView setHidden:hidden];
    
}
//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
