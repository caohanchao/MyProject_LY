//
//  XMLocationController.m
//  XMChatBarExample
//
//  Created by shscce on 15/8/24.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMLocationController.h"
#import "MapLocationManager.h"
#import "Masonry.h"

@interface XMLocationController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapSearchDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapSearchAPI *search;

@property (strong, nonatomic) UIButton *showUserLocationButton;
@property (strong, nonatomic) UIImageView *locationImageView;

@property (strong, nonatomic) NSMutableArray *pois;
@property (assign, nonatomic) BOOL firstLocateUser;

/// 用户位置经纬度。
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (weak, nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic, assign) BOOL isFirist;

@end

@implementation XMLocationController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isFirist = YES;
    if ([self.locationStr isEqualToString:@"circle"])
    {
        self.title = @"位置";
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveLocation)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendLocation)];
    }
    
    self.pois = [NSMutableArray array];
    
    self.firstLocateUser = YES;
    [self.mapView addSubview:self.locationImageView];
    [self.mapView addSubview:self.showUserLocationButton];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    
//    [[XMLocationManager shareManager] requestAuthorization];
    
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapView.mas_centerX);
        make.centerY.equalTo(self.mapView.mas_centerY);
    }];
    
    [self.showUserLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapView.mas_left).with.offset(8);
        make.bottom.equalTo(self.mapView.mas_bottom).with.offset(-8);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(280);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.mapView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
  
    [_mapView setZoomLevel:16.1 animated:YES];
    
    if ([self.locationStr isEqualToString:@"circle"])
    {
        [self performSelector:@selector(delayMapView) withObject:nil afterDelay:1.0f];
    }
}

- (void)delayMapView
{
    [self updateCenterLocation:self.mapView.userLocation.coordinate];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *poi = self.pois[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    if (indexPath.row == self.selectedIndexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row >= self.pois.count) {
        return cell;
    }

    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"[位置] \n%@",poi.address];
    }else{
        cell.textLabel.text = poi.address;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    AMapPOI *poi = self.pois[indexPath.row];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    [tableView reloadData];
}

#pragma mark - MAMapViewDelegate

/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [self searchNearBy:mapView.centerCoordinate];
    }
    
}

/*
 * 当位置更新时，会进定位回调
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
       // NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        if (self.coordinate.latitude == 0) {
            self.coordinate = userLocation.coordinate;
            [self searchNearBy:self.coordinate];
        }
        
    }
    if (self.isFirist) {
        self.isFirist = NO;
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    }
}


#pragma mark - Private Methods

/**
 *  搜索附近兴趣点信息
 *
 *  @param coordinate 搜索的点
 */
- (void)searchNearBy:(CLLocationCoordinate2D)coordinate{
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.radius = 500;
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [self.search AMapPOIAroundSearch: request];
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if(response.pois.count == 0)
    {
        return;
    }
    
    // 先清楚原来 pois 里的数据，再添加新数据
    [self.pois removeAllObjects];
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.address];
        [self.pois addObject: p];
    }
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
   // NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    //NSLog(@"Place: %@", result);
}


/**
 *  更新mapView中心点
 *
 *
 *  @param centerCoordinate 自己的坐标
 */
- (void)updateCenterLocation:(CLLocationCoordinate2D)centerCoordinate{
    // 将当前地图的中心移动到自己的坐标上
    [self.mapView setCenterCoordinate:centerCoordinate animated:YES];
    // 根据当前地图中心坐标搜寻附近的poi
    [self searchNearBy:centerCoordinate];
}

/*
 * 显示到自己位置上
 */
- (void)showUserLocation{
    self.showUserLocationButton.selected = YES;
    [self updateCenterLocation:self.mapView.userLocation.coordinate];
}


- (void)cancel{
    [self clearMapView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLocation)]) {
        [self.delegate cancelLocation];
    }
    
}
- (void)clearMapView
{
    [self.locationImageView removeFromSuperview];
    [self.showUserLocationButton removeFromSuperview];
    self.mapView.showsUserLocation = NO;
    self.search.delegate = nil;
    self.mapView.delegate = nil;

}


- (void)sendLocation{
    [self clearMapView];
    if (self.pois.count > self.selectedIndexPath.row) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendLocation:locationText:)]) {
            AMapPOI *poi = self.pois[self.selectedIndexPath.row];
            AMapGeoPoint *point = poi.location;
            NSString *locationUrl = [NSString stringWithFormat:@"http://restapi.amap.com/v3/staticmap?location=%f,%f&zoom=15&size=256*128&markers=mid,,A:%f,%f&key=bd2e6bcf8479ed6598c063ea9710c939", point.longitude, point.latitude, point.longitude, point.latitude];
            [self.delegate sendLocation:locationUrl locationText:poi.address];
        }
    }
}

- (void)saveLocation
{
    [self clearMapView];
    
    if (self.pois.count>0) {
    if (self.pois[self.selectedIndexPath.row]) {

        AMapPOI *poi = self.pois[self.selectedIndexPath.row];
        NSString *locationUrl = poi.address;
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:locationUrl,@"address", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:AddressChangeNotification object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
     }
    }
    [self cancel];
}

#pragma mark - Getters

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [MapLocationManager shareMAMapView];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIButton *)showUserLocationButton{
    if (!_showUserLocationButton) {
        _showUserLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showUserLocationButton setBackgroundImage:[UIImage imageNamed:@"show_user_location_normal"] forState:UIControlStateNormal];
        [_showUserLocationButton setBackgroundImage:[UIImage imageNamed:@"show_user_location_pressed"] forState:UIControlStateHighlighted];
        [_showUserLocationButton setBackgroundImage:[UIImage imageNamed:@"show_user_location_selected"] forState:UIControlStateSelected];
        [_showUserLocationButton addTarget:self action:@selector(showUserLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showUserLocationButton;
}

- (UIImageView *)locationImageView{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPin.png"]];
    }
    return _locationImageView;
}

@end
