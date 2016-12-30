//
//  CollectCopyView.h
//  WCLDConsulting
//
//  Created by apple on 16/4/4.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectCopyView;

@protocol CollectCopyDelegate <NSObject>

- (void)collectCopy:(CollectCopyView *)view index:(NSInteger)index title:(NSString *)title;

@end

@interface CollectCopyView : UIView
@property (nonatomic, weak) id<CollectCopyDelegate> delegate;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) UIControl *overlayView;
- (instancetype)initWidthName:(NSArray *)names;
- (void)dismiss;
- (void)show;
@end
