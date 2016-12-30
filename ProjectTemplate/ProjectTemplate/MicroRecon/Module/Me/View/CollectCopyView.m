//
//  CollectCopyView.m
//  WCLDConsulting
//
//  Created by apple on 16/4/4.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "CollectCopyView.h"
#import "CollectCopyCell.h"
#define ButtonHeight 40.5
#define HeadHeight 10

@interface CollectCopyView ()<UITableViewDataSource, UITableViewDelegate> {
    
    CGFloat _rect;
}

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation CollectCopyView


- (instancetype)initWidthName:(NSArray *)names {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
//        self.layer.cornerRadius = 3;
//        self.layer.masksToBounds = YES;
        
        self.names = names;
        _rect = (self.names.count+1)*ButtonHeight + HeadHeight;
        self.frame = CGRectMake(0, kScreen_Height-_rect, kScreen_Width, _rect);
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
       
    }
    return self;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        //_tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)createUI {
    [self addSubview:self.tableView];
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _names.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
      return HeadHeight;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ButtonHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    CollectCopyCell *cell  =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell  = [[CollectCopyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
     cell.string = self.names[indexPath.row];
    }else {
        cell.string = @"取消";
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self onCancleBtn];
    
    
    if (indexPath.section == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(collectCopy:index:title:)]) {
            [_delegate collectCopy:self index:indexPath.row title:self.names[indexPath.row]];
        }
    }
    if (indexPath.section==1) {
        if (_delegate && [_delegate respondsToSelector:@selector(collectCopy:index:title:)]) {
            [_delegate collectCopy:self index:self.names.count+indexPath.row title:@"取消"];
        }
    }
    
}
-(void)onCancleBtn{
    
    [self dismiss];
    
}


- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    self.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 0);
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
        
        self.frame = CGRectMake(0, kScreen_Height-_rect, kScreen_Width, _rect);
        
    }];
    
}

//弹出层
- (void)fadeOut
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.overlayView.alpha = 0;
        self.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 0);
        
    } completion:^(BOOL finished) {
        if (finished) {
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
