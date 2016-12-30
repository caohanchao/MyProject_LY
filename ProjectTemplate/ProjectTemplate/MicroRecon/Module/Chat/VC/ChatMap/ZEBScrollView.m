//
//  ZEBScrollView.m
//  WCLDConsulting
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "ZEBScrollView.h"


@implementation ZEBScrollView


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pangesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint offset = [pangesture translationInView:self];
        CameraMoveDirection direction = [LZXHelper commitTranslation:offset];
        if (direction == kCameraMoveDirectionRight || direction == kCameraMoveDirectionLeft) {
            return NO;
        }
        return YES;
    }
    else
    {
        return  NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
