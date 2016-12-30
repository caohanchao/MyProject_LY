//
//  CHCDownMenuView.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//
#define JHMargin 10

#import "CHCDownMenuView.h"

//#import "JHDownMenuCell.h"
#import "CHCDownMenuCell.h"

@interface CHCDownMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGRect rect;
//@property (nonatomic, strong) UIImageView *bgview;

@end

@implementation CHCDownMenuView


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
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 10;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.rect = frame;
//        self.tableView.layer.masksToBounds = YES;
//        self.tableView.layer.cornerRadius = 5;
        self.tableView.frame = CGRectMake(0, JHMargin, self.bounds.size.width, self.bounds.size.height - JHMargin);
        
        
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        self.dataArray = @[@"删除好友"];
        self.imageArray = @[@"detail_delete"];
        self.tableView.layer.cornerRadius = 8;
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
    
    CHCDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[CHCDownMenuCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
//    cell.layer.masksToBounds = YES;
//    cell.layer.cornerRadius = 10;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleStr = self.dataArray[indexPath.row];
    cell.imageStr = self.imageArray[indexPath.row];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(CHCDownMenuView:tag:)]) {
        [_delegate CHCDownMenuView:self tag:indexPath.row];
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
    
//    self.messageContentV.maskView = [[UIImageView alloc] initWithImage:self.messageContentBackgroundIV.image highlightedImage:self.messageContentBackgroundIV.highlightedImage];
//     背景色
    
    [[UIColor whiteColor] set];
    // 获取视图
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 开始绘制
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, self.bounds.size.width - 30, self.tableView.frame.origin.y);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width - 15, self.tableView.frame.origin.y);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width - 15 * 1.5, self.tableView.frame.origin.y - JHMargin);
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
