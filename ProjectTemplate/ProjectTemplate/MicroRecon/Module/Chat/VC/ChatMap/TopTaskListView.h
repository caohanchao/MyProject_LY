//
//  TopTaskListView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopTaskListView;

typedef void(^ClickCellBlock)(TopTaskListView *view , NSInteger index);

@interface TopTaskListView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) ClickCellBlock block;
@property (nonatomic, weak) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIndex;



- (instancetype)initWithFrame:(CGRect)frame widthDataArray:(NSArray *)dataArray withBlock:(ClickCellBlock)block;
@end
