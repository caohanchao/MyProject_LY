//
//  UtHeaderView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UtHeaderView;

@protocol UtHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(UtHeaderView *)headerView isOpen:(BOOL)isOpen;

@end

@interface UtHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/** 标识这组是否需要展开,  YES : 展开 ,  NO : 关闭 */
@property (nonatomic, assign, getter = isOpend) BOOL opend;
@property (nonatomic, copy) NSString *titleStr;
/** 代理 */
@property (nonatomic, weak) id<UtHeaderViewDelegate> delegate;


@end
