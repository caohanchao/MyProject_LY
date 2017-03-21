//
//  CircleOfBattleController.m
//  ProjectTemplate
//
//  Created by 戴小斌 on 2016/10/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CircleOfBattleController.h"
#import "DXBBaseTableViewController.h"
#import "SquareViewController.h"
#import "FollowViewController.h"
#import "PrivacyViewController.h"
#import "CommualHeaderView.h"
#import "HMSegmentedControl.h"
#import "IssueDynamicViewController.h"
#import "UserHomePageViewController.h"

@interface CircleOfBattleController ()<TableViewScrollingProtocol> {
    BOOL _stausBarColorIsBlack;
}

@property (nonatomic, weak) UIView *navView;
@property (nonatomic, strong) HMSegmentedControl *segCtrl;
@property (nonatomic, strong) CommualHeaderView *headerView;

@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIActivityIndicatorView *aiv;



@end

@implementation CircleOfBattleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleList = @[@"", @"", @""];
    
    self.title = @"战友圈";
    [self configNav];
    [self addController];
    [self addHeaderView];
    [self segmentedControlChangedValue:_segCtrl];
    [self createRightIssueBtn];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavTitleView) name:CricleTitleViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNavTitleView) name:CricleTitleDisViewNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DismissPostNotification object:nil];
}

- (void)setNavTitleView
{
    self.navigationItem.titleView = self.titleView;
}

- (void)dismissNavTitleView
{
    [_aiv stopAnimating];
    self.navigationItem.titleView = nil;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self.aiv removeFromSuperview];
    self.aiv = nil;
    self.title = @"战友圈";
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 0, 100, 30);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
        lbl.text = @"战友圈";
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

-(void)createRightIssueBtn
{
    UIButton * cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame =  CGRectMake(0, 0, 30, 35);
    [cameraBtn setImage:[UIImage imageNamed:@"criclecamera"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
     self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle
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
    titleLabel.text = @"战友圈";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    navView.alpha = 0;
    [self.view addSubview:navView];
    
    _navView = navView;
}

- (void)addController {
    SquareViewController *vc1 = [[SquareViewController alloc] init];
    vc1.delegate = self;
    FollowViewController *vc2 = [[FollowViewController alloc] init];
    vc2.delegate = self;
    PrivacyViewController *vc3 = [[PrivacyViewController alloc] init];
    vc3.delegate = self;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
}

- (void)addHeaderView {
    CommualHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommualHeaderView" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headerImgHeight+switchBarHeight);
    self.headerView = headerView;
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100, screenWidth(), headerImgHeight+140)];
    bgImgView.image = [UIImage imageNamed:@"cricleBgView"];
    [headerView addSubview:bgImgView];

    UIImageView * iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-60/2, headerImgHeight-50-60, 60, 60)];
    [iconImgView imageGetCacheForAlarm:alarm forUrl:@"applogo"];
    iconImgView.layer.borderWidth = 1;
    iconImgView.layer.borderColor = [zWhiteColor CGColor];
    iconImgView.layer.masksToBounds = YES;
//    iconImgView.layer.cornerRadius = 60/2;
    iconImgView.layer.cornerRadius = 6;
    [headerView addSubview:iconImgView];
    
    UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = iconImgView.frame;
    iconBtn.layer.masksToBounds = YES;
