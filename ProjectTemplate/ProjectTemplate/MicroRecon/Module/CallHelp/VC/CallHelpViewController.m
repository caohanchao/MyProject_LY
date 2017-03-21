//
//  CallHelpViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpViewController.h"
#import "CallHelpMapManager.h"
#import <MAMapKit/MAMapKit.h>
#import "CallHelpAnnotationView.h"
#import "CallHelpAlertView.h"
#import "CallHelpTopView.h"
#import "CallHelpBottomView.h"
#import "UserAllModel.h"
#import "XMNChatController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CommonUtility.h"

@interface CallHelpViewController ()<MAMapViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, assign) BOOL isFirist;
@property (nonatomic, strong) CallHelpAnnotationView *annotationView;
@property (nonatomic, strong) CallHelpTopView *topView;
@property (nonatomic, strong) CallHelpBottomView *bottomView;
@property (nonatomic, strong) CallHelpAlertView *callHelpAlertView;

@property (nonatomic, assign) double  latitude;//纬度
@property (nonatomic, assign) double  longitude;//经度
@property (assign, nonatomic) BOOL isSendHelp;

@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) BOOL isNowView;

@property (strong, nonatomic)  UserAllModel * userModel;

@property (strong, nonatomic)  NSDictionary * userDic;

@property (copy, nonatomic) NSString *sendHelpId;
@property (copy, nonatomic) NSString *getGid;
@property (copy, nonatomic) NSString *getGName;
@property (strong, nonatomic) UIButton *rightButton;

@property (nonatomic, strong) UIButton *alertButton;
@property (nonatomic, strong) UILabel *alertLabel;

/// 用户位置经纬度。
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation CallHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    self.navigationItem.title = @"呼叫增援";
    self.isFirist = YES;
    [self initall];
}
- (void)initall {
    [self initRouter];
    [self initMap];
    [self addTopView];
    [self setUserLocation];
    [self rightBtn];
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.alertButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isNowView = YES;
    if (_isShow == YES) {
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isNowView = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)rightBtn
{
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 19, 19);
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"rec_normal_1"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _rightButton.hidden = YES;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

// 注册block路由
- (void)initRouter {
    
    WeakSelf
    //长按发起求助
    [LYRouter registerURLPattern:@"ly://CallHelpViewControllerLongPressCallHelp" toHandler:^(NSDictionary *routerParameters) {
        [weakSelf callHelpAlertViewShow];
        
    }];
    //收到求助信息
    [LYRouter registerURLPattern:@"ly://CallHelpReceiveHelp" toHandler:^(NSDictionary *routerParameters) {
        
        weakSelf.userDic = routerParameters[@"LYRouterParameterUserInfo"][@"receive"];
        weakSelf.getGid  = weakSelf.userDic[@"content"][@"MSG"][@"HELPDATA"][@"gid"];
        weakSelf.getGName = weakSelf.userDic[@"content"][@"SNAME"];
        
        weakSelf.userModel = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:weakSelf.userDic[@"content"][@"SID"]];
        
        weakSelf.bottomView.latitude = weakSelf.latitude;
        weakSelf.bottomView.longitude = weakSelf.longitude;
        
        if (!([[NSString stringWithFormat:@"%.0f",[self getDistanceWith:routerParameters[@"LYRouterParameterUserInfo"][@"receive"]]]integerValue]>5000))
        {
            if (_isSendHelp == NO) {
                
                _isShow = YES;
                
                if (_isNowView == YES) {
                    self.tabBarController.tabBar.hidden = YES;
                }
                else
                {
                    self.tabBarController.tabBar.hidden = NO;
                }
                
                [weakSelf.bottomView showWith:routerParameters[@"LYRouterParameterUserInfo"][@"receive"]];
                
            }
        }
    }];
    //发起者解除救援
    [LYRouter registerURLPattern:@"ly://CallHelpCancelHelp" toHandler:^(NSDictionary *routerParameters) {
        
        NSString * alarm = routerParameters[@"LYRouterParameterUserInfo"][@"userAlarm"];
        
        UserAllModel * model = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:alarm];
        
        if (![alarm isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]]) {
            weakSelf.alertButton.hidden = NO;
            weakSelf.alertLabel.hidden = NO;
            [weakSelf.alertButton setTitle:[NSString stringWithFormat:@"%@已取消呼叫增援，点击确定",model.RE_name] forState:UIControlStateNormal]; ;
        }
        
        if (![[LZXHelper isNullToString:_userModel.RE_alarmNum] isEqualToString:@""]) {
            if ([alarm isEqualToString:_userModel.RE_alarmNum])
            {
                [weakSelf.topView dissmiss];
                weakSelf.isSendHelp = NO;
                weakSelf.rightButton.hidden = YES;
            }
        }
        
    }];
    
    //有人退出救援
    [LYRouter registerURLPattern:@"ly://snedCallHelpCancelHelp" toHandler:^(NSDictionary *routerParameters) {

        [weakSelf userCancelBtnClick];
    }];
    //点击自己头像
    [LYRouter registerURLPattern:@"ly://selectOwn" toHandler:^(NSDictionary *routerParameters) {
        [weakSelf showHint:@"你点击了自己！"];
        
    }];
    
    
    //点击电话
    [LYRouter registerURLPattern:@"ly://dianhua" toHandler:^(NSDictionary *routerParameters) {
        NSString * alarm = routerParameters[@"LYRouterParameterUserInfo"][@"userAlarm"];
        [weakSelf callPhoneWith:alarm];
    }];
    
    //点击导航
    [LYRouter registerURLPattern:@"ly://daohangl" toHandler:^(NSDictionary *routerParameters) {
        //[weakSelf showHint:@"功能开发中..."];
        AMapNaviConfig * config = [[AMapNaviConfig alloc] init];
        config.destination    = self.coordinate;
        config.appScheme      = [CommonUtility getApplicationScheme];
        config.appName        = [CommonUtility getApplicationName];
        config.strategy       = AMapDrivingStrategyShortest;
        if(![AMapURLSearch openAMapNavigation:config])
        {
            [AMapURLSearch getLatestAMapApp]; 
        }
    }];
}
- (void)addTopView {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];

}
- (void)callHelpAlertViewShow {
    [self.callHelpAlertView show];
}
- (void)initMap {
    MAMapView *mapView = [CallHelpMapManager shareMAMapView];
    self.mapView = mapView;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    //设置地图类型
    self.mapView.mapType=MAMapTypeStandard;
    //设置定位精度
    self.mapView.desiredAccuracy = kCLLocationAccuracyBest;
//    //设置定位距离
//    self.mapView.distanceFilter = 1.0f;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    [self.mapView setZoomLevel:16.1 animated:YES];
    //后台定位
    self.mapView.pausesLocationUpdatesAutomatically = NO;
}
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    self.mapView.delegate = nil;
}
- (void)setUserLocation {
            [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateSelected];
    
    [self.mapView addSubview:self.locationButton ];
}
- (CallHelpTopView *)topView {
    if (!_topView) {
        _topView = [[CallHelpTopView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 0)];
    }
    return _topView;
}
- (CallHelpBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CallHelpBottomView alloc] initWithFrame:CGRectMake(0, screenHeight()-160, kScreenWidth, 0)];
        WeakSelf
        _bottomView.block =  ^(ButtonClickNum type) {
            if (type == ButtonClickPhone) {
                [weakSelf callPhoneWith:weakSelf.userDic[@"content"][@"SID"]];
                
            }else if (type == ButtonClickCancels)
            {
                [weakSelf callHelpCancel];
            }
            else if (type == ButtonClickSure)
            {
                [weakSelf callHelpSureHelp];
            }
        };
    }
    return _bottomView;
}

