//
//  MapViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GetrecordByGroupBaseModel.h"
#import "ZAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "ChatMapModel.h"
#import "PAnnotation.h"
#import "MemberCalloutView.h"
#import "MemberAnnotationView.h"
#import "MapBtnView.h"
#import "MapBtnBtnsView.h"
#import "ZEBBubbleView.h"
#import "ChatBusiness.h"
#import "MapManager.h"
#import "SuspectBaseModel.h"
#import "WorkAllTempModel.h"
#import "LocationManager.h"
#import "StartPathAnnotationView.h"
#import "StartAnnotation.h"
#import "StopPathAnnotationView.h"
#import "StopAnnotation.h"
#import "MAPointAnnotation+Property.h"
#import "MAPolyline+Property.h"
#import "XMLocationManager.h"
#import "MinePolylineRenderer.h"
#import "MinePolyline.h"
#import "OthersPolyline.h"
#import "OthersPolylineRenderer.h"
#import "UIImage+UIImageScale.h"
//#import "DraftsViewController.h"

#import "GetPathModel.h"
#import "GetPathLocationModel.h"


@interface MapViewController ()<MAMapViewDelegate>
{
    //经度
    CGFloat _latitude;
    //纬度
    CGFloat _longitude;
    
}

@property (nonatomic, weak) LocationManager *locationManager;
@property (nonatomic, weak) WorkAllTempModel *workAllModel;
@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) UIControl *overlayView;

@property (nonatomic, strong) NSMutableDictionary *taskAllDictionarg;//按照任务ID存放任务
@property (nonatomic, strong) NSMutableDictionary *pointAllDictionarg;//按照任务ID存放大头针

@property (nonatomic, strong) NSMutableArray *tempAnnontationArray;//某个任务下的大头针数组（会变）

@property (nonatomic, strong) NSMutableArray *taskAllMarkArray;//所有的任务标记
@property (nonatomic, strong) NSMutableArray *taskAllArray;//所有的任务

@property (nonatomic, strong) NSMutableArray *linesignArray;//摄像头
@property (nonatomic, strong) NSMutableArray *intersignArray;//标记
@property (nonatomic, strong) NSMutableArray *interinfoArray;//纪录
@property (nonatomic, strong) NSMutableArray *trackinfoArray;//纪录(废弃)

@property (nonatomic, strong) NSMutableArray *linesignAnnotationArray;//摄像头大头针
@property (nonatomic, strong) NSMutableArray *intersignAnnotationArray;//标记大头针
@property (nonatomic, strong) NSMutableArray *interinfoAnnotationArray;//纪录大头针
@property (nonatomic, strong) NSMutableArray *trackinfoAnnotationArray;//纪录大头针(废弃)

@property (nonatomic, strong) NSMutableArray *taskAnnotationsArray;//所有的任务大头针
@property (nonatomic, strong) NSMutableArray *annotationsArray;//群成员大头针集合
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSMutableArray *membersArray;
//任务id和任务名称
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workName;

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) MapBtnView *mapBtnView;
@property (nonatomic, strong) MapBtnBtnsView *mapBtnBtnsView;
@property (nonatomic, strong) ZEBBubbleView *bubbleView;


@property (nonatomic, copy) NSString *guiJiSelect;
@property (nonatomic, copy) NSString *biaoJiSelect;
@property (nonatomic, copy) NSString *cameraSelect;
@property (nonatomic, copy) NSString *jiLuSelct;

@property (nonatomic, strong) NSMutableArray *pointArr; // 存储轨迹的数组.
@property (nonatomic, weak) MAUserLocation *currentUL; // 当前位置
//画线
@property (nonatomic, strong) MinePolyline *routeLine;

@property (nonatomic, strong) NSMutableArray *startPathArr;
@property (nonatomic, strong) NSMutableArray *stopPathArr;

@property (nonatomic, strong) NSMutableArray *selectPathArray; // 选中的轨迹
@property (nonatomic, strong) NSMutableArray *pathArray; // 所有的轨迹 不包括自己的
@property (nonatomic, strong) NSMutableArray *tempPathArray;

@property (nonatomic, strong) StartAnnotation *startAnnotation;
@property (nonatomic, strong) StopAnnotation *stopAnnotation;

@property (nonatomic, assign) BOOL isFirist;

@property (nonatomic, weak) MAPolylineRenderer *lastPolylineRenderer;
@property (nonatomic, weak) StartPathAnnotationView *lastStartPathAnnotationView;
@property (nonatomic, weak) StopPathAnnotationView *lastStopPathAnnotationView;

@end

@implementation MapViewController

