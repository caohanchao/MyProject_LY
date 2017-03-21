//
//  CallHelpTopView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpTopView.h"
#import "CallHelpTopTableViewCell.h"

@interface CallHelpTopView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;

@property (strong, nonatomic) NSMutableArray *userHelpArr;
@property (copy, nonatomic) NSString *sureHelpAlarm;
@property (copy, nonatomic) NSString *sendAlarm;

@property (strong, nonatomic) UIView *BgView;
@property (strong, nonatomic) UIView *reseveBgView;
@property (strong, nonatomic) UILabel *reseveTextlabel;
@property (strong, nonatomic) UILabel *reseveTimeLabel;
@property (strong, nonatomic) UILabel *reseveNameLabel;
@property (strong, nonatomic) NSArray *reseveImageArr;
@property (strong, nonatomic) NSArray *reseveTitleArr;
@property (strong, nonatomic) UIImageView *reseveIconImageView;

@property (copy, nonatomic) NSString *userAlarm;

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
    [self initRouter];
    [self initTopView];
    [self initBottomView];
    [self initTableView];
}

// 注册block路由
- (void)initRouter {
    
    WeakSelf
    //有人确认增援
    [LYRouter registerURLPattern:@"ly://UserSureHelpCallHelp" toHandler:^(NSDictionary *routerParameters) {
        _sureHelpAlarm = routerParameters[@"LYRouterParameterUserInfo"][@"userAlarm"];
        if (![[LZXHelper isNullToString:_sureHelpAlarm] isEqualToString:@""]) {
            [_userHelpArr addObject:_sureHelpAlarm];
            
            weakSelf.titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_userHelpArr.count];
            
            [weakSelf.tableView reloadData];
        }
        
    }];
    
    //确认增援的人取消增援
    [LYRouter registerURLPattern:@"ly://UserCancelCallHelp" toHandler:^(NSDictionary *routerParameters) {
        
        _sureHelpAlarm = routerParameters[@"LYRouterParameterUserInfo"][@"userAlarm"];
        if (![[LZXHelper isNullToString:_sureHelpAlarm] isEqualToString:@""]) {
            [_userHelpArr removeObject:_sureHelpAlarm];
            
            weakSelf.titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_userHelpArr.count];
            
            [weakSelf.tableView reloadData];
        }
    }];
    
    //自己确认增援
    [LYRouter registerURLPattern:@"ly://OwenUserSureHelpCallHelp" toHandler:^(NSDictionary *routerParameters) {
        _sureHelpAlarm = routerParameters[@"LYRouterParameterUserInfo"][@"userAlarm"];
        if (![[LZXHelper isNullToString:_sureHelpAlarm] isEqualToString:@""]) {
            [_userHelpArr addObject:_sureHelpAlarm];
            
            weakSelf.titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_userHelpArr.count];
            
            [weakSelf.tableView reloadData];
        }
        
    }];
    
    
    [LYRouter registerURLPattern:@"ly://selsetCell" toHandler:^(NSDictionary *routerParameters) {
        
    }];
    
}

- (void)initBottomView {
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.BgView];
    [self.BgView addSubview:self.reseveBgView];
    [self.reseveBgView addSubview:self.reseveIconImageView];
    [self.reseveBgView addSubview:self.reseveNameLabel];
    [self.reseveBgView addSubview:self.reseveTextlabel];
    [self.reseveBgView addSubview:self.reseveTimeLabel];
    
    [self createThreeImageViewAndTitleAndButton];
}

