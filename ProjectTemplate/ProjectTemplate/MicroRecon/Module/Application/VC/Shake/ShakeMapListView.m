//
//  VehicleDetectionListView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  查看列表

#import "ShakeMapListView.h"
#import "ShakeTopView.h"
#import "ShakeCameraTableViewCell.h"
#import "ShakePolicingTableViewCell.h"
#import "ShakeCameraModel.h"

#define titleFont 10 // label字体大小
#define topViewHeight 23 // 拖动区域的


@interface ShakeMapListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ShakeTopView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isCenter;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *gLabel;
@end

@implementation ShakeMapListView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = zClearColor;
        [self initShadow];
        [self initView];
        self.isCenter = YES;
    }
    return self;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initShadow {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowOpacity = 0.9f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    ShakeTopView *view = [[ShakeTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight+1)];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self addSubview:view];
}
- (ShakeTopView *)topView {
    if (!_topView) {
        _topView = [[ShakeTopView alloc] initWithFrame:CGRectMake(0, -15, kScreenWidth, 39)];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(_topView)-1, kScreenWidth, 16)];
        _titleLabel.text = @"查看结果";
        _titleLabel.font = ZEBFont(titleFont);
        _titleLabel.textColor = zBlackColor;
        _titleLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)initView {
    
//    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [self addGestureRecognizer:pangesture];
    
    [self addSubview:self.topView];
    
    UILabel *gLabel = [[UILabel alloc] initWithFrame:CGRectMake(width(self.frame)/2-18, 10+15, 34, 4)];
    gLabel.backgroundColor = [UIColor lightGrayColor];
    gLabel.layer.masksToBounds = YES;
    gLabel.layer.cornerRadius = 2;
    [_topView addSubview:gLabel];
    self.gLabel = gLabel;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, topViewHeight, kScreen_Width, height(self.frame)-topViewHeight);
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
 //   self.tableView.userInteractionEnabled = YES;
   
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
  //  self.tableView.userInteractionEnabled = YES;
   
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
   // self.tableView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight-39, kScreen_Width, 39);
        [self addSubview:self.titleLabel];
    }];
    
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
#pragma mark -
#pragma mark tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier1 = @"identifier1";
    static NSString *identifier2 = @"identifier2";
    if (self.shakeMapListType == ShakeMapListPolicing) {
        ShakePolicingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[ShakePolicingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
        }
        cell.type = self.shakeMapListType;
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }
    ShakeCameraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (cell == nil) {
        cell = [[ShakeCameraTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
    }
    cell.type = self.shakeMapListType;
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shakeMapListType == ShakeMapListPolicing) {
        return 75;
    }
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self isToBottom];
    if (_delegate && [_delegate respondsToSelector:@selector(shakeMapListView:model:)]) {
        [_delegate shakeMapListView:self model:self.dataArray[indexPath.section]];
    }
}
#pragma mark -
#pragma mark 刷新tableview
- (void)reloadData:(NSMutableArray *)arr {
    [self.dataArray addObjectsFromArray:arr];
    [self.tableView reloadData];
}
// 滚动视图
- (void)scrollToSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
// 选中
- (void)selectSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}
//在中间
- (void)scrollToCenter {
    if (!self.isCenter) {
        [self.titleLabel removeFromSuperview];
        [self isToCenter];
    }
}
#pragma mark -
#pragma mark scrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//    NSInteger currentPostion = scrollView.mj_offsetY;
//    ZEBLog(@"scrollViewWillBeginDragging-------%ld",currentPostion);
//    if (currentPostion == 0) {
//        self.tableView.userInteractionEnabled = NO;
//        
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