//注册block路由
- (void)initRoutable {
    __block typeof(self) mySelf = self;
    //返回地图中心位置
    [LYRouter registerURLPattern:@"ly://getmapcenterCoordinate" toHandler:^(NSDictionary *routerParameters) {
        
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        parm[@"latitude"] = [NSString stringWithFormat:@"%f",mySelf.mapView.centerCoordinate.latitude];
        parm[@"longitude"] = [NSString stringWithFormat:@"%f",mySelf.mapView.centerCoordinate.longitude];
        
        [LYRouter openURL:@"ly://receivecenterCoordinate" withUserInfo:parm completion:^(id result) {
            
        }];
    }];
    
    [LYRouter registerURLPattern:@"ly://mapaddmark" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        mySelf.workAllModel = userInfo[@"workAllModelMark"];
        if (![mySelf.workId isEqualToString:mySelf.workAllModel.workId]) {
            NSMutableDictionary *parm = [NSMutableDictionary dictionary];
            parm[@"workid"] = mySelf.workAllModel.workId;
            
            [LYRouter openURL:@"ly://ChatMapControllerChangeTaskForWorkId" withUserInfo:parm completion:nil];
        }
        [mySelf addOneAnnotation:NO];
    }];
    [LYRouter registerURLPattern:@"ly://mapdismiss" toHandler:^(NSDictionary *routerParameters) {
        [mySelf dismiss];
    }];
    
    [LYRouter registerURLPattern:@"ly://addPathMark" toHandler:^(NSDictionary *routerParameters) {
        
        NSString *title = @"确定开启轨迹？";
        NSString *message = @"请确认已经开启手机定位";
        if (mySelf.isLocation) { // 打开轨迹
            title = @"确定结束轨迹";
            message = @"";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (mySelf.isLocation) {
                //不允许后台
                mySelf.mapView.allowsBackgroundLocationUpdates = NO;
                mySelf.isLocation = NO;// 关闭轨迹
                //手机位置信息 保存最后的位置信息
                [mySelf setPointArrWithCurrentUserLocation:@"2"];
                [mySelf addStopMapPath];
                [mySelf PopTrackPageWithEditType:0 WithFromWhere:2];
                
                ZEBLog(@"pointArr------%@",self.pointArr);
                
            }else {
                BOOL ret = [[XMLocationManager shareManager] requestAuthorization:^{
                }];
                if (ret) {
                    [mySelf.pointArr removeAllObjects];
                    //允许后台
                    mySelf.mapView.allowsBackgroundLocationUpdates = YES;
                    mySelf.isLocation = YES;
                    [mySelf.mapView setCenterCoordinate:self.currentUL.coordinate animated:YES];
                    //手机位置信息 保存第一次的位置信息
                    [mySelf setPointArrWithCurrentUserLocation:@"1"];
                    [mySelf addStartMapPath];
                    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
                    parm[@"warn"] = [NSString stringWithFormat:@"您已开启（%@）轨迹",mySelf.workName];
                    [LYRouter openURL:@"ly://showWarningView" withUserInfo:parm completion:^(id result) {
                        
                    }];
                }
            }
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:action2];
        [alertController addAction:action1];
        
        [mySelf presentViewController:alertController animated:YES completion:nil];
    }];
    [LYRouter registerURLPattern:@"ly://MapViewControllerGetPathList" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSMutableArray *pathlist = userInfo[@"pathlist"];
        mySelf.selectPathArray = pathlist;
        //清空后重新绘制
        [mySelf.mapView removeAnnotations:mySelf.startPathArr];
        [mySelf.mapView removeAnnotations:mySelf.stopPathArr];
        [mySelf.mapView removeOverlays:mySelf.pathArray];
        [mySelf.pathArray removeAllObjects];
        [mySelf.tempPathArray removeAllObjects];
        [mySelf.startPathArr removeAllObjects];
        [mySelf.stopPathArr removeAllObjects];
        //添加轨迹
        [mySelf addAllPath];
    }];
    // 移除采集的轨迹
    [LYRouter registerURLPattern:@"ly://MapViewControllerRemovePolyline" toHandler:^(NSDictionary *routerParameters) {
        [mySelf.mapView removeOverlay:mySelf.routeLine];
        [mySelf.mapView removeAnnotation:mySelf.startAnnotation];
        [mySelf.mapView removeAnnotation:mySelf.stopAnnotation];
        
    }];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirist = YES;
    [self initall];
}
- (void)setGname:(NSString *)gname {
    _gname = gname;
    self.workName = self.gname;
}
- (NSMutableArray *)tempPathArray {
    if (!_tempPathArray) {
        _tempPathArray = [NSMutableArray array];
    }
    return _tempPathArray;
}
- (NSMutableArray *)pathArray {
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}
- (NSMutableArray *)pointArr {
    if (!_pointArr) {
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}
- (NSMutableArray *)tempAnnontationArray {
    if (!_tempAnnontationArray) {
        _tempAnnontationArray = [NSMutableArray array];
    }
    return _tempAnnontationArray;
}
- (NSMutableArray *)taskAnnotationsArray {
    if (!_taskAnnotationsArray) {
        _taskAnnotationsArray = [NSMutableArray array];
    }
    return _taskAnnotationsArray;
}
- (NSMutableArray *)taskAllMarkArray {
    if (!_taskAllMarkArray) {
        _taskAllMarkArray = [NSMutableArray array];
    }
    return _taskAllMarkArray;
}
- (NSMutableDictionary *)pointAllDictionarg {
    if (!_pointAllDictionarg) {
        _pointAllDictionarg = [NSMutableDictionary dictionary];
    }
    return _pointAllDictionarg;
}
- (NSMutableDictionary *)taskAllDictionarg {
    if (!_taskAllDictionarg) {
        _taskAllDictionarg = [NSMutableDictionary dictionary];
    }
    return _taskAllDictionarg;
}
- (NSMutableArray *)taskAllArray {
    if (!_taskAllArray) {
        _taskAllArray = [NSMutableArray array];
    }
    return _taskAllArray;
}
- (NSMutableArray *)linesignArray {
    if (_linesignArray == nil) {
        _linesignArray = [NSMutableArray array];
    }
    return _linesignArray;
}
- (NSMutableArray *)interinfoArray {
    if (_interinfoArray == nil) {
        _interinfoArray = [NSMutableArray array];
    }
    return _interinfoArray;
}
- (NSMutableArray *)intersignArray {
    if (_intersignArray == nil) {
        _intersignArray = [NSMutableArray array];
    }
    return _intersignArray;
}
- (NSMutableArray *)trackinfoArray {
    
    if (_trackinfoArray == nil) {
        _trackinfoArray = [NSMutableArray array];
    }
    return _trackinfoArray;
}
- (NSMutableArray *)annotationsArray {
    
    if (_annotationsArray == nil) {
        _annotationsArray = [NSMutableArray array];
    }
    return _annotationsArray;
}
- (NSMutableArray *)eventsArray {
    if (_eventsArray == nil) {
        _eventsArray = [NSMutableArray array];
    }
    return _eventsArray;
}
- (NSMutableArray *)membersArray {
    if (_membersArray == nil) {
        _membersArray = [NSMutableArray array];
    }
    return _membersArray;
}
- (NSMutableArray *)intersignAnnotationArray {
    
    if (_intersignAnnotationArray == nil) {
        _intersignAnnotationArray = [NSMutableArray array];
    }
    return _intersignAnnotationArray;
}
- (NSMutableArray *)interinfoAnnotationArray {
    
    if (_interinfoAnnotationArray == nil) {
        _interinfoAnnotationArray = [NSMutableArray array];
    }
    return _interinfoAnnotationArray;
}
- (NSMutableArray *)linesignAnnotationArray {
    
    if (_linesignAnnotationArray == nil) {
        _linesignAnnotationArray = [NSMutableArray array];
    }
    return _linesignAnnotationArray;
}
- (NSMutableArray *)trackinfoAnnotationArray {
    
    if (_trackinfoAnnotationArray == nil) {
        _trackinfoAnnotationArray = [NSMutableArray array];
    }
    return _trackinfoAnnotationArray;
}
- (NSMutableArray *)stopPathArr {
    if (!_stopPathArr) {
        _stopPathArr = [NSMutableArray array];
    }
    return _stopPathArr;
}
- (NSMutableArray *)startPathArr {
    if (!_startPathArr) {
        _startPathArr = [NSMutableArray array];
    }
    return _startPathArr;
}
- (void)initall {
    
    self.guiJiSelect = @"YES";
    self.biaoJiSelect = @"YES";
    self.cameraSelect = @"YES";
    self.jiLuSelct = @"YES";
    self.workId = chooseAll;
    
    [self initRoutable];
    [self initNotificationCenter];
    [self initMap];
    [self setUserLocation];
    //[self httpGetMapAnnotation];
    [self httpGetworkbygroup];
    [self createMapBtnView];
}


- (void)setUserLocation {
    //        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateSelected];
    
    [self.mapView addSubview:self.locationButton ];
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
//添加可点击的背景图层
- (UIControl *)overlayView {
    
    if (_overlayView == nil) {
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.2;
        [_overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayView;
}
//释放气泡
- (void)dismiss {
    [_bubbleView removeFromSuperview];
    [_mapBtnBtnsView removeFromSuperview];
    _bubbleView = nil;
    _mapBtnBtnsView = nil;
    [_overlayView removeFromSuperview];
}
- (void)initMap {
    
    MAMapView *mapView = [MapManager shareMAMapView];
    self.mapView = mapView;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    //设置地图类型
    self.mapView.mapType=MAMapTypeStandard;
    //设置定位精度
    self.mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //设置定位距离
    self.mapView.distanceFilter = 1.0f;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    [self.mapView setZoomLevel:16.1 animated:YES];
    //后台定位
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    
    
}
- (void)createMapBtnView {
    
    _mapBtnView = [[MapBtnView alloc] initWithFrame:CGRectMake(kScreenWidth-80, kScreenHeight/3, 80, 280)];
    
    
    [self.view addSubview:_mapBtnView];
    
}
- (void)initNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMember:) name:MapAddMemberNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMember:) name:MapShowMemberNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEvent:) name:MapShowEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBtns:) name:MapShowBtnsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOneTaskAnnontation:) name:MapshowOneTaskAnnontationNotification object:nil];
}
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlay:self.routeLine];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.locationButton removeFromSuperview];
    self.mapView.delegate = nil;
}
//展示btn
- (void)showBtns:(NSNotification *)notification {
    
    [LYRouter openURL:@"ly://ChatMapControllerTopdismiss"];
    [self clearBtnView];
    NSDictionary *dic = notification.userInfo;
    NSMutableArray *dataArray = dic[@"buttons"];
    NSString *type = dic[@"type"];
    NSString *title = dic[@"title"];
    NSString *centerY = dic[@"centerY"];
    NSString *centerX = dic[@"centerX"];
    
    NSMutableArray *selectArray = @[self.jiLuSelct,self.biaoJiSelect,self.cameraSelect,self.guiJiSelect];
    
    //备注:屏蔽
    //    CGFloat h = 140;
    //    if (dataArray.count <= 4) {
    //        h = 80;
    //    }
    CGFloat leftMargin = 10;
    CGFloat btnCenterMarginX = 14;
    CGFloat topMargin = 15;
    CGFloat titleHeight = 10;
    CGFloat btnWidth = (250-leftMargin*2-btnCenterMarginX*3)/4;
    
    CGFloat h = topMargin*2 + btnWidth + titleHeight + 5;
    
    _bubbleView  = [[ZEBBubbleView alloc] initWithFrame:CGRectMake(0, 0, 250, h)];
    _bubbleView.direction = TriangleDirection_Right;
    _bubbleView.cornerRadius = 8;
    _bubbleView.color = RGB(108, 108, 108);
    _bubbleView.triangleXY = 20;
    _bubbleView.alpha = 0.8;
    [self.bubbleView showInPoint:CGPointMake([centerX floatValue] - 28, [centerY floatValue])];
    
    //添加背景图层和气泡
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.bubbleView];
    
    _mapBtnBtnsView = [[MapBtnBtnsView alloc] initWithFrame:CGRectMake(0, 0, width(_bubbleView.frame)-10, height(_bubbleView.frame)) dataArray:dataArray title:title type:type selectArray:selectArray clickBlock:^(UIButton *btn) {
        ZEBLog(@"-----%@-----%@",btn.type,btn.format);
        //对按钮的操作
        [self operationButtons:btn];
    }];
    _mapBtnBtnsView.center = CGPointMake(_bubbleView.center.x-10, _bubbleView.center.y);//CGPointMake([centerX floatValue] - 28, [centerY floatValue]);
    [self.view addSubview:_mapBtnBtnsView];
}


