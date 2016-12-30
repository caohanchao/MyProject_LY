//
//  CHCLabel.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CHCLabel.h"

@interface CHCLabel ()

@property(nonatomic,weak)UIView *view;
@end

@implementation CHCLabel

- (instancetype)initWithView:(UIView*)view {
    
    self = [super init];
    if (self) {
        self.view = view;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.frame = CGRectMake(0, TopBarHeight, kScreen_Width, 0);
        self.backgroundColor = [UIColor colorWithRed:0.54 green:0.53 blue:0.52 alpha:1.00];
        self.alpha = 0.8;
    }
    return self;

}
- (void)show:(NSString *)title {
    self.text = title;
    
    [self.view addSubview:self];
    CGRect rect = self.frame;
    rect.size.height = 44;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(disMiss) withObject:nil afterDelay:0.8];
    }];
    
}

- (void)disMiss {
    self.text  = nil;
    [self removeFromSuperview];
    CGRect rect = self.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
