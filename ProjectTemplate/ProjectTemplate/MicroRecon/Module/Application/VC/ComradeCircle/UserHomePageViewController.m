//
//  UserHomePageViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserHomePageViewController.h"
#import "UserHeaderView.h"
#import "HMSegmentedControl.h"
#import "UserPostViewController.h"
#import "UserHonourViewController.h"
#import "UserAttentionViewController.h"
#import "UserFansViewController.h"
#import "UserCardModel.h"
#import "CardCountInfoModel.h"
#import "HomePageListModel.h"

@interface UserHomePageViewController ()<TableViewScrollingProtocol> {
    BOOL _stausBarColorIsBlack;
}

@property (nonatomic, weak) UIView *navView;
@property (nonatomic, strong) HMSegmentedControl *segCtrl;
@property (nonatomic, strong) UserHeaderView *headerView;

@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量

@property (nonatomic, strong) UIButton * addAtBtn;
@property (nonatomic, strong) UILabel * fromLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * iconImgView;

@property(nonatomic, strong) UserCardModel * userCardModel;
@property(nonatomic, strong) CardCountInfoModel * cardCountModel;

@property (nonatomic, strong) UILabel * postNumLabel;
@property (nonatomic, strong) UILabel * honourNumLabel;
@property (nonatomic, strong) UILabel * attentNumLabel;
@property (nonatomic, strong) UILabel * fansNumLabel;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIActivityIndicatorView *aiv;

@end

@implementation UserHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人主页";
    
   // _titleList = @[@"", @"", @"", @""];
    _titleList = @[@""];
    
    [self configNav];
    [self addController];
    [self addHeaderView];
    [self segmentedControlChangedValue:_segCtrl];
    
    [self getHomePageResultsData];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavTitleView) name:HomeTitleViewNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNavTitleView) name:HomeTitleDisViewNotification object:nil];
}

- (void)setNavTitleView
{
    self.navigationItem.titleView = self.titleView;
    [self getHomePageResultsData];
}