#pragma mark -
#pragma mark 切换任务
- (void)showOneTaskAnnontation:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    
    self.guiJiSelect = @"YES";
    self.biaoJiSelect = @"YES";
    self.cameraSelect = @"YES";
    self.jiLuSelct = @"YES";
    
    ZEBLog(@"----%@",self.mapView.annotations);
    [self.mapView removeAnnotations:self.tempAnnontationArray];
    [self.tempAnnontationArray removeAllObjects];
    
    if ([dic[taskId] isEqualToString:chooseAll]) {
        self.workId = chooseAll;
        [self.tempAnnontationArray addObjectsFromArray:self.taskAnnotationsArray];
    }else {
        self.workId = dic[taskId];
        self.workName = dic[taskName];
        [self.tempAnnontationArray addObjectsFromArray:[self.pointAllDictionarg objectForKey:self.workId]];
    }
    
    [self getSoureAnnontation];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
#pragma mark - MAMapViewDelegate
//当位置改变时候调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    self.currentUL = userLocation;//设置当前位置
    //updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
    if (self.isLocation) {
        if (updatingLocation == YES) {
            [self.mapView setCenterCoordinate:self.currentUL.coordinate animated:YES];
            //手机位置信息
            [self setPointArrWithCurrentUserLocation:@"0"];
        }
    }
    if (self.isFirist) {
        [self.mapView setCenterCoordinate:self.currentUL.coordinate animated:YES];
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
//画线方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MinePolyline class]]) {
        MinePolyline *polyline = (MinePolyline *)overlay;
        MinePolylineRenderer *polylineRenderer = [[MinePolylineRenderer alloc] initWithPolyline:polyline];
        polyline.polylineRenderer = polylineRenderer;
        return polylineRenderer;
        
    }else if ([overlay isKindOfClass:[OthersPolyline class]]) {
        OthersPolyline *polyline = (OthersPolyline *)overlay;
        OthersPolylineRenderer *polylineRenderer = [[OthersPolylineRenderer alloc] initWithPolyline:polyline];
        polyline.polylineRenderer = polylineRenderer;
        return polylineRenderer;
    }
    return nil;
}
//大头针属性设置
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    // 返回nil,意味着交给系统处理
    if ([annotation isKindOfClass:[ZAnnotation class]])
    {
        ZAnnotation *annotation1 = (ZAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation1 reuseIdentifier:pointReuseIndentifier];
            annotationView.userInteractionEnabled=YES;
            annotationView.canShowCallout = NO;
        }
        annotationView.aannotation = annotation1;
        //设置背景图片
        annotationView.image = [ChatBusiness getZAnnotationIcon:annotation1.My_type direction:annotation1.direction type:annotation1.type];
        
        return annotationView;
    }else if ([annotation isKindOfClass:[PAnnotation class]]) {
        
        PAnnotation *annotation1 = (PAnnotation *)annotation;
        
        static NSString *pointReuseIndentifier = @"memberAnnotationView";
        MemberAnnotationView *annotationView = (MemberAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MemberAnnotationView alloc] initWithAnnotation:annotation1 reuseIdentifier:pointReuseIndentifier];
            annotationView.userInteractionEnabled=YES;
            annotationView.canShowCallout = NO;
        }
        annotationView.aannotation = annotation1;
        
        return annotationView;
        
    }else if ([annotation isKindOfClass:[StartAnnotation class]]) {
        
        StartAnnotation *annotation1 = (StartAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"StartAnnotationView";
        StartPathAnnotationView *annotationView = (StartPathAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[StartPathAnnotationView alloc] initWithAnnotation:annotation1 reuseIdentifier:pointReuseIndentifier];
            annotationView.canShowCallout = NO;
           
        }
        if (annotation1.isBig) {
            if ([self isMeAlarm:annotation1.alarm]) {
                annotationView.image = [UIImage imageNamed:@"startpath_organ1.3"];
            }else {
                annotationView.image = [UIImage imageNamed:@"startpath_blue1.3"];
            }
        }else {
            if ([self isMeAlarm:annotation1.alarm]) {
                annotationView.image = [UIImage imageNamed:@"startpath_organ"];
            }else {
                annotationView.image = [UIImage imageNamed:@"startpath_blue"];
            }
        }
        
        annotationView.aannotation = annotation1;
        annotation1.startPathAnnotationView = annotationView;
        return annotationView;
    }else if ([annotation isKindOfClass:[StopAnnotation class]]) {
        
        StopAnnotation *annotation1 = (StopAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"StopAnnotationView";
        StopPathAnnotationView *annotationView = (StopPathAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[StopPathAnnotationView alloc] initWithAnnotation:annotation1 reuseIdentifier:pointReuseIndentifier];
            annotationView.canShowCallout = NO;
        }
        if (annotation1.isBig) {
            if ([self isMeAlarm:annotation1.alarm]) {
                annotationView.image = [UIImage imageNamed:@"stoppath_organ1.3"];
            }else {
                annotationView.image = [UIImage imageNamed:@"stoppath_blue1.3"];
            }
        }else {
            if ([self isMeAlarm:annotation1.alarm]) {
                annotationView.image = [UIImage imageNamed:@"stoppath_organ"];
            }else {
                annotationView.image = [UIImage imageNamed:@"stoppath_blue"];
            }
        }
        annotationView.aannotation = annotation1;
        annotation1.stopPathAnnotationView = annotationView;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *)view;
        [self.mapView setCenterCoordinate:annotationView.aannotation.coordinate animated:YES];
    }else if ([view isKindOfClass:[MemberAnnotationView class]]) {
        MemberAnnotationView *annotationView = (MemberAnnotationView *)view;
        [self.mapView setCenterCoordinate:annotationView.aannotation.coordinate animated:YES];
    }else if ([view isKindOfClass:[StartPathAnnotationView class]]) {
        [self reductionLastPolylineRendererAndLastAnnotationView];
        StartPathAnnotationView *startPathAnnotationView = (StartPathAnnotationView *)view;
        StopPathAnnotationView *stopPathAnnotationView = [self getsstopAnnotationForPolylineId:startPathAnnotationView.aannotation.polylineID].stopPathAnnotationView;
        UIImage *image1 = nil;
        UIImage *image2 = nil;
        if ([self isMeAlarm:startPathAnnotationView.aannotation.alarm]) {
            image1 = [UIImage imageNamed:@"startpath_organ1.3"];
        }else {
            image1 = [UIImage imageNamed:@"startpath_blue1.3"];
        }
        if ([self isMeAlarm:startPathAnnotationView.aannotation.alarm]) {
            image2 = [UIImage imageNamed:@"stoppath_organ1.3"];
        }else {
            image2 = [UIImage imageNamed:@"stoppath_blue1.3"];
        }
        startPathAnnotationView.image = image1;
        stopPathAnnotationView.image = image2;
        startPathAnnotationView.aannotation.isBig = YES;
        stopPathAnnotationView.aannotation.isBig = YES;
        self.lastStartPathAnnotationView = startPathAnnotationView;
        self.lastStopPathAnnotationView = stopPathAnnotationView;
        MAPolyline *thePolyline = [self getPolylineInPathArrayForPolylineId:startPathAnnotationView.aannotation.polylineID];
        if ([thePolyline isKindOfClass:[MinePolyline class]]) {
            MinePolyline *minePolyline = (MinePolyline *)thePolyline;
            minePolyline.polylineRenderer.lineWidth = 8*1.3;
            self.lastPolylineRenderer = minePolyline.polylineRenderer;
        }else if ([thePolyline isKindOfClass:[OthersPolyline class]]) {
            OthersPolyline *othersPolyline = (OthersPolyline *)thePolyline;
            othersPolyline.polylineRenderer.lineWidth = 8*1.3;
            self.lastPolylineRenderer = othersPolyline.polylineRenderer;
        }
        NSArray *arr = @[startPathAnnotationView.aannotation,stopPathAnnotationView.aannotation];
        [self.mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(200, 50, 200, 50) animated:YES];
    }else if ([view isKindOfClass:[StopPathAnnotationView class]]) {
        [self reductionLastPolylineRendererAndLastAnnotationView];
        StopPathAnnotationView *stopPathAnnotationView = (StopPathAnnotationView *)view;
        StartPathAnnotationView *startPathAnnotationView = [self getstartAnnotationForPolylineId:stopPathAnnotationView.aannotation.polylineID].startPathAnnotationView;
        UIImage *image1 = nil;
        UIImage *image2 = nil;
        if ([self isMeAlarm:startPathAnnotationView.aannotation.alarm]) {
            image1 = [UIImage imageNamed:@"startpath_organ1.3"];
        }else {
            image1 = [UIImage imageNamed:@"startpath_blue1.3"];
        }
        if ([self isMeAlarm:startPathAnnotationView.aannotation.alarm]) {
            image2 = [UIImage imageNamed:@"stoppath_organ1.3"];
        }else {
            image2 = [UIImage imageNamed:@"stoppath_blue1.3"];
        }
        stopPathAnnotationView.image = image2;
        startPathAnnotationView.image = image1;
        startPathAnnotationView.aannotation.isBig = YES;
        stopPathAnnotationView.aannotation.isBig = YES;
        self.lastStopPathAnnotationView = stopPathAnnotationView;
        self.lastStartPathAnnotationView = startPathAnnotationView;
        MAPolyline *thePolyline = [self getPolylineInPathArrayForPolylineId:stopPathAnnotationView.aannotation.polylineID];
        if ([thePolyline isKindOfClass:[MinePolyline class]]) {
            MinePolyline *minePolyline = (MinePolyline *)thePolyline;
            minePolyline.polylineRenderer.lineWidth = 8*1.3;
            self.lastPolylineRenderer = minePolyline.polylineRenderer;
        }else if ([thePolyline isKindOfClass:[OthersPolyline class]]) {
            OthersPolyline *othersPolyline = (OthersPolyline *)thePolyline;
            othersPolyline.polylineRenderer.lineWidth = 8*1.3;
            self.lastPolylineRenderer = othersPolyline.polylineRenderer;
        }
        NSArray *arr = @[startPathAnnotationView.aannotation,stopPathAnnotationView.aannotation];
        [self.mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(200, 50, 200, 50) animated:YES];
    }
}
// 还原标记
- (void)reductionLastPolylineRendererAndLastAnnotationView {
    
    UIImage *image1 = nil;
    UIImage *image2 = nil;
    if ([self isMeAlarm:self.lastStartPathAnnotationView.aannotation.alarm]) {
        image1 = [UIImage imageNamed:@"startpath_organ"];
    }else {
        image1 = [UIImage imageNamed:@"startpath_blue"];
    }
    if ([self isMeAlarm:self.lastStopPathAnnotationView.aannotation.alarm]) {
        image2 = [UIImage imageNamed:@"stoppath_organ"];
    }else {
        image2 = [UIImage imageNamed:@"stoppath_blue"];
    }
    
    self.lastStartPathAnnotationView.image = image1;
    self.lastStopPathAnnotationView.image = image2;
    
    self.lastStopPathAnnotationView.aannotation.isBig = NO;
    self.lastStartPathAnnotationView.aannotation.isBig = NO;
    
    self.lastPolylineRenderer.lineWidth = 8;
}
- (MAPolyline *)getPolylineInPathArrayForPolylineId:(NSString *)polylineId {
    
    MAPolyline *tempPolyline = nil;
    for (MAPolyline *polyline in self.pathArray) {
        if ([polyline isKindOfClass:[MinePolyline class]]) {
            MinePolyline *minePolyline = (MinePolyline *)polyline;
            if ([minePolyline.polylineId isEqualToString:polylineId]) {
                tempPolyline = polyline;
                break;
            }
        }else if ([polyline isKindOfClass:[OthersPolyline class]]) {
            OthersPolyline *othersPolyline = (OthersPolyline *)polyline;
            if ([othersPolyline.polylineId isEqualToString:polylineId]) {
                tempPolyline = polyline;
                break;
            }
        }
    }
    return tempPolyline;
}
- (StartAnnotation *)getstartAnnotationForPolylineId:(NSString *)polylineId {
    
    StartAnnotation *tempAnnotation = nil;
    for (StartAnnotation *annotation in self.startPathArr) {
        if ([annotation.polylineID isEqualToString:polylineId]) {
            tempAnnotation = annotation;
            break;
        }
    }
    return tempAnnotation;
}
- (StopAnnotation *)getsstopAnnotationForPolylineId:(NSString *)polylineId {
    
    StopAnnotation *tempAnnotation = nil;
    for (StopAnnotation *annotation in self.stopPathArr) {
        if ([annotation.polylineID isEqualToString:polylineId]) {
            tempAnnotation = annotation;
            break;
        }
    }
    return tempAnnotation;
}
#pragma mark -
#pragma mark 添加标记
//- (void)addMAPointAnnotation {
//
//    NSMutableArray *MAPointAnnotations = [NSMutableArray array];
//    for (LinesignModel *linesignModel in self.linesignArray) {
//        UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:linesignModel.SG_alarm];
//
//        ZAnnotation *pointAnnotation = [[ZAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake([linesignModel.SG_gps_w doubleValue], [linesignModel.SG_gps_h doubleValue]);
//        pointAnnotation.title = linesignModel.SG_title;
//        pointAnnotation.subtitle = linesignModel.SG_content;
//        pointAnnotation.name = model.RE_name;
//        pointAnnotation.time = linesignModel.SG_signtime;
//        pointAnnotation.type = linesignModel.SG_type;
//        pointAnnotation.direction = linesignModel.SG_camera_direction;
//        pointAnnotation.alarm = linesignModel.SG_alarm;
//        pointAnnotation.My_type = @"1";
//        [MAPointAnnotations addObject:pointAnnotation];
//        [self.linesignAnnotationArray addObject:pointAnnotation];
//    }
//    for (IntersignModel *intersignModel in self.intersignArray) {
//
//        UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:intersignModel.alarm];
//
//        ZAnnotation *pointAnnotation = [[ZAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake([intersignModel.gps_w doubleValue], [intersignModel.gps_h doubleValue]);
//        pointAnnotation.title = intersignModel.title;
//        pointAnnotation.subtitle = intersignModel.content;
//        pointAnnotation.name = model.RE_name;
//        pointAnnotation.time = intersignModel.creattime;
//        pointAnnotation.type = intersignModel.type;
//        pointAnnotation.alarm = intersignModel.alarm;
//        pointAnnotation.My_type = @"0";
//        [MAPointAnnotations addObject:pointAnnotation];
//        [self.intersignAnnotationArray addObject:pointAnnotation];
//    }
//    for (InterinfoModel *interinfoModel in self.interinfoArray) {
//
//        UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:interinfoModel.alarm];
//
//        ZAnnotation *pointAnnotation = [[ZAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake([interinfoModel.gps_w doubleValue], [interinfoModel.gps_h doubleValue]);
//        pointAnnotation.title = interinfoModel.title;
//        pointAnnotation.subtitle = interinfoModel.content;
//        pointAnnotation.name = model.RE_name;
//        pointAnnotation.My_type = @"2";
//        pointAnnotation.time = interinfoModel.creattime;
//        pointAnnotation.alarm = interinfoModel.alarm;
//        [MAPointAnnotations addObject:pointAnnotation];
//        [self.interinfoAnnotationArray addObject:pointAnnotation];
//    }
//    for (TrackinfoModel *trackinfoModel in self.trackinfoArray) {
//
//        UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:trackinfoModel.alarm];
//
//        ZAnnotation *pointAnnotation = [[ZAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake([trackinfoModel.gps_w doubleValue], [trackinfoModel.gps_h doubleValue]);
//        pointAnnotation.title = trackinfoModel.title;
//        pointAnnotation.subtitle =trackinfoModel.content;
//        pointAnnotation.name = model.RE_name;
//        pointAnnotation.time = trackinfoModel.creattime;
//        pointAnnotation.My_type = @"2";
//        pointAnnotation.alarm = trackinfoModel.alarm;
//        [MAPointAnnotations addObject:pointAnnotation];
//        [self.trackinfoAnnotationArray addObject:pointAnnotation];
//    }
//    [self.annotationsArray addObjectsFromArray:MAPointAnnotations];
//    if (MAPointAnnotations.count != 0) {
//        [self.mapView addAnnotations:MAPointAnnotations];
//
//    }
//}
#pragma mark -
#pragma mark 获取群组任务信息
- (void)httpGetworkbygroup {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
    // NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:GetworkbygroupUrl,chatId,alarm,token];
    
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        SuspectBaseModel *baseModel = [SuspectBaseModel getInfoWithData:response];
        [self.taskAllArray addObjectsFromArray:baseModel.results];
        [self httpGetMapAnnotation];
        
    } fail:^(NSError *error) {
        [self getTaskAllDataSoureFromDB];
    }];
    
}
- (void)getTaskAllDataSoureFromDB {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    [self.taskAllArray addObjectsFromArray:[[[DBManager sharedManager] suspectAlllistSQ]  selectSuspectlistByGid:chatId]];
    [self httpGetMapAnnotation];
}
#pragma mark -
#pragma mark 获取地图信息
- (void)httpGetMapAnnotation {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    NSString *urlString = [NSString stringWithFormat:GetAllMapAnnotationUrl,alarm,alarm,chatId,token];
    
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        GetrecordByGroupBaseModel *baseModel = [GetrecordByGroupBaseModel getInfoWithData:response];
        [[[DBManager sharedManager] taskMarkSQ] transactionInsertTaskMark:baseModel.results];
        [self.taskAllMarkArray addObjectsFromArray:baseModel.results];
        //        MapAnnotationBaseModel *baseModel = [MapAnnotationBaseModel getInfoWithData:response[@"response"]];
        //        [self.intersignArray addObjectsFromArray:baseModel.intersignModel];
        //        [self.interinfoArray addObjectsFromArray:baseModel.interinfoModel];
        //        [self.linesignArray addObjectsFromArray:baseModel.linesignModel];
        //        [self.trackinfoArray addObjectsFromArray:baseModel.trackinfoModel];
        [self addAllAnnotations];
        [self getSoureAllAnnotation];
    } fail:^(NSError *error) {
        [self getTaskAllMarkDataSoureFromDB];
    }];
    
}
- (void)getTaskAllMarkDataSoureFromDB {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    [self.taskAllMarkArray addObjectsFromArray:[[[DBManager sharedManager] taskMarkSQ]  selectTaskMarkByGid:chatId]];
    [self addAllAnnotations];
    [self getSoureAllAnnotation];
}

