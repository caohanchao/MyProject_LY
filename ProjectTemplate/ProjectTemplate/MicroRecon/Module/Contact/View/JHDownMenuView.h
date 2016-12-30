//
//  JHDownMenuView.h
//  模仿QQ下拉菜单
//
//  Created by zhou on 16/7/21.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHDownMenuView;

@protocol JHDownMenuViewDelegate <NSObject>

- (void)jHDownMenuView:(JHDownMenuView *)view tag:(NSInteger)tag;

@end

@interface JHDownMenuView : UIView


@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id<JHDownMenuViewDelegate> delegate;
- (void)show;
- (void)dismiss;
@end
