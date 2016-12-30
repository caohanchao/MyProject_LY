//
//  ZEBTableView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBTableView.h"

@implementation ZEBTableView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pangesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint offset = [pangesture translationInView:self];
        CameraMoveDirection direction = [LZXHelper tableviewTranslation:offset];
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