- (CallHelpAlertView *)callHelpAlertView {
    if (!_callHelpAlertView) {
        _callHelpAlertView = [[CallHelpAlertView alloc] init];
        WeakSelf
        [_callHelpAlertView click:^(ButtonClickType type) {
            if (type == ButtonClickConfirm) {
                
                [weakSelf sendHelpInfo];
                
            }else {
                [weakSelf.topView dissmiss];
            }
        }];
    }
    return _callHelpAlertView;
}
- (UIButton *)locationButton {
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton .frame = CGRectMake(10, CGRectGetHeight(_mapView.bounds) - 64-50, 50, 50);
        _locationButton .autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin;
        _locationButton .backgroundColor = [UIColor whiteColor];
        _locationButton .layer.cornerRadius = 25;
        [_locationButton  addTarget:self action:@selector(locateAction)
                   forControlEvents:UIControlEventTouchUpInside];
        [_locationButton  setImage:[UIImage imageNamed:@"nomalLocal"] forState:UIControlStateNormal];
        
    }
    return _locationButton;
}

- (UIButton*)alertButton
{
    if (!_alertButton) {
        CGFloat width = [LZXHelper textWidthFromTextString:@"某某某已取消呼叫增援，点击确定" height:40 fontSize:16];
        _alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _alertButton.frame = CGRectMake((screenWidth()-width-10)/2, 240, width+10, 40);
        _alertButton.backgroundColor = zClearColor;
       
        _alertButton.hidden = YES;
        _alertButton.layer.masksToBounds = YES;
        _alertButton.layer.cornerRadius = 10;
        [_alertButton setTitleColor:zWhiteColor forState:UIControlStateNormal];
        _alertButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_alertButton addTarget:self  action:@selector(alertHide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertButton;
}

- (UILabel*)alertLabel
{
    if (!_alertLabel) {
        
        CGFloat width = [LZXHelper textWidthFromTextString:@"某某某已取消呼叫增援，点击确定" height:40 fontSize:16];
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth()-width-10)/2, 240, width+10, 40)];
        _alertLabel.backgroundColor = zBlackColor;
        _alertLabel.textColor = zClearColor;
         _alertLabel.alpha = 0.5;
        _alertLabel.font = [UIFont systemFontOfSize:16];
        _alertLabel.hidden = YES;
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.layer.cornerRadius = 10;
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _alertLabel;
}