-(SuspectModel *)configSuspectModelFormSuspectlistModel:(SuspectlistModel*)model
{
    SuspectModel *sModel = [[SuspectModel alloc] init];
    sModel.workid = model.suspectid;
    sModel.suspectname = model.suspectname;
    return sModel;
    
}
- (void)getSoureAllAnnotation {
    
    NSInteger markCount = self.taskAllMarkArray.count;
    NSInteger annCount = self.taskAnnotationsArray.count;
    NSInteger taskCount = self.taskAllArray.count;
    //将
    for (int i = 0; i < taskCount; i++) {
        //        SuspectModel *sModel = self.taskAllArray[i];
        SuspectModel *sModel;
        
        
        if ([self.taskAllArray[i] isKindOfClass:[SuspectModel class]]) {
            sModel = self.taskAllArray[i];
        }
        else if ([self.taskAllArray[i] isKindOfClass:[SuspectlistModel class]]) {
            SuspectlistModel *model = [[SuspectlistModel alloc] init];
            model = self.taskAllArray[i];
            sModel = [self configSuspectModelFormSuspectlistModel:model];
        }
        
        NSMutableArray *taskArr = [NSMutableArray array];
        NSMutableArray *pointAry = [NSMutableArray array];
        for (int j = 0; j < markCount; j++) {
            GetrecordByGroupModel *taskModel = self.taskAllMarkArray[j];
            ZAnnotation *pointAnnotation = self.taskAnnotationsArray[j];
            if ([sModel.workid isEqualToString:taskModel.workid]) {
                [taskArr addObject:taskModel];
                [pointAry addObject:pointAnnotation];
            }
        }
        [self.taskAllDictionarg setObject:taskArr forKey:sModel.workid];
        [self.pointAllDictionarg setObject:pointAry forKey:sModel.workid];
    }
    
}
- (void)getSoureAnnontation {
    
    [self.intersignAnnotationArray removeAllObjects];
    [self.interinfoAnnotationArray removeAllObjects];
    [self.linesignAnnotationArray removeAllObjects];
    
    NSInteger annCount = self.tempAnnontationArray.count;
    //将大头针分类
    for (int i = 0; i < annCount; i++) {
        ZAnnotation *pointAnnotation = self.tempAnnontationArray[i];
        if ([pointAnnotation.My_type isEqualToString:@"0"]) {//走访标记
            [self.intersignAnnotationArray addObject:pointAnnotation];
        }else if ([pointAnnotation.My_type isEqualToString:@"1"]) {//快速记录
            [self.interinfoAnnotationArray addObject:pointAnnotation];
        }else if ([pointAnnotation.My_type isEqualToString:@"2"]) {//摄像头标记
            [self.linesignAnnotationArray addObject:pointAnnotation];
        }
    }
    if (annCount != 0) {
        [self.mapView addAnnotations:self.tempAnnontationArray];
    }
}
#pragma mark -
#pragma mark - 添加所有标记
- (void)addAllAnnotations {
    
    NSInteger count = self.taskAllMarkArray.count;
    for (int i = 0; i < count; i++) {
        GetrecordByGroupModel *taskModel = self.taskAllMarkArray[i];
        UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:taskModel.alarm];
        
        ZAnnotation *pointAnnotation = [[ZAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([taskModel.latitude doubleValue], [taskModel.longitude doubleValue]);
        pointAnnotation.title = taskModel.title;
        pointAnnotation.subtitle =taskModel.content;
        pointAnnotation.name = model.RE_name;
        pointAnnotation.time = taskModel.create_time;
        pointAnnotation.type = taskModel.type;
        pointAnnotation.My_type = taskModel.mode;
        pointAnnotation.alarm = taskModel.alarm;
        pointAnnotation.direction = [NSString stringWithFormat:@"%@",taskModel.direction];
        pointAnnotation.workid = taskModel.workid;
        pointAnnotation.model = taskModel;
        pointAnnotation.interId = taskModel.interid;
        [self.taskAnnotationsArray addObject:pointAnnotation];
    }
    [self.tempAnnontationArray addObjectsFromArray:self.taskAnnotationsArray];
    [self getSoureAnnontation];
}
#pragma mark -
#pragma mark 添加一个标记
- (void)addOneAnnotation:(BOOL)show {
    
    UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.workAllModel.alarm];
    
    ZAnnotation *pointAnnotation = [[ZAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.workAllModel.latitude doubleValue], [self.workAllModel.longitude doubleValue]);
    pointAnnotation.title = self.workAllModel.title;
    pointAnnotation.subtitle =self.workAllModel.content;
    pointAnnotation.name = model.RE_name;
    pointAnnotation.time = self.workAllModel.create_time;
    pointAnnotation.type = self.workAllModel.type;
    pointAnnotation.My_type = self.workAllModel.mode;
    pointAnnotation.alarm = self.workAllModel.alarm;
    pointAnnotation.direction = self.workAllModel.direction;
    pointAnnotation.workid = self.workAllModel.workId;
    pointAnnotation.model = self.workAllModel;
    pointAnnotation.interId = self.workAllModel.interid;
    [self.mapView addAnnotation:pointAnnotation];
    
    [self.taskAnnotationsArray addObject:pointAnnotation];
    [self.tempAnnontationArray addObject:pointAnnotation];
    
    if ([self.workAllModel.mode isEqualToString:@"0"]) {//走访标记
        [self.intersignAnnotationArray addObject:pointAnnotation];
    }else if ([self.workAllModel.mode isEqualToString:@"1"]) {//快速记录
        [self.interinfoAnnotationArray addObject:pointAnnotation];
    }else if ([self.workAllModel.mode isEqualToString:@"2"]) {//摄像头标记
        [self.linesignAnnotationArray addObject:pointAnnotation];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithObject:pointAnnotation];
    if (self.workAllModel.workId) {
        NSMutableArray *temp = [self.pointAllDictionarg objectForKey:self.workAllModel.workId];
        if (temp.count != 0) {
            [arr addObjectsFromArray:temp];
        }
        [self.pointAllDictionarg setObject:arr forKey:self.workAllModel.workId];
    }
    
    if (show) {
        
        [self.mapView selectAnnotation:pointAnnotation animated:YES];
        // [self.mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"1"];
    }
}
#pragma mark - set point and draw lines
//设置数组元素并且去执行画线操作
- (void)setPointArrWithCurrentUserLocation:(NSString *)type {
    
    //检查零点
    if (_currentUL.location.coordinate.latitude == 0.0f ||
        _currentUL.location.coordinate.longitude == 0.0f)
        return;
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    point.coordinate = _currentUL.location.coordinate;
    point.type = type;
    point.time = [LZXHelper getNowTime];
    //    __block typeof(point) weakPoint = point;
    //    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
    //        [[XMLocationManager shareManager] reverseGeocodeWithCoordinate2D:point.coordinate success:^(NSArray *pois) {
    //            if (pois && pois.count > 0) {
    //                CLPlacemark *position = pois[0];
    //                ZEBLog(@"CLPlacemark:%@",position);
    //
    //                weakPoint.posi = position.addressDictionary[@"FormattedAddressLines"];
    //                //            ZEBLog(@"location:%@",position.addressDictionary[@"Name"]);
    //                //            [position separatedByAtAndComma];
    //
    //            }else {
    //                weakPoint.posi = @"";
    //            }
    //        } failure:^{
    //            weakPoint.posi = @"";
    //        }];
    //    }
    
    //    ZEBLog(@"location:%@",point.posi);
    //            [position separatedByAtAndComma];
    
    [self.pointArr addObject:point];
    ZEBLog(@"point.type-----%@-----point.time------%@,%@",point.type,point.time,point.posi);
    //画线
    [self drawTrackingLine];
}