- (void)initTopView {
    self.topView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.topView.backgroundColor = zWhiteColor;
    [self addSubview:self.topView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY(self.topView)+0.5, kScreenWidth, 100)];
    self.bottomView.backgroundColor = zWhiteColor;
    [self addSubview:self.bottomView];
    
    
    self.titleLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(15) textColor:zBlueColor text:@"0"];
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = [zBlueColor CGColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(12, 15/2, 25, 25);
    [self.topView addSubview:self.titleLabel];
    
    self.clearBtn = [CHCUI createButtonWithtarg:self sel:@selector(cancelHelp) titColor:zWhiteColor font:ZEBFont(16) image:nil backGroundImage:nil title:@""];
    [self.clearBtn setImage:[UIImage imageNamed:@"pathguanbi"] forState:UIControlStateNormal];
    self.clearBtn.frame = CGRectMake(kScreenWidth-height(self.topView.frame), 0, height(self.topView.frame), height(self.topView.frame));
    [self.topView addSubview:self.clearBtn];
    
    self.textLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(15) textColor:zGrayColor text:@"解除呼叫增援"];
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.textLabel.frame = CGRectMake(minX(self.clearBtn)-screenWidth()/2, 5, screenWidth()/2, height(self.topView.frame)-10);
    [self.topView addSubview:self.textLabel];
    
    self.line  = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(self.clearBtn), kScreenWidth, 0.5)];
    self.line.backgroundColor = LineColor;
    [self addSubview:self.line];
    
    self.imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    self.imageView.frame = CGRectMake(15, 15, 50, 50);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView addGestureRecognizer:tap];
  //  NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
   // [self.imageView imageGetCacheForAlarm:alarm forUrl:nil];
    self.imageView.userInteractionEnabled = YES;
    [self.bottomView addSubview:self.imageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 77, 60, 20)];
    self.nameLabel.textColor  = ZEBRedColor;
  //  self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:14.0];
    [self.bottomView addSubview:self.nameLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(81+50, 48, 1, 100)];//1
  //  self.lineView.backgroundColor = zBlueColor;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor grayColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, 100, 1);
    self.lineView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    [self.lineView.layer addSublayer:gradientLayer];
    
    [self.bottomView addSubview: self.lineView];
    
    self.line.hidden = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    
    _userHelpArr = [NSMutableArray arrayWithCapacity:0];
    
}
- (void)initTableView {
    [self.bottomView addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(180, -92, 100, screenWidth()-90) style:UITableViewStyleGrouped];
        if (ZEBiPhone5_OR_5c_OR_5s) {
            _tableView.frame = CGRectMake(150, -66, 100, screenWidth()-90);
        }
        else  if (ZEBiPhone6Plus_OR_6sPlus)
        {
            _tableView.frame = CGRectMake(200, -114, 100, screenWidth()-90);
        }
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
    
    return _userHelpArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indextifier = @"indextifier";
    CallHelpTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
    if (cell == nil) {
        cell = [[CallHelpTopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.userArr = _userHelpArr;
    cell.row = indexPath.row;
    
    [cell setUserImageBlock:^{
        WeakSelf
        [weakSelf userViewShow:_userHelpArr[ indexPath.row]];
    }];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)showWithAlarm:(NSString *)alarm {
    CGRect rect = self.frame;
    rect.size.height = HEIGHT;
    self.line.hidden = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
    
    UserAllModel * model = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:alarm];
    
    NSString *alarmOwn = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([alarm isEqualToString:alarmOwn]) {
        UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
        _nameLabel.text = model.name;
    }else {
        _nameLabel.text = model.RE_name;
    }
    
//    if ([model.RE_name isEqualToString:@"文件助手"]||[model.RE_name isEqualToString:@"文件小助手"]) {
//        UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
//        self.nameLabel.text = model.name;
//    }
//    else
//    {
//        self.nameLabel.text = model.RE_name;
//    }
    [self.imageView imageGetCacheForAlarm:alarm forUrl:model.RE_headpic];
    
    _userHelpArr = [NSMutableArray array];
    [_userHelpArr removeAllObjects];
    [self.tableView reloadData];
    _sendAlarm = alarm;
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
    
    [_userHelpArr removeAllObjects];
}

//解除救援
- (void)cancelHelp
{
    NSDictionary *userDict =[[NSDictionary alloc] initWithObjectsAndKeys:_sendAlarm,@"userAlarm", nil];
    
    [LYRouter openURL:@"ly://snedCallHelpCancelHelp" withUserInfo:userDict completion:nil];
}

- (void)tap:(UITapGestureRecognizer*)recognizer
{
    if ([_sendAlarm isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]]) {
        [LYRouter openURL:@"ly://selectOwn" withUserInfo:nil completion:nil];
    }
    else
    {
        self.BgView.hidden = NO;
        self.reseveBgView.hidden = NO;
        UserAllModel * model = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:_sendAlarm];
        
        _userAlarm = model.RE_alarmNum;
        
        [self.reseveIconImageView imageGetCacheForAlarm:_sendAlarm forUrl:@"111"];
        
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        if ([model.RE_alarmNum isEqualToString:alarm]) {
            UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
            self.reseveNameLabel.text = model.name;
        }else {
            self.reseveNameLabel.text = model.RE_name;
        }
        
//        if ([model.RE_name isEqualToString:@"文件助手"]||[model.RE_name isEqualToString:@"文件小助手"]) {
//            UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
//            self.reseveNameLabel.text = model.name;
//        }
//        else
//        {
//           self.reseveNameLabel.text = model.RE_name;
//        }
        
        self.reseveTimeLabel.text = [NSString stringWithFormat:@"警号：%@",_sendAlarm];
        self.reseveTextlabel.text = [NSString stringWithFormat:@"单位：%@",model.RE_post];
    }
}

- (void)bgViewTap:(UITapGestureRecognizer*)recognizer
{
    [self userViewDiss];
}


#pragma mark  -------点人头像

- (UIView *)BgView
{
    if (!_BgView) {
        _BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , screenWidth(), screenHeight())];
        _BgView.backgroundColor = zClearColor;
        _BgView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
        [_BgView addGestureRecognizer:tap];
    }
    return _BgView;
}

