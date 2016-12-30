//
//  ShakeSelectRadius.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define shakeSelectH 252.5

@class ShakeSelectRadius;

@protocol ShakeSelectRadiusDelegate <NSObject>

- (void)shakeSelectRadius:(ShakeSelectRadius *)view index:(NSInteger)index radius:(NSString *)radius;

@end

@interface ShakeSelectRadius : UIView

@property (nonatomic, weak) id<ShakeSelectRadiusDelegate> delegate;

- (void)show;
- (void)dissmiss;
@end
