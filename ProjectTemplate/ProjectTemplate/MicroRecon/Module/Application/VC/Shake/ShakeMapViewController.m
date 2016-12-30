//
//  ShakeMapViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeMapViewController.h"
#import "VehicleDetectionMapManager.h"
#import <MAMapKit/MAMapKit.h>
#import "UIViewController+BackButtonHandler.h"
#import "ShakeMapListView.h"
#import "ShakeCameraModel.h"
#import "ShakeAnnotationView.h"
#import "ShakeAnnotation.h"

@interface ShakeMapViewController ()<MAMapViewDelegate, ShakeMapListViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) ShakeMapListView *mapListView;
@property (nonatomic, strong) NSMutableArray *annotationArray;

@end

@implementation ShakeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    self.title = @"位置";
    [self initall];
}
/*
 
 禁止当前页面左侧滑动返回 
 
 */

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [super viewWillDisappear:animated];
    
}

- (void)initall {

    [self initMap];
    [self initMapListView];
}
- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (ShakeMapListView *)mapListView {
    if (!_mapListView) {
        _mapListView = [[ShakeMapListView alloc] initWithFrame:CGRectMake(0, HeightC, kScreenWidth, kScreenHeight - HeightC)];
        _mapListView.delegate = self;
    }
    return _mapListView;
}
- (BOOL)navigationShouldPopOnBackButton {
    [self clearMapView];
    return YES;
}

#pragma mark -
#pragma mark 数据列表
- (void)initMapListView {
    
    self.mapListView.shakeMapListType = (SHAKEMAPLISTSHAKETYPE)self.shakeMapType;
    [self.view addSubview:self.mapListView];
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
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    //[self.mapView setZoomLevel:16.1 animated:YES];
    //后台定位
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    
     [self addAnnotations];
}
// 清除地图
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.delegate = nil;
}

- (void)addDistance:(NSMutableArray *)arr {
    
    for (ShakeCameraModel *model in arr) {
        AppDelegate *appDelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.gps_w doubleValue],[model.gps_h doubleValue]));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([appDelegate.latitude doubleValue],[appDelegate.longitude doubleValue]));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        if (distance > 500) {
            distance = 500;
        }
        model.distance = [NSString stringWithFormat:@"%ld",(NSInteger)distance];
    }
//    //将数据按照距离排序
//    NSArray *results = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        ShakeCameraModel *model1 = obj1;
//        ShakeCameraModel *model2 = obj2;
//        NSComparisonResult result = [model1.distance compare:model2.distance];
//        return result == NSOrderedDescending;
//    }];
    //将数据按照距离排序
    NSArray *results = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ShakeCameraModel *model1 = obj1;
        ShakeCameraModel *model2 = obj2;
        if ([model1.distance floatValue] < [model2.distance floatValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:results];
    
    NSInteger i = 0;
    for (ShakeCameraModel *model in self.dataArray) {
        model.udid = i;
        i++;
    }
    [self.mapListView reloadData:[self.dataArray mutableCopy]];
}
- (void)addAnnotations {

    for (ShakeCameraModel *model in self.dataArray) {
        ShakeAnnotation *annotation = [[ShakeAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([model.gps_w doubleValue], [model.gps_h doubleValue])];
        annotation.index = model.udid;
        [self.annotationArray addObject:annotation];
    }
    [self.mapView addAnnotations:self.annotationArray];
    [self.mapView showAnnotations:self.annotationArray animated:YES];

}

//大头针属性设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[ShakeAnnotation class]])
    {
        ShakeAnnotation *pointAnnotation = (ShakeAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        ShakeAnnotationView *annotationView = (ShakeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[ShakeAnnotationView alloc] initWithAnnotation:pointAnnotation reuseIdentifier:pointReuseIndentifier];
            annotationView.draggable = YES;
            annotationView.canShowCallout = NO;
        }
        annotationView.aannotation = pointAnnotation;
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    if ([view isKindOfClass:[ShakeAnnotationView class]]) {
        ShakeAnnotationView *tempView = (ShakeAnnotationView *)view;
        [self.mapView setCenterCoordinate:tempView.aannotation.coordinate animated:YES];
        [self.mapListView scrollToSection:tempView.aannotation.index-0];
        [self.mapListView selectSection:tempView.aannotation.index-0];
        [self.mapListView scrollToCenter];
    }
}
- (void)shakeMapListView:(ShakeMapListView *)view model:(ShakeCameraModel *)model {
   
    for (ShakeAnnotation *annotation in self.annotationArray) {
        if (annotation.index == model.udid) {
             [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([model.gps_w doubleValue], [model.gps_h doubleValue]) animated:YES];
          [self.mapView selectAnnotation:annotation animated:YES];
            break;
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
