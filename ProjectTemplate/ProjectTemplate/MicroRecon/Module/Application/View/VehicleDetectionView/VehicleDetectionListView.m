//
//  VehicleDetectionListView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  查看列表

#import "VehicleDetectionListView.h"
#import "VdTableViewCell.h"
#import "VdTableViewHeaderView.h"
#import "VdTopView.h"
#import "VdResultModel.h"
#import "VdLineTableViewCell.h"

#define titleFont 12 // label字体大小
#define topViewHeight 0//23 // 拖动区域的


@interface VehicleDetectionListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) VdTopView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isCenter;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *gLabel;

@end

@implementation VehicleDetectionListView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableDictionary *)dateDic {
    if (!_dateDic) {
        _dateDic = [NSMutableDictionary dictionary];
    }
    return _dateDic;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
       // [self initShadow];
        [self initView];
        self.isBottom = YES;
    }
    return self;
}
- (void)initShadow {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowOpacity = 0.9f;
    self.layer.shadowPath = shadowPath.CGPath;
    
//    VdTopView *view = [[VdTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight+1)];
//    view.backgroundColor = CHCHexColor(@"f5f5f5");
//    [self addSubview:view];
}
- (VdTopView *)topView {
    if (!_topView) {
        _topView = [[VdTopView alloc] initWithFrame:CGRectMake(0, -15, kScreenWidth, 39)];
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPullView:)];
        UISwipeGestureRecognizer *swipgesturedown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipPullView:)];
        swipgesturedown.direction = UISwipeGestureRecognizerDirectionDown; //设置向下清扫
        [_topView addGestureRecognizer:swipgesturedown];
        [_topView addGestureRecognizer:pangesture];
        _topView.backgroundColor = zClearColor;
        
        [pangesture requireGestureRecognizerToFail:swipgesturedown];
    }
    return _topView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height(_bottomView.frame)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor  = CHCHexColor(@"f5f5f5");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = LineColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(_topView)-1, kScreenWidth, 16)];
        _titleLabel.text = @"查看结果";
        _titleLabel.font = ZEBFont(titleFont);
        _titleLabel.textColor = CHCHexColor(@"333333");
        _titleLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)initView {
    
//    [self addSubview:self.topView];
//    
//    UILabel *gLabel = [[UILabel alloc] initWithFrame:CGRectMake(width(self.frame)/2-18, 10+15, 34, 4)];
//    gLabel.backgroundColor = CHCHexColor(@"d2d2d2");
//    gLabel.layer.masksToBounds = YES;
//    gLabel.layer.cornerRadius = 2;
//    [_topView addSubview:gLabel];
//    self.gLabel = gLabel;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, topViewHeight, kScreen_Width, height(self.frame)-topViewHeight);
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    [_bottomView addSubview:self.tableView];
    
}
#pragma mark -
#pragma mark pan手势

