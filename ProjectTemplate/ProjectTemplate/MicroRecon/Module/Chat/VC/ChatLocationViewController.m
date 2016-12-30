//
//  MapViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatLocationViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ChatLocationViewController ()<MAMapViewDelegate>

@property (nonatomic, nonnull, strong) MAMapView *mapView;

@property(nonatomic,strong)UIButton *locationButton;
@end

@implementation ChatLocationViewController


-(void)initControl
{
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationButton .frame = CGRectMake(CGRectGetMaxX(_mapView.bounds)- 70, CGRectGetHeight(_mapView.bounds) - 90, 50, 50);
    self.locationButton .autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    self.locationButton .backgroundColor = [UIColor whiteColor];
    self.locationButton .layer.cornerRadius = 25;
    [self.locationButton  addTarget:self action:@selector(locateAction)
              forControlEvents:UIControlEventTouchUpInside];

    [self.locationButton  setImage:[UIImage imageNamed:@"nomalLocal"] forState:UIControlStateNormal];
//        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateSelected];
    
    [self.mapView addSubview:self.locationButton ];
}

-(void)locateAction
{

    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        _mapView.showsUserLocation = YES;
    }
    else
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
        _mapView.showsUserLocation = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"位置";
    
    // Do any additional setup after loading the view.
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;    //YES 为打开定位，NO为关闭定位
    /*
     * MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
     * MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
     * MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
     */
//    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    [self.mapView setZoomLevel:16.1 animated:YES];
    [self.view addSubview:self.mapView];
    [self initControl];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    NSRange rangeJ = [self.locationUrl rangeOfString:@"location="];
    NSRange rangeW = [self.locationUrl rangeOfString:@","];
    NSRange rangeZ = [self.locationUrl rangeOfString:@"&zoom"];
    
    
    NSRange rangeLongi = NSMakeRange(rangeJ.location+rangeJ.length, rangeW.location-rangeJ.location-rangeJ.length);
    NSRange rangeLati = NSMakeRange(rangeW.location+rangeW.length, rangeZ.location-rangeW.location-rangeW.length);
    CLLocationDegrees longitude = [[self.locationUrl substringWithRange:rangeLongi] doubleValue];
    CLLocationDegrees latitude = [[self.locationUrl substringWithRange:rangeLati] doubleValue];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    // 设置地图中心的坐标
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    [_mapView addAnnotation:pointAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapViewDelegate
/*!
 @brief 位置或者设备方向更新后调用此接口
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation) {
        //取出当前位置的坐标
        ZEBLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
