//
//  WorkDesRightView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkAllTempModel.h"

@class WorkDesRightView;

typedef void(^Block)(WorkDesRightView *view);

@interface WorkDesRightView : UIView

@property (nonatomic, copy) Block block;
@property (nonatomic, weak) WorkAllTempModel *model;

- (instancetype)initWithFrame:(CGRect)frame widthModel:(WorkAllTempModel *)model withWidth:(CGFloat)width block:(Block)block;
- (void)show;
- (void)dismiss;

- (void)showWithKeywindow;
- (void)dismissWithKeywindow;
@end