- (void)panPullView:(UIPanGestureRecognizer *)pangesture {
  
    CGPoint offset = [pangesture translationInView:self];//得到手指的位移
    // CameraMoveDirection direction = [LZXHelper commitTranslation:offset];
    
    CGRect rect = self.frame;
    CGFloat h = rect.origin.y;
    
    if (pangesture.state == UIGestureRecognizerStateBegan) {
         [self.titleLabel removeFromSuperview];
        //处理拖动过程漏出白底界面
        _bottomView.frame = CGRectMake(0, topViewHeight, kScreen_Width, kScreenHeight);
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame));
        } completion:^(BOOL finished) {
        }];
    }
    if (pangesture.state == UIGestureRecognizerStateChanged) {
        
        if (h >= 64) {
            [UIView animateWithDuration:0.15 animations:^{
                [self setCenter:CGPointMake(self.center.x, self.center.y + offset.y)];
                [pangesture setTranslation:CGPointMake(0, 0) inView:self];
            }];
            
        }else if (h <= kScreenHeight-64) {
            [UIView animateWithDuration:0.15 animations:^{
                [self setCenter:CGPointMake(self.center.x, self.center.y + offset.y)];
                [pangesture setTranslation:CGPointMake(0, 0) inView:self];
            }];
            
        }
   // NSLog(@"我的大小%@---HeightC= %f---h=%f========alpha=%f",NSStringFromCGRect(rect),HeightC,h,1 - (h/(HeightC)));
        
    } else if(pangesture.state == UIGestureRecognizerStateEnded){
        
        if ( h <= HeightC*0.85) {
            
            [self isToTop];
            
        } else if( h > HeightC*0.85 && h < kScreenHeight*0.85){
            
            [self isToCenter];
            
        }else if (h >= kScreenHeight*0.85) {
            [self isToBottom];
        }
    }
}
#pragma mark -
#pragma mark swip手势
- (void)swipPullView:(UISwipeGestureRecognizer *)swipgesture {

    if (self.isTop) {
        if (swipgesture.direction == UISwipeGestureRecognizerDirectionDown){
            [self isToCenter];
        }
        
    }else if (self.isCenter) {
        if (swipgesture.direction == UISwipeGestureRecognizerDirectionDown){
            [self isToBottom];
            
        }
    }else if (self.isBottom) {
        if (swipgesture.direction == UISwipeGestureRecognizerDirectionDown){
            [self isToBottom];
        }
    }
}
- (void)isToTop {
    self.isTop = YES;
    self.isCenter = NO;
    self.isBottom = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 64, kScreen_Width, kScreenHeight-64);
    }];
    _bottomView.frame = CGRectMake(0, topViewHeight, kScreen_Width, height(self.frame)-topViewHeight);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame));
    }];
}
- (void)isToCenter {
    self.isTop = NO;
    self.isCenter = YES;
    self.isBottom = NO;

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, HeightC, kScreen_Width, kScreenHeight - HeightC);
    }];
    
    _bottomView.frame = CGRectMake(0, topViewHeight, kScreen_Width, height(self.frame)-topViewHeight);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame));
    }];
}
- (void)isToBottom {
    self.isTop = NO;
    self.isCenter = NO;
    self.isBottom = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight-39, kScreen_Width, 39);
        [self addSubview:self.titleLabel];
    }];
    
}
#pragma mark -
#pragma mark tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString * key = self.titleArray[section];
    NSArray * array = self.dateDic[key];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    static NSString *identifier1 = @"identifier1";
    
    NSString * key = self.titleArray[indexPath.section];
    NSArray * array = self.dateDic[key];
    if (indexPath.row == array.count-1) {
        VdLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[VdLineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = CHCHexColor(@"eeeeee");
            cell.selectedBackgroundView = bgView;
        }
        VdResultModel *model = array[indexPath.row];
        cell.time = model.jgsj;
        LKXXModel *lkxxModel = [[[model.sbxx firstObject] lkxx] firstObject];
        cell.bayonetName = lkxxModel.kkmc;
        cell.index = model.kkindex;
        return cell;
    }
    VdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (cell == nil) {
        cell = [[VdTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = CHCHexColor(@"eeeeee");
        cell.selectedBackgroundView = bgView;
    }
    VdResultModel *model = array[indexPath.row];
    cell.time = model.jgsj;
    LKXXModel *lkxxModel = [[[model.sbxx firstObject] lkxx] firstObject];
    cell.bayonetName = lkxxModel.kkmc;
    cell.index = model.kkindex;
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VdTableViewHeaderView *headerView = [VdTableViewHeaderView headerViewWithTableView:tableView];
    headerView.time = self.titleArray[section];;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

   
  //  [self isToBottom];
    
    NSString * key = self.titleArray[indexPath.section];
    NSArray * array = self.dateDic[key];
    VdResultModel *model = array[indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(vehicleDetectionListView:vdResultModel:)]) {
        [_delegate vehicleDetectionListView:self vdResultModel:model];
    }
}
- (void)reloadData {
    
    [self.tableView reloadData];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView * view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.topView convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.topView.bounds, newPoint)) {
            view = self.topView;
        }
    }
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
