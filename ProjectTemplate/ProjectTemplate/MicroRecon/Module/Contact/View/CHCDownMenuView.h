//
//  CHCDownMenuView.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCDownMenuView;

@protocol CHCDownMenuViewDelegate <NSObject>

- (void)CHCDownMenuView:(CHCDownMenuView *)view tag:(NSInteger)tag;

@end

@interface CHCDownMenuView : UIView

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id<CHCDownMenuViewDelegate> delegate;

- (void)show;
- (void)dismiss;

@end
