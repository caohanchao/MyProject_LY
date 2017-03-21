//
//  MapViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatLocationViewController.h"
#import "ZEBMapNavigationView.h"

@import CoreLocation;
@import MapKit;


@interface ChatLocationViewController ()<MAMapViewDelegate, AMapSearchDelegate> {
    AMapSearchAPI *_search;
    CLLocation *_currentLocation;
}

@property (nonatomic, nonnull, strong) MAMapView *mapView;

@property(nonatomic,strong)UIButton *locationButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *navigationBtn;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) ZEBMapNavigationView *mapNavigationView;

@end

@implementation ChatLocationViewController


-(void)initControl
{
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationButton .frame = CGRectMake(CGRectGetMaxX(_mapView.bounds)- 70, CGRectGetHeight(_mapView.bounds) - 140, 50, 50);
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
- (ZEBMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[ZEBMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}
- (void)initSearch
{
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate =self;
    
}
//逆地理编码
-(void)reGeoAction:(CLLocationCoordinate2D)coordinate
{
    _currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    if(_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
        
    }
}
#pragma mark -AMapSearchDelegate
//失败回调
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{

    NSLog(@"request :%@, error :%@", request, error);
}


//成功回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@", response);
    AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",addressComponent.township,addressComponent.neighborhood];
    self.desLabel.text = response.regeocode.formattedAddress;
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-70, kScreenWidth, 70)];
        _bottomView.backgroundColor = zWhiteColor;
    }
    return _bottomView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(18) textColor:zBlackColor text:@""];
        _titleLabel.frame = CGRectMake(12, 8, kScreenWidth - 12 - 64, 30);
    }
    return _titleLabel;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:CHCHexColor(@"808080") text:@""];
        _desLabel.frame = CGRectMake(12, 45, kScreenWidth - 12 - 64, 10);
    }
    return _desLabel;
}
- (UIButton *)navigationBtn {
    if (!_navigationBtn) {
        _navigationBtn = [CHCUI createButtonWithtarg:self sel:@selector(navigation) titColor:nil font:nil image:nil backGroundImage:@"chatnavigation" title:@""];
        _navigationBtn.frame = CGRectMake(kScreenWidth-24 - 40, 15, 40, 40);
    }
    return _navigationBtn;
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
    [self initSearch];
    [self initBottom];
    [self initControl];
}
- (void)initBottom {
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.backgroundColor = LineColor;
    [self.bottomView addSubview:line];
    
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.desLabel];
    [self.bottomView addSubview:self.navigationBtn];
    [self.view addSubview:self.bottomView];
    
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
    
    // 逆编码
    [self reGeoAction:pointAnnotation.coordinate];
    self.coordinate = pointAnnotation.coordinate;
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
//大头针属性设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    // 返回nil,意味着交给系统处理
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAPointAnnotation *annotation1 = (MAPointAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"MAUserLocation1";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation1 reuseIdentifier:pointReuseIndentifier];
            annotationView.userInteractionEnabled=YES;
            annotationView.canShowCallout = NO;
        }
        annotationView.image = [UIImage imageNamed:@"chatlocation"];
        
        return annotationView;
    }
    return nil;
}
#pragma mark -
#pragma mark 导航
- (void)navigation {
    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:self.coordinate.latitude targetLongitute:self.coordinate.longitude toName:self.desLabel.text];
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
