//
//  AlView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AlView.h"

@implementation AlView
- (id)initWithFrame:(CGRect)frame type:(int) type{
    self = [super initWithFrame:frame];
    if (self) {
        if (type == TRANSPARENT_GRADIENT_TYPE) {
            [self insertTransparentGradient];
        }else if (type == COLOR_GRADIENT_TYPE){
            [self insertColorGradient];
        }else {
            
        }
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

//Transparent Gradient Layer
- (void) insertTransparentGradient {
    UIColor *colorOne = [UIColor colorWithHexString:@"ffffff" alpha:0.0];//[UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHexString:@"ffffff" alpha:1.0];//[UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.bounds;
    
    [self.layer insertSublayer:headerLayer atIndex:0];
}


//color gradient layer
- (void) insertColorGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.bounds;
    
    [self.layer insertSublayer:headerLayer above:0];
    
}

@end