- (void)dismissNavTitleView
{
    [_aiv stopAnimating];
    self.navigationItem.titleView = nil;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self.aiv removeFromSuperview];
    self.aiv = nil;
    self.title = @"个人主页";
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 0, 100, 30);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
        lbl.text = @"个人主页";
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont boldSystemFontOfSize:17.f];
        [_titleView addSubview:lbl];
        _aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(minX(lbl)-15, minY(lbl)+7.5, 20, 20)];//指定进度轮的大小
        // [aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
        CGAffineTransform transform = CGAffineTransformMakeScale(.7f, .7f);
        _aiv.transform = transform;
        [_aiv startAnimating];
        [_titleView addSubview:_aiv];
    }
    
    return _titleView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    if ([self.userIDStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]]) {
        [self getHomePageResultsData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavTitleView) name:HomeTitleViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNavTitleView) name:HomeTitleDisViewNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _stausBarColorIsBlack ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    if (offsetY > headerImgHeight - topBarHeight) {
        if (![_headerView.superview isEqual:self.view]) {
            [self.view insertSubview:_headerView belowSubview:_navView];
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    } else {
        if (![_headerView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headerView belowSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    }
    
    
    if (offsetY>0) {
        CGFloat alpha = offsetY/136;
        self.navView.alpha = alpha;
        
        if (alpha > 0.6 && !_stausBarColorIsBlack) {
            // self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            _stausBarColorIsBlack = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else if (alpha <= 0.6 && _stausBarColorIsBlack) {
            // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            _stausBarColorIsBlack = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } else {
        self.navView.alpha = 0;
        //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _stausBarColorIsBlack = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO;  这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO; 这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY <= headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = NO;
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
    _headerView.userInteractionEnabled = NO;
}

#pragma mark - Private
- (void)configNav {
    // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = zNavColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, 20)];
    titleLabel.text = @"个人主页";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    navView.alpha = 0;
    [self.view addSubview:navView];
    
    _navView = navView;
}

- (void)addController {
    UserPostViewController *vc1 = [[UserPostViewController alloc] init];
    vc1.delegate = self;
    vc1.userIDStr = self.userIDStr;
    vc1.selectIDStr = self.selectIDStr;
//    UserHonourViewController *vc2 = [[UserHonourViewController alloc] init];
//    vc2.delegate = self;
//    vc2.userIDStr = self.userIDStr;
//    vc2.selectIDStr = self.selectIDStr;
//    UserAttentionViewController *vc3 = [[UserAttentionViewController alloc] init];
//    vc3.delegate = self;
//    vc3.userIDStr = self.userIDStr;
//    vc3.selectIDStr = self.selectIDStr;
//    UserFansViewController *vc4 = [[UserFansViewController alloc] init];
//    vc4.delegate = self;
//    vc4.userIDStr = self.userIDStr;
//    vc4.selectIDStr = self.selectIDStr;
    [self addChildViewController:vc1];
//    [self addChildViewController:vc2];
//    [self addChildViewController:vc3];
//    [self addChildViewController:vc4];
}

- (void)addHeaderView {
    UserHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headerImgHeight+switchBarHeight+12);
    self.headerView = headerView;
  //  self.segCtrl = headerView.segCtrl;
    
 //   NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, screenWidth(), headerImgHeight+200)];
    bgImgView.image = [UIImage imageNamed:@"cricleBgView"];
    [headerView addSubview:bgImgView];
    
    _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-60/2, headerImgHeight-85-60, 60, 60)];
    _iconImgView.layer.masksToBounds = YES;
//    _iconImgView.layer.cornerRadius = 60/2;
     _iconImgView.layer.cornerRadius = 6;
    _iconImgView.layer.borderWidth = 1;
    _iconImgView.layer.borderColor = [zWhiteColor CGColor];
    [headerView addSubview:_iconImgView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, maxY(_iconImgView)+15, kScreenWidth - 24, 20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor =CHCHexColor(@"ffffff");
    [headerView addSubview:_nameLabel];
    
    _fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, maxY(_nameLabel)+11, kScreenWidth - 24, 15)];
    _fromLabel.textAlignment = NSTextAlignmentCenter;
    _fromLabel.font = [UIFont systemFontOfSize:13.0f];
    _fromLabel.textColor =CHCHexColor(@"ffffff");
    [headerView addSubview:_fromLabel];
    
    _addAtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addAtBtn.frame =CGRectMake(maxX(_iconImgView)+30, _iconImgView.center.y-10, 60, 20);
    [_addAtBtn addTarget:self action:@selector(attBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_addAtBtn setTitleFont:UIFontWeightBold size:11.0];
    [headerView addSubview:_addAtBtn];
    
    UILabel * postLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImgHeight, kScreenWidth/4+1, 30)];
    postLabel.textAlignment = NSTextAlignmentCenter;
    postLabel.font = [UIFont systemFontOfSize:14.0f];
    postLabel.textColor =CHCHexColor(@"000000");
    postLabel.text = @"动态";
    postLabel.backgroundColor = CHCHexColor(@"ffffff");
    [headerView addSubview:postLabel];
    
    UILabel * honourLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4, headerImgHeight, kScreenWidth/4+1, 30)];
    honourLabel.textAlignment = NSTextAlignmentCenter;
    honourLabel.font = [UIFont systemFontOfSize:14.0f];
    honourLabel.textColor =CHCHexColor(@"000000");
    honourLabel.text = @"荣誉";
    honourLabel.backgroundColor = CHCHexColor(@"ffffff");
    [headerView addSubview:honourLabel];
    
    UILabel * followLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, headerImgHeight, kScreenWidth/4+1, 30)];
    followLabel.textAlignment = NSTextAlignmentCenter;
    followLabel.font = [UIFont systemFontOfSize:14.0f];
    followLabel.textColor =CHCHexColor(@"000000");
    followLabel.text = @"关注";
    followLabel.backgroundColor = CHCHexColor(@"ffffff");
    [headerView addSubview:followLabel];
    
    UILabel * fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4*3, headerImgHeight, kScreenWidth/4+1, 30)];
    fansLabel.textAlignment = NSTextAlignmentCenter;
    fansLabel.font = [UIFont systemFontOfSize:14.0f];
    fansLabel.textColor =CHCHexColor(@"000000");
    fansLabel.text = @"粉丝";
    fansLabel.backgroundColor = CHCHexColor(@"ffffff");
    [headerView addSubview:fansLabel];
    
    _postNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImgHeight+switchBarHeight-20, kScreenWidth/4+1, 20)];
    _postNumLabel.textAlignment = NSTextAlignmentCenter;
    _postNumLabel.font = [UIFont systemFontOfSize:12.0f];
    _postNumLabel.textColor =CHCHexColor(@"000000");
    _postNumLabel.backgroundColor =CHCHexColor(@"ffffff");
    [headerView addSubview:_postNumLabel];
    
    _honourNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4, headerImgHeight+switchBarHeight-20, kScreenWidth/4+1, 20)];
    _honourNumLabel.textAlignment = NSTextAlignmentCenter;
    _honourNumLabel.font = [UIFont systemFontOfSize:12.0f];
    _honourNumLabel.textColor =CHCHexColor(@"000000");
    _honourNumLabel.backgroundColor =CHCHexColor(@"ffffff");
    [headerView addSubview:_honourNumLabel];
    
    _attentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, headerImgHeight+switchBarHeight-20, kScreenWidth/4+1, 20)];
    _attentNumLabel.textAlignment = NSTextAlignmentCenter;
    _attentNumLabel.font = [UIFont systemFontOfSize:12.0f];
    _attentNumLabel.textColor =CHCHexColor(@"000000");
    _attentNumLabel.backgroundColor =CHCHexColor(@"ffffff");
    [headerView addSubview:_attentNumLabel];
    
    _fansNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4*3, headerImgHeight+switchBarHeight-20, kScreenWidth/4+1, 20)];
    _fansNumLabel.textAlignment = NSTextAlignmentCenter;
    _fansNumLabel.font = [UIFont systemFontOfSize:12.0f];
    _fansNumLabel.textColor =CHCHexColor(@"000000");
    _fansNumLabel.backgroundColor =CHCHexColor(@"ffffff");
    [headerView addSubview:_fansNumLabel];
    
    _segCtrl = [[HMSegmentedControl alloc]initWithSectionTitles:_titleList];
    _segCtrl.frame = CGRectMake(0, 443/2, screenWidth(), 45);
    _segCtrl.backgroundColor = zClearColor;
  //   _segCtrl.selectionIndicatorHeight = 2.0f;
    _segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segCtrl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    // _segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : CHCHexColor(@"2a5569"), NSFontAttributeName : [UIFont systemFontOfSize:15]};
    // _segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : CHCHexColor(@"ffffff")};
  //  _segCtrl.selectionIndicatorColor = CHCHexColor(@"12b7f5");
    _segCtrl.selectedSegmentIndex = 0;
    _segCtrl.borderType = HMSegmentedControlBorderTypeNone;
    //_segCtrl.borderColor = [UIColor lightGrayColor];
    [headerView addSubview:_segCtrl];
    
    
    for (int i =0; i<4; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth()/4*i, headerImgHeight, screenWidth()/4, switchBarHeight)];
        btn.backgroundColor = zClearColor;
        btn.tag = 10000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    
    