-(void)locateAction
{
    
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
    }
    else
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
        
    }
    
}
//监听定位模式状态的回调方法
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    
    if(mode == MAUserTrackingModeNone)
    {
        [_locationButton setImage:[UIImage imageNamed:@"nomalLocal"] forState:UIControlStateNormal];
    }
    else
    {
        [_locationButton setImage:[UIImage imageNamed:@"lightLocal"] forState:UIControlStateNormal];
    }
    
    
}
#pragma mark - MAMapViewDelegate
//当位置改变时候调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (self.isFirist) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        self.isFirist = NO;
    }
    
    _latitude = userLocation.coordinate.latitude;
    _longitude = userLocation.coordinate.longitude;
    
    self.coordinate = userLocation.coordinate;
    
}
//定位失败
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSString *errorString = @"";
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
}
//大头针属性设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    // 返回nil,意味着交给系统处理
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocation *aannotation = (MAUserLocation *)annotation;
        static NSString *pointReuseIndentifier = @"MAUserLocation";
        _annotationView = (CallHelpAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (_annotationView == nil)
        {
            _annotationView = [[CallHelpAnnotationView alloc] initWithAnnotation:aannotation reuseIdentifier:pointReuseIndentifier];
            _annotationView.canShowCallout = NO;
        }
        return _annotationView;
 
    }
    return nil;
}

#pragma mark  -------发送求助信息
//发送求助信息
- (void)sendHelpInfo
{
    if (_isSendHelp) {
        [self showHint:@"你已发送或接收了呼叫救援！"];
    }
    else
    {
        if ([[LZXHelper isNullToString:[NSString stringWithFormat:@"%f",_latitude]] isEqualToString:@""]) {
            _latitude = 30;
        }
        if ([[LZXHelper isNullToString:[NSString stringWithFormat:@"%f",_longitude]] isEqualToString:@""]) {
            _longitude = 114;
        }
        
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        paramDict[@"action"] = @"help";
        paramDict[@"alarm"] = alarm;
        paramDict[@"token"] = token;
        paramDict[@"key"] = @"0";
        paramDict[@"content"] = @"";
        paramDict[@"gps_h"] = [NSString stringWithFormat:@"%.6f",_longitude];
        paramDict[@"gps_w"] = [NSString stringWithFormat:@"%.6f",_latitude];
        
         [self showloadingName:@"发起救援"];
        
        [[HttpsManager sharedManager] post:GetHelpUrl parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response
                                                                 options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"resultcode"] isEqualToString:@"0"] )
            {
                [self.annotationView showPulsingHaloLayer];
                [self.topView showWithAlarm:alarm];
                
                if (dict[@"response"]) {
                    NSArray  *array = dict[@"response"];
                    if (array.count>0) {
                        NSDictionary * dic = array[0];
                        if (dic[@"helpid"]) {
                            self.sendHelpId = dic[@"helpid"];
                            if (dic[@"gid"])
                            {
                                self.getGid = dic[@"gid"];
                            }
                        }
                    }
                }
                
                _getGName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
                
                 [self showHint:@"发起救援成功"];
                _isSendHelp = YES;
                _rightButton.hidden = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotification object:self.getGid];
                
                self.userModel = nil;
                
            }
            else
            {
                [self showHint:@"发起救援失败！请重试"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ;
        }];
    }
}

- (void)callPhoneWith:(NSString*)alarm
{
    //电话
    
    if (![[LZXHelper isNullToString:_userModel.RE_phonenum] isEqualToString:@""]) {
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_userModel.RE_phonenum]];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        //记得添加到view上
        [self.view addSubview:callWebview];
    }
    else
    {
        [self showHint:@"无电话号码或号码无效"];
    }
}
- (void)callHelpCancel
{
    //忽略
    
    UIAlertController *cancelAlert= [UIAlertController alertControllerWithTitle:@"" message:@"是否忽略此次求助？" preferredStyle:UIAlertControllerStyleAlert];
    
    [cancelAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.tabBar.hidden = NO;
        [self.bottomView dissmiss];
        _isShow = NO;
        _isSendHelp = NO;
    }]];
    
    [cancelAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:cancelAlert animated:YES completion:nil];
}