//绘制旅行路线
- (void)drawTrackingLine {
    
    NSInteger count = self.pointArr.count;
    
    MAMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) * count);//创建一个结构体数组
    
    for(int index = 0; index < count; index++) {
        MAPointAnnotation *locationUser = [self.pointArr objectAtIndex:index];
        MAMapPoint point = MAMapPointForCoordinate(locationUser.coordinate);
        pointArray[index] = point;
    }
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    self.routeLine = [MinePolyline polylineWithPoints:pointArray count:count];
    if (nil != self.routeLine) {
        //将折线绘制在地图底图标注和兴趣点图标之下
        [self.mapView addOverlay:self.routeLine];
    }
    free(pointArray);
}

- (void)httpGettrailbywork {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:MapGettrailbywork,alarm,self.workId,token];
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark -
#pragma mark 添加成员
- (void)addMember:(NSNotification *)notification {
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:notification.object];
    
    NSMutableArray *MAPointAnnotations = [NSMutableArray array];
    NSInteger count = array.count;
    for (int i = 0;i < count; i++) {
        ChatMapModel *model = array[i];
        if (![[LZXHelper isNullToString:model.gps_h] isEqualToString:@""] && ![model.gps_h isEqualToString:@"0.0"]) {
            PAnnotation *pointAnnotation = [[PAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.gps_w doubleValue], [model.gps_h doubleValue]);
            pointAnnotation.bgIcon = [ZEBCache imageCacheAlarm:model.alarm];
            pointAnnotation.alarm = model.alarm;
            [MAPointAnnotations addObject:pointAnnotation];
        }
    }
    if (MAPointAnnotations.count != 0) {
        [self.annotationsArray addObjectsFromArray:MAPointAnnotations];
        [self.mapView addAnnotations:MAPointAnnotations];
    }
    
}