//    iconBtn.layer.cornerRadius = 30;
    iconBtn.layer.cornerRadius = 6;
    [iconBtn addTarget:self action:@selector(ownIconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:iconBtn];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, headerImgHeight, screenWidth(), 40)];
    bgView.backgroundColor = CHCHexColor(@"000000");
    bgView.alpha = 0.05;
    [headerView addSubview:bgView];
    
    UIView * allbgView = [[UIView alloc]initWithFrame:CGRectMake(0, headerImgHeight, screenWidth()/3, 40)];
    allbgView.backgroundColor = CHCHexColor(@"000000");
    allbgView.alpha = 0.1;
    [headerView addSubview:allbgView];
    
    UIView * followbgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3, headerImgHeight, screenWidth()/3, 40)];
    followbgView.backgroundColor = CHCHexColor(@"000000");
    followbgView.alpha = 0.05;
    [headerView addSubview:followbgView];
    
    UIView * privacybgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, headerImgHeight, screenWidth()/3, 40)];
    privacybgView.backgroundColor = CHCHexColor(@"000000");
    privacybgView.alpha = 0.05;
    [headerView addSubview:privacybgView];
    
    UILabel * allLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImgHeight, kScreenWidth/3, 40)];
    allLabel.textAlignment = NSTextAlignmentCenter;
    allLabel.font = [UIFont systemFontOfSize:16.0f];
    allLabel.textColor =CHCHexColor(@"ffffff");
    allLabel.text = @"广场";
    allLabel.backgroundColor = zClearColor;
    [headerView addSubview:allLabel];
    
    UILabel * followLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3, headerImgHeight, kScreenWidth/3, 40)];
    followLabel.textAlignment = NSTextAlignmentCenter;
    followLabel.font = [UIFont systemFontOfSize:16.0f];
    followLabel.textColor =CHCHexColor(@"2a5569");
    followLabel.text = @"关注";
    followLabel.backgroundColor = zClearColor;
    [headerView addSubview:followLabel];
    
    UILabel * privacyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, headerImgHeight, kScreenWidth/3, 40)];
    privacyLabel.textAlignment = NSTextAlignmentCenter;
    privacyLabel.font = [UIFont systemFontOfSize:16.0f];
    privacyLabel.textColor =CHCHexColor(@"2a5569");
    privacyLabel.text = @"私密";
    privacyLabel.backgroundColor = zClearColor;
    [headerView addSubview:privacyLabel];
    
    
    _segCtrl = [[HMSegmentedControl alloc]initWithSectionTitles:_titleList];
    _segCtrl.frame = CGRectMake(0, 200, screenWidth(), 40);
    _segCtrl.backgroundColor = zClearColor;
   // _segCtrl.selectionIndicatorHeight = 2.0f;
    _segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segCtrl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
   // _segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : CHCHexColor(@"2a5569"), NSFontAttributeName : [UIFont systemFontOfSize:15]};
   // _segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : CHCHexColor(@"ffffff")};
    //_segCtrl.selectionIndicatorColor = CHCHexColor(@"fea41a");
    _segCtrl.selectedSegmentIndex = 0;
    _segCtrl.borderType = HMSegmentedControlBorderTypeNone;
   // _segCtrl.borderColor = [UIColor lightGrayColor];
    [headerView addSubview:_segCtrl];
    
    CircleOfBattleController  __weak * weakSelf = self;
    _segCtrl.indexChangeBlock = ^(NSInteger index) {
        
        if (index == 0)
        {
            allLabel.textColor = CHCHexColor(@"ffffff");
            followLabel.textColor = CHCHexColor(@"2a5569");
            privacyLabel.textColor = CHCHexColor(@"2a5569");
//            allLabel.backgroundColor = CHCHexColor(@"1894c5");
//            followLabel.backgroundColor = zClearColor;
//            privacyLabel.backgroundColor = zClearColor;
            allbgView.alpha = 0.1;
            followbgView.alpha = 0.05;
            privacybgView.alpha = 0.05;
        }
        else if (index == 1)
        {
            allLabel.textColor = CHCHexColor(@"2a5569");
            followLabel.textColor = CHCHexColor(@"ffffff");
            privacyLabel.textColor = CHCHexColor(@"2a5569");
//            allLabel.backgroundColor = zClearColor;
//            followLabel.backgroundColor = CHCHexColor(@"1894c5");
//            privacyLabel.backgroundColor = zClearColor;
            allbgView.alpha = 0.05;
            followbgView.alpha = 0.1;
            privacybgView.alpha = 0.05;
        }
        else if (index == 2)
        {
            allLabel.textColor = CHCHexColor(@"2a5569");
            followLabel.textColor = CHCHexColor(@"2a5569");
            privacyLabel.textColor = CHCHexColor(@"ffffff");
//            allLabel.backgroundColor = zClearColor;
//            followLabel.backgroundColor = zClearColor;
//            privacyLabel.backgroundColor = CHCHexColor(@"1894c5");
            allbgView.alpha = 0.05;
            followbgView.alpha = 0.05;
            privacybgView.alpha = 0.1;
        }
        else
        {
        }
    };
    
    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    [_showingVC.view removeFromSuperview];
    
    DXBBaseTableViewController *newVC = self.childViewControllers[sender.selectedSegmentIndex];
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

#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (DXBBaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

//点击自己头像
-(void)ownIconBtnClick
{
    UserHomePageViewController * userHomePageVC = [[UserHomePageViewController alloc]init];
    userHomePageVC.userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    userHomePageVC.selectIDStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    [self.navigationController pushViewController:userHomePageVC animated:YES];
}

//点击相机发布
-(void)cameraBtnClick
{
    IssueDynamicViewController * issueVC = [[IssueDynamicViewController alloc]init];
    [self.navigationController pushViewController:issueVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