//    UserHomePageViewController  __weak * weakSelf = self;
    
    _segCtrl.indexChangeBlock = ^(NSInteger index) {
    
        if (index == 0)
        {
//            weakSelf.postNumLabel.textColor = CHCHexColor(@"12b7f5");
//            weakSelf.honourNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.attentNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.fansNumLabel.textColor = CHCHexColor(@"000000");
//            postLabel.textColor = CHCHexColor(@"12b7f5");
//            honourLabel.textColor = CHCHexColor(@"000000");
//            followLabel.textColor = CHCHexColor(@"000000");
//            fansLabel.textColor = CHCHexColor(@"000000");
        }
        else if (index == 1)
        {
//            weakSelf.postNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.honourNumLabel.textColor = CHCHexColor(@"12b7f5");
//            weakSelf.attentNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.fansNumLabel.textColor = CHCHexColor(@"000000");
//            postLabel.textColor = CHCHexColor(@"000000");
//            honourLabel.textColor = CHCHexColor(@"12b7f5");
//            followLabel.textColor = CHCHexColor(@"000000");
//            fansLabel.textColor = CHCHexColor(@"000000");
        }
        else if (index == 2)
        {
//            weakSelf.postNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.honourNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.attentNumLabel.textColor = CHCHexColor(@"12b7f5");
//            weakSelf.fansNumLabel.textColor = CHCHexColor(@"000000");
//            postLabel.textColor = CHCHexColor(@"000000");
//            honourLabel.textColor = CHCHexColor(@"000000");
//            followLabel.textColor = CHCHexColor(@"12b7f5");
//            fansLabel.textColor = CHCHexColor(@"000000");
           
        }
        else if (index == 3)
        {
//            weakSelf.postNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.honourNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.attentNumLabel.textColor = CHCHexColor(@"000000");
//            weakSelf.fansNumLabel.textColor = CHCHexColor(@"12b7f5");
//            postLabel.textColor = CHCHexColor(@"000000");
//            honourLabel.textColor = CHCHexColor(@"000000");
//            followLabel.textColor = CHCHexColor(@"000000");
//            fansLabel.textColor = CHCHexColor(@"12b7f5");
           
        }
        else
        {
        }
    };
    
 //   [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    [_showingVC.view removeFromSuperview];
    
    UserBaseTableViewController *newVC = self.childViewControllers[sender.selectedSegmentIndex];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = self.view.bounds;
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    [self.view insertSubview:newVC.view belowSubview:self.navView];
    if (offsetY <= headerImgHeight - topBarHeight) {
        [newVC.view addSubview:_headerView];
        for (UIView *view in newVC.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [newVC.view insertSubview:_headerView belowSubview:view];
                break;
            }
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    }  else {
        [self.view insertSubview:_headerView belowSubview:_navView];
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    }
    _showingVC = newVC;
}