- (void)callHelpSureHelp
{
    //支援
    [self sureToHelp];
}

#pragma mark  ------- 确认支援
- (void)sureToHelp
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"ensurhelp";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"helpalarm"] = _userModel.RE_alarmNum;
    paramDict[@"helpid"] = _userDic[@"content"][@"MSG"][@"HELPDATA"][@"helpid"];
    
    [[HttpsManager sharedManager] post:EnsurHelpUrl parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response
                                                             options:NSJSONReadingMutableContainers error:nil];
        
        WeakSelf
        if ([dict[@"resultcode"] isEqualToString:@"0"] ) {
            [self showHint:@"支援成功"];
            self.tabBarController.tabBar.hidden = NO;
            [weakSelf.bottomView dissmiss];
            [weakSelf.topView showWithAlarm:_userModel.RE_alarmNum];
            _isSendHelp = YES;
            _isShow = NO;
            _rightButton.hidden = NO;
            NSDictionary *userDict =[[NSDictionary alloc] initWithObjectsAndKeys:alarm,@"userAlarm", nil];
            [LYRouter openURL:@"ly://OwenUserSureHelpCallHelp" withUserInfo:userDict completion:nil];
        }
        else if ([dict[@"resultcode"] isEqualToString:@"1017"])
        {
            [self showHint:@"增援已结束"];
            self.tabBarController.tabBar.hidden = NO;
            [weakSelf.bottomView dissmiss];
            _isSendHelp = NO;
            _isShow = NO;
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark  -------确认支援的人取消
//确认支援的人取消
- (void)userCancelBtnClick
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"cancelhelp";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    if (![[LZXHelper isNullToString:_userDic[@"content"][@"SID"]] isEqualToString:@""]) {
        if (![alarm isEqualToString:_userDic[@"content"][@"SID"]]) {
            paramDict[@"type"] = @"0";
            paramDict[@"helpid"] = _userDic[@"content"][@"MSG"][@"HELPDATA"][@"helpid"];
        }
        else
        {
            paramDict[@"type"] = @"1";
            paramDict[@"helpid"] =self.sendHelpId;
        }
    }
    else
    {
        paramDict[@"type"] = @"1";
        paramDict[@"helpid"] =self.sendHelpId;
    }
    
    
    [[HttpsManager sharedManager] post:CancelHelpUrl parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response
                                                             options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"resultcode"] isEqualToString:@"0"] ) {
            [self showHint:@"解除增援成功"];
            
            [self.topView dissmiss];
            
            _isSendHelp = NO;
            _rightButton.hidden = YES;
            [self.annotationView dissmissPulsingHaloLayer];
        }
        else
        {
             [self showHint:@"解除增援失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)rightBtnClick
{
    if (![[LZXHelper isNullToString:_getGid] isEqualToString:@""] ) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObj:_getGid forKey:@"chatId"];
        [user setObj:@"G" forKey:@"chatType"];
        
        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
        
        chatC.chatterName = [NSString stringWithFormat:@"%@ 救援小组",_getGName];
        chatC.cType = GroupTeam;
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:self.getGid];
        
        chatC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatC animated:YES];
    }
}

//获取两个距离
- (CLLocationDistance)getDistanceWith:(NSDictionary*)dict
{
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.latitude ,self.longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([dict[@"content"][@"GPS"][@"W"] doubleValue],[dict[@"content"][@"GPS"][@"H"] doubleValue]));
    //2.计算距离
    CLLocationDistance kilometers = MAMetersBetweenMapPoints(point1,point2);
    
    return kilometers;
}

- (void)alertHide
{
    self.alertLabel.hidden = YES;
    self.alertButton.hidden = YES;
}

#pragma mark -----

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//   s	__NSCFString *	@"{\"type\":\"broadcast\",\"cname\":\"0027\",\"seq\":1,\"content\":{\"SID\":\"0028\",\"RID\":\"e3rZNnVIebMmEN2jA7FE\",\"HEADPIC\":\"http://220.249.118.115:13201/tax00/M00/01/09/QUIPAFhKK72ABHz7AAALastp8_o045.jpg\",\"TYPE\":\"B\",\"CMD\":\"4\",\"MSGID\":\"40951\",\"TIME\":\"2017-03-02 10:10:31\",\"SNAME\":\"陈豪\",\"GPS\":{\"W\":\"30.598372\",\"H\":\"114.245894\"},\"QID\":1,\"IOSDATA\":\"\",\"MSG\":{\"MTYPE\":\"3\",\"DISPLAY_CONTENT\":\"\",\"HELPDATA\":{\"gid\":\"NQRFuVmjf33aEa2QbjaI\",\"helpid\":\"e3rZNnVIebMmEN2jA7FE\",\"name\":\"陈豪\"}}}}\n"	0x000000012f06b050


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
