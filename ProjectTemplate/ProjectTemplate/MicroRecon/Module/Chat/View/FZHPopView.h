//
//  ChatGroupAtController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupMemberModel;
@class FZHPopView;

#define SEARCHH 43

@protocol FZHPopViewDelegate <NSObject>

- (void)getTheButtonTitleWithButton:(UIButton *)button;
- (void)atAllMember:(FZHPopView *)view;
- (void)atOneMember:(FZHPopView *)view model:(GroupMemberModel *)model;
- (void)fZHPopViewDidScroll:(FZHPopView *)fZHPopView;
@end

@interface FZHPopView : UIView
/**
 *  数据原
 */
@property (nonatomic, strong) NSArray *dataSource;
/**
 *  内容视图
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  按钮高度
 */
@property (nonatomic, assign) CGFloat buttonH;
/**
 *  按钮的垂直方向的间隙
 */
@property (nonatomic, assign) CGFloat buttonMargin;
/**
 *  内容视图的位移
 */
@property (nonatomic, assign) CGFloat contentShift;
/**
 *  动画持续时间
 */
@property (nonatomic, assign) CGFloat animationTime;
/**
 * tableView的高度
 */
@property (nonatomic, assign) CGFloat tableViewH;
@property (nonatomic, weak) id <FZHPopViewDelegate> fzhPopViewDelegate ;
/**
 *  展示popView
 *
 *  
 */
- (void)showThePopViewWithArray;
/**
 *  移除popView
 */
- (void)dismissThePopView;
/**
 *  刷新数据
 */
- (void)reloadData;

@end