- (void)createThreeImageViewAndTitleAndButton
{
    for (int i = 0; i<3; i++) {
        UIImageView * bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth()/6-10+screenWidth()/3*i,self.reseveBgView.height-45, 20, 20)];
        bottomImageView.image = [UIImage imageNamed:self.reseveImageArr[i]];
        [self.reseveBgView addSubview:bottomImageView];
        
        UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth()/3*i, self.reseveBgView.height-20, screenWidth()/3, 15)];
        bottomLabel.text = self.reseveTitleArr[i];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont systemFontOfSize:12.0];
        bottomLabel.textColor = zBlueColor;
        if (i==2) {
            bottomLabel.textColor = zGrayColor;
        }
        [self.reseveBgView addSubview:bottomLabel];
        
        UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.frame = CGRectMake(screenWidth()/3*i, self.reseveBgView.height-50, screenWidth()/3, 50);
        bottomBtn.backgroundColor = zClearColor;
        bottomBtn.tag = i+50000;
        bottomBtn.enabled = YES;
        [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.reseveBgView addSubview:bottomBtn];
    }
}
//下方三个按钮点击
- (void)bottomBtnClick:(UIButton*)btn
{
//    if (self.block) {
//        self.block((int)btn.tag - 60000);
//    }
    if (btn.tag - 50000 == 0) {
    
        NSDictionary *userDict =[[NSDictionary alloc] initWithObjectsAndKeys:_userAlarm,@"userAlarm", nil];
          [LYRouter openURL:@"ly://dianhua" withUserInfo:userDict completion:nil];
    }
    else  if (btn.tag - 50000 == 1)
    {
          [LYRouter openURL:@"ly://daohangl" withUserInfo:nil completion:nil];
    }
    else
    {
        
    }
}

- (UIView *)reseveBgView
{
    if (!_reseveBgView) {
        _reseveBgView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight()-125 , screenWidth(), 125)];
        _reseveBgView.backgroundColor = zWhiteColor;
        _reseveBgView.hidden = YES;
    }
    return _reseveBgView;
}
- (UILabel*)reseveTextlabel
{
    if (!_reseveTextlabel) {
        _reseveTextlabel = [[UILabel alloc]initWithFrame:CGRectMake(74, 40, screenWidth()-84-12, 20)];
        _reseveTextlabel.text = @"单位：";
        _reseveTextlabel.textColor = zGrayColor;
        _reseveTextlabel.font = [UIFont systemFontOfSize:13.0];
        _reseveTextlabel.textAlignment = NSTextAlignmentLeft;
        _reseveTextlabel.numberOfLines = 0;
    }
    return _reseveTextlabel;
}

- (UIImageView*)reseveIconImageView
{
    if (!_reseveIconImageView) {
        _reseveIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 50, 50)];
        _reseveIconImageView.layer.masksToBounds = YES;
        _reseveIconImageView.layer.cornerRadius = 6;
    }
    return _reseveIconImageView;
}
- (UILabel*)reseveNameLabel
{
    if (!_reseveNameLabel) {
        _reseveNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(74, 15, 60, 20)];
        _reseveNameLabel.textColor  = zBlackColor;
        _reseveNameLabel.textAlignment = NSTextAlignmentLeft;
        _reseveNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _reseveNameLabel;
}

- (UILabel*)reseveTimeLabel
{
    if (!_reseveTimeLabel) {
        CGFloat width = [LZXHelper textWidthFromTextString:@" 警号：002585 " height:20 fontSize:16.0];
        
        _reseveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth()/2, 15, width, 20)];
        _reseveTimeLabel.textColor = zBlackColor;
        _reseveTimeLabel.font = [UIFont systemFontOfSize:16.0];
        _reseveTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _reseveTimeLabel;
}
- (NSArray*)reseveImageArr
{
    if (!_reseveImageArr) {
        _reseveImageArr = [NSArray arrayWithObjects:@"callhelpphonr",@"callHelpdh",@"CallgrayAdd", nil];
    }
    return _reseveImageArr;
}

- (NSArray*)reseveTitleArr
{
    if (!_reseveTitleArr) {
        _reseveTitleArr = [NSArray arrayWithObjects:@"电话",@"导航",@"好友", nil];
    }
    return _reseveTitleArr;
}

- (void)userViewShow:(NSString*)alarm
{
    if ([alarm isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"alarm"]]) {
        [LYRouter openURL:@"ly://selectOwn" withUserInfo:nil completion:nil];
    }
    else
    {
        self.BgView.hidden = NO;
        self.reseveBgView.hidden = NO;
        
        UserAllModel * model = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:alarm];
        
        _userAlarm = model.RE_alarmNum;
        
        [self.reseveIconImageView imageGetCacheForAlarm:alarm forUrl:@"111"];
        
        NSString *alarmOwn = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        if ([alarm isEqualToString:alarmOwn]) {
            UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
            self.reseveNameLabel.text = model.name;
        }else {
            self.reseveNameLabel.text = model.RE_name;
        }
        
//        if ([model.RE_name isEqualToString:@"文件助手"]||[model.RE_name isEqualToString:@"文件小助手"]) {
//            UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
//            self.reseveNameLabel.text = model.name;
//        }
//        else
//        {
//            self.reseveNameLabel.text = model.RE_name;
//        }
        
        self.reseveTimeLabel.text = [NSString stringWithFormat:@"警号：%@",alarm];
        self.reseveTextlabel.text = [NSString stringWithFormat:@"单位：%@",model.RE_post];
    }
}

- (void)userViewDiss
{
    self.BgView.hidden = YES;
    self.reseveBgView.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
