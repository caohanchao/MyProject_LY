//
//  DXBBaseTableViewController.h
//  ProjectTemplate
//
//  Created by 戴小斌 on 2016/10/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define headerImgHeight 200 // 头部图片刚开始显示的高度（实际高度并不是200）
#define topBarHeight 64  // 导航栏加状态栏高度
#define switchBarHeight 40

@protocol TableViewScrollingProtocol <NSObject>

@required
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;

@end

@interface DXBBaseTableViewController : UITableViewController
@property (nonatomic, weak) id<TableViewScrollingProtocol> delegate;

@end