- (void)btnClick:(UIButton*)btn
{
    if (btn.tag - 10000 == 0)
    {
       [[NSNotificationCenter defaultCenter]postNotificationName:UserCardPostToTopNotification object:nil];
    }
    else if (btn.tag - 10000 == 1)
    {
        
    }
    else if (btn.tag - 10000 == 2)
    {
        UserAttentionViewController *attentionVC = [[UserAttentionViewController alloc] init];
        attentionVC.userIDStr = self.userIDStr;
        attentionVC.selectIDStr = self.selectIDStr;
        [self.navigationController pushViewController:attentionVC animated:YES];
    }
    else
    {
        UserFansViewController *fansVC = [[UserFansViewController alloc] init];
        fansVC.userIDStr = self.userIDStr;
        fansVC.selectIDStr = self.selectIDStr;
        [self.navigationController pushViewController:fansVC animated:YES];
    }
}

#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (UserBaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

//添加/取消关注
-(void)attBtnClick
{
    NSString * str;
    if ([_userCardModel.isfocus integerValue] == 1)
    {
        str = @"delfocus";
    }
    else
    {
        str = @"setfocus";
    }
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = str;
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"focusalarm"] = self.userIDStr;
    paramDict[@"mode"] = @"1";
    
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response
                                                             options:NSJSONReadingMutableContainers error:nil];
        
        if ([dict[@"resultcode"] isEqualToString:@"0"])
        {
            if ([_userCardModel.isfocus integerValue] == 1)
            {
                [_addAtBtn setBackgroundImage:[UIImage imageNamed:@"cricleattention"] forState:UIControlStateNormal];
                [_addAtBtn setTitle:@"关注" forState:UIControlStateNormal];
                [_addAtBtn setTitleEdgeInsets:UIEdgeInsetsMake(6, 21, 0, 0)];
                [_addAtBtn setTitleColor:zBlueColor];
                _userCardModel.isfocus =  [NSNumber numberWithInt:0];
                
                [[[DBManager sharedManager]userFollowSQ]deleteUserFollowWithUserAlarm:self.userIDStr withAlarm:alarm];
                [[[DBManager sharedManager]userFansSQ]deleteUserFansWithUserAlarm:self.userIDStr withAlarm:alarm];
                
                CardCountInfoModel * countModel = [[CardCountInfoModel alloc]init];
                
                countModel.fansNum = [NSString stringWithFormat:@"%d",[_cardCountModel.fansNum intValue]-1];
                
                CardCountInfoModel * owncountModel = [[CardCountInfoModel alloc]init];
                
                owncountModel.focusNum = [NSString stringWithFormat:@"%d",[_cardCountModel.focusNum intValue]-1];
                
                [[[DBManager sharedManager]userCountInfoSQ]updataUsrCount:countModel withUserAlarm:self.userIDStr];
                [[[DBManager sharedManager]userCountInfoSQ]updataUsrCount:owncountModel withUserAlarm:alarm];
                
                [self userCountUpde];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:UserFollowNotification object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:UserFansNotification object:nil];
                
                [self showHint:@"取消关注成功"];
            }
            else
            {
                [_addAtBtn setBackgroundImage:[UIImage imageNamed:@"cricleattented"] forState:UIControlStateNormal];
                [_addAtBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_addAtBtn setTitleEdgeInsets:UIEdgeInsetsMake(6, 21, 0, 0)];
                [_addAtBtn setTitleColor:zWhiteColor];
                _userCardModel.isfocus =  [NSNumber numberWithInt:1];
                
                HomePageListModel *hmUserModel = [[HomePageListModel alloc]init];
                
                UserInfoModel * userInfoModel = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
                
                //获取当前时间并转为时间戳
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[date timeIntervalSince1970];
                NSString *timeString = [NSString stringWithFormat:@"%f", a];
                NSString * string = [timeString substringToIndex:10];
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *numTemp = [numberFormatter numberFromString:string];
                
                hmUserModel.alarm = alarm;
                hmUserModel.department = userInfoModel.department;
                hmUserModel.headpic = userInfoModel.headpic;
                hmUserModel.name = userInfoModel.name;
                hmUserModel.time = numTemp ;
                
                
                HomePageListModel *userModel = [[HomePageListModel alloc]init];
                
                userModel.alarm = self.userIDStr;
                userModel.department = _userCardModel.department;
                userModel.headpic = _userCardModel.headpic;
                userModel.name = _userCardModel.name;
                userModel.time = numTemp ;
                
                CardCountInfoModel * countModel = [[CardCountInfoModel alloc]init];
                
                countModel.fansNum = [NSString stringWithFormat:@"%d",[_cardCountModel.fansNum intValue]+1];
                
                CardCountInfoModel * owncountModel = [[CardCountInfoModel alloc]init];
                
                owncountModel.focusNum = [NSString stringWithFormat:@"%d",[_cardCountModel.focusNum intValue]+1];
                [[[DBManager sharedManager]userCountInfoSQ]updataUsrCount:owncountModel withUserAlarm:alarm];
                
                [[[DBManager sharedManager]userFollowSQ]insertUserFollow:userModel withUserAlarm:alarm];
                
                [[[DBManager sharedManager]userFansSQ]insertUserFans:hmUserModel withUserAlarm:self.userIDStr];
                
                [[[DBManager sharedManager]userCountInfoSQ]updataUsrCount:countModel withUserAlarm:self.userIDStr];
                
                [self userCountUpde];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:UserFollowNotification object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:UserFansNotification object:nil];
                
                [self showHint:@"关注成功"];
            }
        }
        else
        {
             if ([_userCardModel.isfocus integerValue] == 1)
             {
                 [self showHint:@"取消关注失败"];
             }
            else
            {
                [self showHint:@"关注失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {;
    }];
}

