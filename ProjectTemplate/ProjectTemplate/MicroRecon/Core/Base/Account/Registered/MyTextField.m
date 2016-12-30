//
//  MyTextField.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x = 10;
    return leftRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    
    CGRect rightRect = CGRectZero;
    rightRect.origin.x = bounds.size.width - 92;
    rightRect.size.height = 25;
    rightRect.origin.y = (bounds.size.height - rightRect.size.height)/2;
    rightRect.size.width = 80;
    return rightRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    if (self.leftView == nil) {
        return CGRectInset(textRect, 10, 0);
    }
    CGFloat offset = 40 - textRect.origin.x;
    textRect.origin.x = 40;
    textRect.size.width = textRect.size.width - offset - 10;
    return textRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    if (self.leftView == nil) {
        return CGRectInset(textRect, 10, 0);
    }
    CGFloat offset = 40 - textRect.origin.x;
    textRect.origin.x = 40;
    textRect.size.width = textRect.size.width - offset - 10;
    return textRect;
}
@end


@implementation CHCTextField

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x = 10;
    return leftRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    
    CGRect rightRect = CGRectZero;
    rightRect.origin.x = bounds.size.width - 32;
    rightRect.size.height = 20;
    rightRect.origin.y = (bounds.size.height - rightRect.size.height)/2;
    rightRect.size.width = 20;
    return rightRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    if (self.leftView == nil) {
        return CGRectInset(textRect, 10, 0);
    }
    CGFloat offset = 40 - textRect.origin.x;
    textRect.origin.x = 40;
    textRect.size.width = textRect.size.width - offset - 10;
    return textRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    if (self.leftView == nil) {
        return CGRectInset(textRect, 10, 0);
    }
    CGFloat offset = 40 - textRect.origin.x;
    textRect.origin.x = 40;
    textRect.size.width = textRect.size.width - offset - 10;
    return textRect;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

@end
