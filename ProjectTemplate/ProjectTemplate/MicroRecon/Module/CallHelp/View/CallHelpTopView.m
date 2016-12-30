//
//  CallHelpTopView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpTopView.h"
#import "CallHelpTopTableViewCell.h"




@interface CallHelpTopView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CallHelpTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = zWhiteColor;
        [self initView];
    }
    return self;
}
- (void)initView {
    [self initTopView];
    [self initTableView];
}
- (void)initTopView {
    self.topView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    self.topView.backgroundColor = zWhiteColor;
    [self addSubview:self.topView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY(self.topView)+0.5, kScreenWidth, height(self.frame)-height(self.topView.frame)-0.5)];
    self.bottomView.backgroundColor = zWhiteColor;
    [self addSubview:self.bottomView];
    
    
    self.titleLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(15) textColor:zBlackColor text:@"0"];
    self.titleLabel.frame = CGRectMake(10, 0, 200, height(self.topView.frame));
    [self.topView addSubview:self.titleLabel];
    
    
    self.clearBtn = [CHCUI createButtonWithtarg:self sel:@selector(dissmiss) titColor:zWhiteColor font:ZEBFont(16) image:nil backGroundImage:nil title:@""];
    [self.clearBtn setImage:[UIImage imageNamed:@"pathguanbi"] forState:UIControlStateNormal];
    self.clearBtn.frame = CGRectMake(kScreenWidth-10-height(self.topView.frame), 0, height(self.topView.frame), height(self.topView.frame));
    [self.topView addSubview:self.clearBtn];
    
    self.line  = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(self.clearBtn), kScreenWidth, 0.5)];
    self.line.backgroundColor = LineColor;
    [self addSubview:self.line];
    
    self.line.hidden = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
}
- (void)initTableView {
    [self.bottomView addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 32, kScreenWidth-20) style:UITableViewStyleGrouped];
        _tableView.center = CGPointMake(_bottomView.center.x-25, _bottomView.center.y+10);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _tableView.backgroundColor = zWhiteColor;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indextifier = @"indextifier";
    CallHelpTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
    if (cell == nil) {
        cell = [[CallHelpTopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
    }
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)show {
    CGRect rect = self.frame;
    rect.size.height = HEIGHT;
    self.line.hidden = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
}
- (void)dissmiss {
    CGRect rect = self.frame;
    rect.size.height = 0;
    self.line.hidden = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
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
