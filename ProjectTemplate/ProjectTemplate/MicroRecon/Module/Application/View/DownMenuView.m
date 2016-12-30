//
//  DownMenuView.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define JHMargin 10

#import "DownMenuView.h"
#import "CHCDownMenuCell.h"

@interface DownMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) NSArray *delDataArray;
@property (nonatomic, assign) CGRect rect;

@end

@implementation DownMenuView

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

        self.delDataArray = @[@"删除帖子"];
        self.imageArray = @[@"cricledel"];
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
    return self.delDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"idx";
    
    CHCDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    
    if (cell == nil) {
        cell = [[CHCDownMenuCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleStr = self.delDataArray[indexPath.row];
    cell.imageStr = self.imageArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75/2;
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