#pragma mark -
#pragma mark 展示某一成员
- (void)showMember:(NSNotification *)notification {
    ChatMapModel *model = notification.object;
    if (self.annotationsArray.count != 0) {
        for (id annotations in self.annotationsArray) {
            if ([annotations isKindOfClass:[PAnnotation class]]) {
                PAnnotation *annotation = (PAnnotation *)annotations;
                if ([model.alarm isEqualToString:annotation.alarm]) {
                    
                    [self.mapView selectAnnotation:annotation animated:YES];
                }
            }
            
        }
    }
    
}

#pragma mark -
#pragma mark 展示某一事件
- (void)showEvent:(NSNotification *)notification {
    
    ICometModel *icModel = notification.object;
    
    BOOL ret = NO;
    if (self.taskAnnotationsArray.count != 0) {
        for (id annotations in self.taskAnnotationsArray) {
            if ([annotations isKindOfClass:[ZAnnotation class]]) {
                ZAnnotation *annotation = (ZAnnotation *)annotations;
                if ([annotation.interId isEqualToString:icModel.markdataId]) {
                    
                    [self.mapView selectAnnotation:annotation animated:YES];
                    // [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
                    ret = YES;
                    break;
                }
            }
        }
        
        if (!ret) {
            [self BackWorkId:icModel];
            
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"1"];
        }
    }
}

