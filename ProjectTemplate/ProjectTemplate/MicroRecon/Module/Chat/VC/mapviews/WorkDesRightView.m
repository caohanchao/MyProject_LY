//
//  WorkDesRightView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkDesRightView.h"
#import "WorkDesRightTableViewCell.h"
#import "WorkDesRightTableViewTopCell.h"
#import "UITableView+FDTemplateLayoutCell.h"


#define TopMargin 10
#define leftMargin 5

@interface WorkDesRightView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate> {//此界面废弃


}

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WorkDesRightView

- (instancetype)initWithFrame:(CGRect)frame widthModel:(WorkAllTempModel *)model withWidth:(CGFloat)width block:(Block)block{

    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.model = model;
        self.w = width;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    [self createTableView];
    [self addPanGestureRecognizer];
}
- (void)addPanGestureRecognizer {

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipe.delegate = self;
    [self addGestureRecognizer:swipe];
    
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.2;
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    
}
//解决swipe与scrollview事件的冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark -
#pragma mark swipe手势
- (void)swipeView:(UISwipeGestureRecognizer *)swipe {
    
        self.block(self);
        CGRect rect = self.frame;
        rect.size.width = 0;
        rect.origin.x = kScreenWidth;
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            [self dismiss];
        }
}

- (void)showWithKeywindow {
    
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview:self.overlayView];
        [keywindow addSubview:self];
    
        CGRect rect = self.frame;
        rect.size.width = self.w;
        rect.origin.x = kScreenWidth-self.w;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = rect;
        } completion:^(BOOL finished) {
           
        }];
}
- (void)show {
    
    
    CGRect rect = self.frame;
    rect.size.width = self.w;
    rect.origin.x = kScreenWidth-self.w;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismissWithKeywindow {
    CGRect rect = self.frame;
    rect.size.width = 0;
    rect.origin.x = kScreenWidth;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }];
}
- (void)dismiss {
    CGRect rect = self.frame;
    rect.size.width = 0;
    rect.origin.x = kScreenWidth;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.w, height(self.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier1 = @"identifier1";
    static NSString *identifier2 = @"identifier2";
    
    if (indexPath.section == 0) {
        WorkDesRightTableViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[WorkDesRightTableViewTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1 widthModel:self.model];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        WorkDesRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[WorkDesRightTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2 widthModel:self.model];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1) {
        
        NSArray *pictures = [self.model.picture componentsSeparatedByString:@","];
        
        
        NSArray *videos = [self.model.video componentsSeparatedByString:@","];
        
        
        NSArray *audios = [self.model.audio componentsSeparatedByString:@","];
        
        
        NSInteger picCount = pictures.count;
        NSInteger videoCount = videos.count;
        NSInteger audioCount = audios.count;
        CGFloat leftM = 5;
        CGFloat centerM = 10;
        
        CGFloat topHeight = [LZXHelper textHeightFromTextString:self.model.content width:kScreenWidth-100-2*leftMargin fontSize:15] + 30 + 3*TopMargin;
        
        CGFloat btnW = (width(self.frame)-2*leftM-3*centerM)/4;
        CGFloat audioBtnH = 50;
        
        
        return topHeight + (btnW + centerM)*((picCount)/4 +1) + (btnW + centerM)*((videoCount)/4 +1) + (audioBtnH + centerM)*audioCount;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 20)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
