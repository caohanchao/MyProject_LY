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

@interface CallHelpViewController ()<MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, assign) BOOL isFirist;
@property (nonatomic, strong) CallHelpAnnotationView *annotationView;
@property (nonatomic, strong) CallHelpTopView *topView;
@property (nonatomic, strong) CallHelpAlertView *callHelpAlertView;
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
}
// 注册block路由
- (void)initRouter {
    
    WeakSelf
    [LYRouter registerURLPattern:@"ly://CallHelpViewControllerLongPressCallHelp" toHandler:^(NSDictionary *routerParameters) {
        [weakSelf callHelpAlertViewShow];
        
    }];
}
- (void)addTopView {
 //   [self.view addSubview:self.topView];
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
    //        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateSelected];
    
    [self.mapView addSubview:self.locationButton ];
}
- (CallHelpTopView *)topView {
    if (!_topView) {
        _topView = [[CallHelpTopView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 0)];
    }
    return _topView;
}
- (CallHelpAlertView *)callHelpAlertView {
    if (!_callHelpAlertView) {
        _callHelpAlertView = [[CallHelpAlertView alloc] init];
        WeakSelf
        [_callHelpAlertView click:^(ButtonClickType type) {
            if (type == ButtonClickConfirm) {
                [weakSelf.annotationView showPulsingHaloLayer];
                [weakSelf.topView show];
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