- (void)getHomePageResultsData
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"getusercard";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"userid"] = self.userIDStr;
    paramDict[@"mode"] = @"1";
    
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        _userCardModel = [UserCardModel getInfoWithData:response];
        
        _cardCountModel = [CardCountInfoModel getInfoWithData:_userCardModel.countInfo];

        [[[DBManager sharedManager]userPostInfoSQ]transactionInsertUserPostInfoModel:_userCardModel.postInfo];
        
        [[[DBManager sharedManager]userCountInfoSQ]insertUserCount:_cardCountModel withUserAlarm:self.userIDStr];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:UserCardPostNotification object:nil];
        
        [self setHeadViewUserInfo];
        
        [self performSelector:@selector(dismissNavTitleView) withObject:nil afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSArray * array = [[[DBManager sharedManager]userCountInfoSQ]selectUserCountWithUserAlarm:self.userIDStr];
        if (array.count>0)
        {
            _cardCountModel = array[0];
            
            [self setHeadViewUserInfo];
        }
        [self dismissNavTitleView];
    }];
}

//数据请求后设置信息
- (void)setHeadViewUserInfo
{
    UserInfoModel *uModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
     if (![[LZXHelper isNullToString:_userCardModel.name] isEqualToString:@""])
     {
          _nameLabel.text = _userCardModel.name;
     }
    else
    {
         _nameLabel.text = uModel.name;
    }
    
   
    if (![[LZXHelper isNullToString:_userCardModel.department] isEqualToString:@""]) {
        _fromLabel.text = [NSString stringWithFormat:@"单位：%@",_userCardModel.department];
    }
    else
    {
        _fromLabel.text = [NSString stringWithFormat:@"单位：%@",uModel.department];
    }
  //  [_iconImgView imageGetCacheForAlarm:self.userIDStr forUrl:@"applogo"];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_userCardModel.headpic]];
    
    NSString * string = [NSString stringWithFormat:@"%@",_userCardModel.honorNum];
    if (![[LZXHelper isNullToString:string] isEqualToString:@""])
    {
        _honourNumLabel.text = string;
    }
    else{
        _honourNumLabel.text = @"0";
    }
    
    if (![[LZXHelper isNullToString:_cardCountModel.publicNum] isEqualToString:@""])
    {
        if ([_cardCountModel.publicNum integerValue]<0) {
            _postNumLabel.text = @"0";
        }
        else
        {
            _postNumLabel.text = _cardCountModel.publicNum;
        }
    }
    else
    {
        _postNumLabel.text = @"0";
    }
    
    if (![[LZXHelper isNullToString:_cardCountModel.fansNum] isEqualToString:@""])
    {
        if ([_cardCountModel.fansNum integerValue]<0) {
            _fansNumLabel.text = @"0";
        }
        else
        {
             _fansNumLabel.text = _cardCountModel.fansNum;
        }
       
    }
    else
    {
        _fansNumLabel.text = @"0";
    }
    
    if (![[LZXHelper isNullToString:_cardCountModel.focusNum] isEqualToString:@""])
    {
        _attentNumLabel.text = _cardCountModel.focusNum;
    }
    else
    {
        _attentNumLabel.text = @"0";
    }
    
    if ([self.userIDStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]])
    {
        _addAtBtn.hidden = YES;
    }
    else
    {
        if ([_userCardModel.isfocus integerValue] == 1)
        {
            [_addAtBtn setBackgroundImage:[UIImage imageNamed:@"cricleattented"] forState:UIControlStateNormal];
            [_addAtBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_addAtBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 21, 0, 0)];
            [_addAtBtn setTitleColor:zWhiteColor];
        }
        else
        {
            [_addAtBtn setBackgroundImage:[UIImage imageNamed:@"cricleattention"] forState:UIControlStateNormal];
            [_addAtBtn setTitle:@"关注" forState:UIControlStateNormal];
            [_addAtBtn setTitleEdgeInsets:UIEdgeInsetsMake(6, 21, 0, 0)];
            [_addAtBtn setTitleColor:zBlueColor];
        }
    }
    
}

- (void)userCountUpde
{
    NSArray * array = [[[DBManager sharedManager]userCountInfoSQ]selectUserCountWithUserAlarm:self.userIDStr];
    if (array.count>0)
    {
        _cardCountModel = array[0];
    }
    
     if (![[LZXHelper isNullToString:_cardCountModel.fansNum] isEqualToString:@""])
    {
        if ([_cardCountModel.fansNum integerValue]<0) {
             _fansNumLabel.text = @"0";
        }
        else
        {
            _fansNumLabel.text = _cardCountModel.fansNum;
        }
    }
    else
    {
        _fansNumLabel.text = @"0";
    }

}


////返回事件
//- (BOOL)navigationShouldPopOnBackButton
//{
//    
//    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    
//    return NO;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