- (void)clearBtnView {
    
    [_bubbleView removeFromSuperview];
    _bubbleView = nil;
    [_mapBtnBtnsView removeFromSuperview];
    _mapBtnBtnsView = nil;
}

- (NSString *)BackWorkId:(ICometModel *)iModel {
    
    NSString *workId = @"";
    if ([iModel.mtype isEqualToString:@"S"]) {//疑情
        
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        parm[@"workid"] = iModel.worId;
        
        [LYRouter openURL:@"ly://ChatMapControllerChangeTaskForWorkId" withUserInfo:parm completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"1"];
        
        
    }else if ([iModel.mtype isEqualToString:@"X"]) {;//聊天群创建侦察任务群
        
        
    }else if ([iModel.mtype isEqualToString:@"N"]) {//通知（新增记录，标记）
        [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"1"];
        GetrecordByGroupModel *gModel = [[[DBManager sharedManager] taskMarkSQ] selectTaskMarkByInterid:iModel.markdataId];
        WorkAllTempModel *wModel = [[WorkAllTempModel alloc] initWithGetrecordByGroupModel:gModel];
        self.workAllModel = wModel;
        [self addOneAnnotation:YES];
        
    }else if ([iModel.mtype isEqualToString:@"P"]) {// "P":任务发布
        
        
        
    }else if ([iModel.mtype isEqualToString:@"C"]) {//案件
        
        
        
    }else if ([iModel.mtype isEqualToString:@"T"]) {//轨迹上传提醒
        
        workId = iModel.worId;
        
        
    }else if ([iModel.mtype isEqualToString:@"F"]) {// "F":任务结束通知
        workId = iModel.worId;
        
    }else if ([iModel.mtype isEqualToString:@"A"]) {// "A":任务添加成员
        
        
    }else if ([iModel.mtype isEqualToString:@"D"]) {//删除疑情列表人员
        
        
    }else if ([iModel.mtype isEqualToString:@"AC"]){//集合消息
        
        
    }
    return workId;
}
//对按钮的操作
- (void)operationButtons:(UIButton *)btn {
    
    ZEBLog(@"intersignAnnotationArray------%@\nlinesignAnnotationArray-----%@\ninterinfoAnnotationArray-----%@",self.intersignAnnotationArray,self.linesignAnnotationArray,self.interinfoAnnotationArray);
    if ([btn.my_type isEqualToString:@"0"]) {
        [self dismiss];
    }
    switch ([btn.type integerValue]) {/*
                                       01->人脸识别 02->身份识别 03->车牌识别 04->工作表 05->纪录 06->反扒
                                       11->轨迹 12->标记 13->摄像头 14->纪录 15->更多
                                       */
        case 01:
            break;
        case 02:
            break;
        case 03:
            break;
        case 04:
        {
            if ([self.workId isEqualToString:chooseAll]) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHudNotfication" object:@"请选择任务"];
                [LYRouter openURL:@"ly://ChatMapViewWorkListsViewController" completion:^(id result) {
                    
                }];
            }else {
                [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://%@?workId=%@",btn.format,self.workId] animated:YES replace:NO];
                
            }
        }
            break;
        case 05:
        {
            [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://draftsViewController"] animated:YES replace:NO];
            
            //            DraftsViewController *draftsVC =[[DraftsViewController alloc] init];
            //            [self.navigationController pushViewController:draftsVC animated:YES];
        }
            break;
        case 06:
        {
            //            [LYRouter openURL:@"ly://ChatMapPhysicsViewController" completion:^(id result) {
            //
            //            }];
            [self PopTrackPageWithEditType:1 WithFromWhere:0];
            //            NSDictionary *dict = @{@"editType":@(0),@"fromWhere":@(0)};
            //            [LYRouter openURL:@"ly://ChatMapPhysicsViewController" withUserInfo:dict completion:^(id result) {
            //
            //            }];
            //
            //            [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://PhysicsViewController"]query:dict animated:YES];
        }
            break;
        case 11:
            self.guiJiSelect = [NSString stringWithFormat:@"%d",![self.guiJiSelect boolValue]];
            if (![self.guiJiSelect boolValue]) {
                
            }else {
                
            }
            break;
        case 12:
            self.biaoJiSelect = [NSString stringWithFormat:@"%d",![self.biaoJiSelect boolValue]];
            
            if (![self.biaoJiSelect boolValue]) {
                [self.mapView removeAnnotations:self.intersignAnnotationArray];
            }else {
                [self.mapView addAnnotations:self.intersignAnnotationArray];
            }
            break;
        case 13:
            self.cameraSelect = [NSString stringWithFormat:@"%d",![self.cameraSelect boolValue]];
            if (![self.cameraSelect boolValue]) {
                [self.mapView removeAnnotations:self.linesignAnnotationArray];
            }else {
                [self.mapView addAnnotations:self.linesignAnnotationArray];
            }
            break;
        case 14:
            self.jiLuSelct = [NSString stringWithFormat:@"%d",![self.jiLuSelct boolValue]];
            if (![self.jiLuSelct boolValue]) {
                [self.mapView removeAnnotations:self.interinfoAnnotationArray];
            }else {
                [self.mapView addAnnotations:self.interinfoAnnotationArray];
            }
            break;
        case 15:
            
            break;
        default:
            break;
    }
}

#pragma mark - 调起轨迹页面

- (void)PopTrackPageWithEditType:(NSInteger)editType WithFromWhere:(NSInteger)frompage {
    
    NSDictionary *dict = @{@"editType":@(editType),@"fromWhere":@(frompage),@"pointInfo":self.pointArr};
    [LYRouter openURL:@"ly://ChatMapPhysicsViewController" withUserInfo:dict completion:^(id result) {
        
    }];
}


#pragma mark -
#pragma mark 轨迹起点
- (void)addStartMapPath {
    NSString *myaAlarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    _startAnnotation = [[StartAnnotation alloc] init];
    _startAnnotation.coordinate = self.currentUL.coordinate;
    _startAnnotation.alarm = myaAlarm;
    [self.mapView addAnnotation:_startAnnotation];
}
#pragma mark -
#pragma mark 轨迹终点
- (void)addStopMapPath {
    
    NSString *myaAlarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    _stopAnnotation = [[StopAnnotation alloc] init];
    _stopAnnotation.coordinate = self.currentUL.coordinate;
    _stopAnnotation.alarm = myaAlarm;
    [self.mapView addAnnotation:_stopAnnotation];
}

#pragma mark -
#pragma mark 绘制轨迹数组
- (void)addAllPath {
    
    NSInteger count = self.selectPathArray.count;
    for (int i = 0; i < count; i++) {
        GetPathModel *model = self.selectPathArray[i];
        [self setPointArrWithAllLocation:model.location_list alarm:model.alarm polylineId:model.route_id];
    }
    [self.mapView addOverlays:self.pathArray];
    [self.mapView addAnnotations:self.startPathArr];
    [self.mapView addAnnotations:self.stopPathArr];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:self.startPathArr];
    [arr addObjectsFromArray:self.stopPathArr];
    [self.mapView showAnnotations:arr animated:YES];
}
//设置数组元素并且去执行画线操作
- (void)setPointArrWithAllLocation:(NSArray *)location_list alarm:(NSString *)alarm polylineId:(NSString *)polylineId {
    
    [self.tempPathArray removeAllObjects];
    NSInteger listCount = location_list.count;
    
    for (int i = 0; i < listCount; i++) {
        GetPathLocationModel *locationModel = location_list[i];
        //检查零点
        //        if ([locationModel.latitude doubleValue] == 0.0f ||
        //            [locationModel.longitude doubleValue] == 0.0f)
        //            return;
        MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake([locationModel.latitude doubleValue], [locationModel.longitude doubleValue]);
        point.time = locationModel.time;
        point.type = locationModel.type;
        [self.tempPathArray addObject:point];
        if ([point.type isEqualToString:@"1"]) {
            [self addAllStartMapPath:point.coordinate polylineId:polylineId alarm:alarm];
        }else if ([point.type isEqualToString:@"2"]) {
            [self addAllStopMapPath:point.coordinate polylineId:polylineId alarm:alarm];
        }
    }
    
    //画线
    [self drawAllTrackingLine:[self isMeAlarm:alarm] polylineId:polylineId];
}

