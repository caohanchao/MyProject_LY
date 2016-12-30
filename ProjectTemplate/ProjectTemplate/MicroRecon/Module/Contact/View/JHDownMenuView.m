//
//  JHDownMenuView.m
//  模仿QQ下拉菜单
//
//  Created by zhou on 16/7/21.
//  Copyright © 2016年 zhou. All rights reserved.
//

#define JHMargin 10

#import "JHDownMenuView.h"

#import "JHDownMenuCell.h"


@interface JHDownMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGRect rect;

@end

@implementation JHDownMenuView

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        
        [self addSubview:_tableView];
    }
    return _tableView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.rect = frame;
        self.tableView.frame = CGRectMake(0, JHMargin, self.bounds.size.width, self.bounds.size.height -5);
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        self.dataArray = @[@"发起组队",
//                           @"添加好友",
//                           @"侦查任务",
//                           @"扫一扫"];
//        self.imageArray = @[@"qunliao_icon",@"addfriend_icon",@"zhencha_icon",@"sao_sao_bg"];
                self.dataArray = @[@"发起组队",
                                   @"添加好友",
                                   @"扫一扫",
                                   @"侦查任务",
                                   @"安保任务",
                                   @"巡控任务"];
                self.imageArray = @[@"qunliao_icon",@"addfriend_icon",@"sao_sao_bg",@"zhencha_bg"/*@"zhencha_task"*/,@"anbao_task",@"xunkong_task"];
        self.tableView.layer.cornerRadius = 5;
        self.tableView.clipsToBounds = YES;
        self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.2;
        
        [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }


    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"idx";

    JHDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    
    if (cell == nil) {
        cell = [[JHDownMenuCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleStr = self.dataArray[indexPath.row];
    cell.imageStr = self.imageArray[indexPath.row];
    if (indexPath.row == 4||indexPath.row == 5)
    {
        cell.titleLabel.textColor = [UIColor grayColor];
    }

  
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(jHDownMenuView:tag:)]) {
        [_delegate jHDownMenuView:self tag:indexPath.row];
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)drawRect:(CGRect)rect
{
    // 背景色

    [[UIColor whiteColor] set];

    
    // 获取视图
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 开始绘制
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, self.bounds.size.width - 30, self.tableView.frame.origin.y);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width - 10, self.tableView.frame.origin.y);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width - 20, self.tableView.frame.origin.y - JHMargin);
    // 结束绘制
    CGContextClosePath(contextRef);
    // 填充色
    [[UIColor whiteColor] setFill];
    // 边框颜色
    [[UIColor whiteColor] setStroke];

    // 绘制路径
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
}
- (void)show
{
    
    self.alpha = 0;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
   
    [self fadeIn];
}
- (void)dismiss
{
    [self fadeOut];
}
//弹入层
- (void)fadeIn
{
    
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
    
}
//弹出层
- (void)fadeOut
{
    
    [UIView animateWithDuration:.1 animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
             self.isShow = NO;
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}
@end
