//
//  VehicleDetectionViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  车侦地图

#import "VehicleDetectionViewController.h"
#import "VehicleDetectionMapManager.h"
#import <MAMapKit/MAMapKit.h>
#import "VehicleDetectionListView.h"
#import "VdMAAnnotationView.h"
#import "VdAnnotation.h"
#import "VdCalloutView.h"
#import "VdBaseResultModel.h"
#import "VdResultModel.h"
#import "UIViewController+BackButtonHandler.h"
#import "GetInfoCarRequest.h"
#import "VehicleDetectionListViewController.h"


@interface VehicleDetectionViewController ()<MAMapViewDelegate, VehicleDetectionListViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) VehicleDetectionListView *vdListView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableArray *overlayArray;
@property (nonatomic, strong) NSMutableDictionary *dateDic;
@property (nonatomic, strong) MAPolyline *commonPolyline;
@property (nonatomic, strong) NSArray *carDataSource;
@property (nonatomic, weak) VdAnnotation *vdAnnotation;

@property (nonatomic, assign) BOOL isFirist;

@end

@implementation VehicleDetectionViewController

- (void)setCarDataSource:(NSArray *)carDataSource {
    
    _carDataSource = carDataSource;
    self.title = [[_carDataSource firstObject] hphm];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"鄂A39L76";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirist = YES;
    [self initall];
}
/*
 
 禁止当前页面左侧滑动返回 
 
 */

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [super viewWillDisappear:animated];
    
}

- (NSMutableDictionary *)dateDic {
    if (!_dateDic) {
        _dateDic = [NSMutableDictionary dictionary];
    }
    return _dateDic;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}
- (NSMutableArray *)overlayArray {
    if (!_overlayArray) {
        _overlayArray =[NSMutableArray array];
    }
    return _overlayArray;
}
- (void)initall {
    [self initRoutable];
    [self initMap];
  //  [self initVdListView];
    [self getSource];
}
//注册block路由
- (void)initRoutable{
    __block typeof(self) mySelf = self;
    //跳转详情
    [LYRouter registerURLPattern:@"ly://VehicleDetectionViewControllerSkipVehicleDetectionDesViewController" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
                                  
        if ([userInfo[@"VdModel"] isKindOfClass:[VdResultModel class]]) {
            VehicleDetectionListViewController *vl = [[VehicleDetectionListViewController alloc] init];
            
            VdResultModel *model = userInfo[@"VdModel"];
            [vl setkkbh:model.kkbh withAllarr:[mySelf.carDataSource mutableCopy]];
            
            [mySelf.navigationController pushViewController:vl animated:YES];
        }else {
            ZEBLog(@"model 类型错误");
        }
    }];
}
- (VehicleDetectionListView *)vdListView {
    if (!_vdListView) {
        _vdListView = [[VehicleDetectionListView alloc] initWithFrame:CGRectMake(0, HeightC, kScreenWidth, kScreenHeight-HeightC)];
        _vdListView.delegate = self;
    }
    return _vdListView;
}
- (BOOL)navigationShouldPopOnBackButton {
    [self clearMapView];
    return YES;
}
- (void)initVdListView {
    [self.view addSubview:self.vdListView];
}
- (void)getSource {
    
    [self.dataArray removeAllObjects];
    [self.vdListView.dataArray removeAllObjects];
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"VDList" ofType:@"plist"];
//    NSMutableDictionary *plistdic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    VdBaseResultModel *baseModel = [VdBaseResultModel getInfoWithData:plistdic];
    [self.vdListView.dataArray addObjectsFromArray:_carDataSource];
    [self.dataArray addObjectsFromArray:_carDataSource];
    
    
    [self mapAddAnnotationAndOverlay];
    //[self soureArray:_carDataSource];
   
}
- (void)mapAddAnnotationAndOverlay {

    //筛选标记
    [self screeningLongitudeAndLatitude];
    
    NSInteger count = self.dataArray.count;
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[count];

    //将数据按照时间排序
    NSArray *results = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        VdResultModel *model1 = obj1;
        VdResultModel *model2 = obj2;
        NSComparisonResult result = [model1.jgsj compare:model2.jgsj];
        return result == NSOrderedAscending;
    }];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:results];
    for (int i = 0; i < count; i++) {
        
        VdResultModel *model = self.dataArray[i];
        model.kkindex =  (count - i);
        if (model.sbxx.count > 0) {
            SBXXModel *sbModel = [model.sbxx firstObject];
            VdAnnotation *vdAnnotation = [[VdAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([sbModel.latitude doubleValue], [sbModel.longitude doubleValue])];
            ZEBLog(@"latitude--------%f----longitude--------%f",[sbModel.latitude doubleValue],[sbModel.longitude doubleValue]);
            vdAnnotation.date = [GetInfoCarRequest cutTimeForHourMinment:model.jgsj];
            vdAnnotation.moment = model.jgsj;
            vdAnnotation.iconUrl = model.gctx;
            vdAnnotation.LaneNumber = model.cdbh;
            vdAnnotation.bayonetName = [[model.sbxx firstObject] deviceName];
            vdAnnotation.myID = model.clxxbh;
            vdAnnotation.model = model;
            vdAnnotation.kknum = [NSString stringWithFormat:@"%@",model.kknum];
            vdAnnotation.index = model.kkindex;
            [self.annotationArray addObject:vdAnnotation];
            
            commonPolylineCoords[i].latitude = [sbModel.latitude doubleValue];
            commonPolylineCoords[i].longitude = [sbModel.longitude doubleValue];
        }
        
    }
    
    //构造折线对象
    _commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
    
    [self.mapView addAnnotations:self.annotationArray];
    //在地图上添加折线对象
    [self.mapView addOverlay:_commonPolyline];
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    if (self.annotationArray.count > 0) {
        _vdAnnotation = self.annotationArray[0];
        [self.mapView selectAnnotation:_vdAnnotation animated:YES];
    }
    
    
   
    
}
#pragma mark -
#pragma mark 地图
- (void)initMap {
    
    MAMapView *mapView = [VehicleDetectionMapManager shareMAMapView];
    self.mapView = mapView;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    //设置地图类型
    self.mapView.mapType=MAMapTypeStandard;
   // self.mapView.showsUserLocation = YES;
   // self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    //[self.mapView setZoomLevel:16.1 animated:YES];
    //后台定位
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    
}
// 清除地图
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlay:_commonPolyline];
    self.mapView.delegate = nil;
}
#pragma mark - MAMapViewDelegate
//当位置改变时候调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
 
    if (self.isFirist) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        self.isFirist = NO;
    }
}
//大头针属性设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[VdAnnotation class]])
    {
        VdAnnotation *tempAnnotation = (VdAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        VdMAAnnotationView *annotationView = (VdMAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[VdMAAnnotationView alloc] initWithAnnotation:tempAnnotation reuseIdentifier:pointReuseIndentifier];
            annotationView.draggable = YES;
            annotationView.canShowCallout = NO;
            
        }
        annotationView.aannotation = tempAnnotation;
        //设置背景图片
       // annotationView.image = [UIImage imageNamed:@"vd_annotation"];
        
        return annotationView;
    }
    return nil;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth = 10;
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"vdGuiji"]];

        return polylineRenderer;
    }
    
    return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    if ([view isKindOfClass:[VdMAAnnotationView class]]) {
        VdMAAnnotationView *tempView = (VdMAAnnotationView *)view;
         [self.mapView setCenterCoordinate:tempView.aannotation.coordinate animated:YES];
    }
}