//绘制路线
- (void)drawAllTrackingLine:(BOOL)me polylineId:(NSString *)polylineId {
    
    NSInteger count = self.tempPathArray.count;
    
    MAMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) * count);//创建一个结构体数组
    for(int index = 0; index < count; index++) {
        MAPointAnnotation *location = [self.tempPathArray objectAtIndex:index];
        MAMapPoint point = MAMapPointForCoordinate(location.coordinate);
        pointArray[index] = point;
    }
    if (me) {
        MinePolyline *polyline = [MinePolyline polylineWithPoints:pointArray count:count];
        polyline.polylineId = polylineId;
        [self.pathArray addObject:polyline];
    }else {
        OthersPolyline *polyline = [OthersPolyline polylineWithPoints:pointArray count:count];
        polyline.polylineId = polylineId;
        [self.pathArray addObject:polyline];
    }
    
    free(pointArray);
}
// 添加起点
- (void)addAllStartMapPath:(CLLocationCoordinate2D)coordinate polylineId:(NSString *)polylineId alarm:(NSString *)alarm {
    StartAnnotation *startAnnotation = [[StartAnnotation alloc] init];
    startAnnotation.coordinate = coordinate;
    startAnnotation.polylineID = polylineId;
    startAnnotation.alarm = alarm;
    [self.startPathArr addObject:startAnnotation];
}
// 添加终点
- (void)addAllStopMapPath:(CLLocationCoordinate2D)coordinate polylineId:(NSString *)polylineId alarm:(NSString *)alarm {
    StopAnnotation *stopAnnotation = [[StopAnnotation alloc] init];
    stopAnnotation.coordinate = coordinate;
    stopAnnotation.polylineID = polylineId;
    stopAnnotation.alarm = alarm;
    [self.stopPathArr addObject:stopAnnotation];
}
#pragma mark -
#pragma mark 判断是否是自己
- (BOOL)isMeAlarm:(NSString *)alarm {
    
    BOOL ret = NO;
    NSString *myaAlarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([myaAlarm isEqualToString:alarm]) {
        ret = YES;
    }
    return ret;
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