#pragma mark -
#pragma mark vdListDelegate
- (void)vehicleDetectionListView:(VehicleDetectionListView *)view vdResultModel:(VdResultModel *)mode {
    
    if (mode.sbxx.count > 0) {
        SBXXModel *sbModel = [mode.sbxx firstObject];
        if ([[LZXHelper isNullToString:[sbModel.longitude stringValue]] isEqualToString:@""] || [[LZXHelper isNullToString:[sbModel.latitude stringValue]] isEqualToString:@""] || ([sbModel.longitude doubleValue] == 0.000000 && [sbModel.latitude doubleValue] == 0.000000)) {
            [self showHint:@"当前设备没有位置信息"];
            return;
        }else {
            for (VdAnnotation *vdAnnotation in self.annotationArray) {
                if ([vdAnnotation.myID isEqualToString:mode.clxxbh]) {
                    [self.mapView selectAnnotation:vdAnnotation animated:YES];
                    [view isToBottom];
                    break;
                }
            }
        }
    }else {
        [self showHint:@"当前设备没有位置信息"];
    }
}
#pragma mark -
#pragma mark 格式化数据

- (void)soureArray:(NSMutableArray *)array {
    
    //将数据按照时间排序
    NSArray *results = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        VdResultModel *model1 = obj1;
        VdResultModel *model2 = obj2;
        NSComparisonResult result = [model1.jgsj compare:model2.jgsj];
        return result == NSOrderedAscending;
    }];
    
    NSString *time1;
    for (VdResultModel *model in results) {
        NSString *time2 = [model.jgsj componentsSeparatedByString:@" "][0];
        if (![time1 isEqualToString:time2]) {
            [self.vdListView.titleArray addObject:time2];
            time1 = time2;
        }
    }
    for (int i = 0; i < self.vdListView.titleArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < results.count; j++) {
            VdResultModel *model = results[j];
            NSString *time2 = [model.jgsj componentsSeparatedByString:@" "][0];
            if ([time2 isEqualToString:self.vdListView.titleArray[i]]) {
                
                [array addObject:model];
                
            }
            if (j == self.vdListView.titleArray.count-1) {
                [self.vdListView.dateDic setObject:array forKey:self.vdListView.titleArray[i]];
            }
        }
    }
    
    [self.vdListView reloadData];

}
- (void)screeningLongitudeAndLatitude {
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dataArray];
    for ( VdResultModel *vModel in tempArr) {
        if (vModel.sbxx.count == 0) {
            [self.dataArray removeObject:vModel];
        }
        else {
            for (SBXXModel *sbModel in vModel.sbxx) {
                if ([[LZXHelper isNullToString:[sbModel.longitude stringValue]] isEqualToString:@""] || [[LZXHelper isNullToString:[sbModel.latitude stringValue]] isEqualToString:@""] || ([sbModel.longitude doubleValue] == 0.000000 && [sbModel.latitude doubleValue] == 0.000000)) {
                    [self.dataArray removeObject:vModel];
                }
            }
        }
    }

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
