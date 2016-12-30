//
//  WorkDesViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkDesViewController.h"
#import "MapAnnotationBaseModel.h"
#import "WorkListTableViewCell.h"
#import "WorkTimeTabelHeaderView.h"
//将所有的工作统一
#import "WorkAllTempBaseModel.h"
#import "WorkDesRightView.h"
#import "IDMPhotoBrowser.h"
#import "VideoViewController.h"
#import "RecordDesViewController.h"

@interface WorkDesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableDictionary *dateDic;
@property (nonatomic, strong) WorkDesRightView *workDesRightView;


@end

@implementation WorkDesViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"工作列表";
    
    self.workId = self.params[@"workId"];
    
    [self initall];
}
- (void)initall {
    [self createTableView];
    //[self initOverlayView];
    [self initNotificationCenter];
}
- (void)initOverlayView {
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.2;
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}
- (void)dismiss {
    [self.overlayView removeFromSuperview];
   // [self workDesRightViewdismiss];
}
- (void)initNotificationCenter {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImages:) name:@"showImagesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:) name:@"playVideoNotification" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableDictionary *)dateDic {
    if (_dateDic == nil) {
        _dateDic = [NSMutableDictionary dictionary];
    }
    return _dateDic;
}
- (void)setWorkId:(NSString *)workId {
    _workId = workId;
    [self httpGetMapAnnotation];
}
#pragma mark -
#pragma mark 群任务列表
- (void)httpGetMapAnnotation {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    // NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:GetMapAnnotationUrl,alarm,self.workId,token];
    
    [self showloadingName:@"正在加载"];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        WorkAllTempBaseModel *baseModel = [WorkAllTempBaseModel getInfoWithData:response];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WorkAllTempModel *mdoel in baseModel.results) {
            mdoel.workId = self.workId;
            [tempArray addObject:mdoel];
        }
        //以下废弃
//        MapAnnotationBaseModel *baseModel = [MapAnnotationBaseModel getInfoWithData:response[@"response"]];
//        NSMutableArray *tempArray = [NSMutableArray array];
//        for (IntersignModel *model in baseModel.intersignModel) {
//            WorkAllTempModel *allModel = [[WorkAllTempModel alloc] init];
//            allModel.alarm = model.alarm;
//            allModel.audio = model.audio;
//            allModel.camera_direction = model.camera_direction;
//            allModel.camera_id = model.camera_id;
//            allModel.content = model.content;
//            allModel.creattime = model.creattime;
//            allModel.gid = model.gid;
//            allModel.gps_h = model.gps_h;
//            allModel.gps_w = model.gps_w;
//            allModel.picture = model.picture;
//            allModel.posi = model.posi;
//            allModel.remote_id = model.remote_id;
//            allModel.title = model.title;
//            allModel.type = model.type;
//            allModel.video = model.video;
//            allModel.workid = model.workid;
//            allModel.interid = @"";
//            allModel.position = @"";
//            allModel.pushtime = @"";
//            allModel.my_type = @"0";
//            [tempArray addObject:allModel];
//        }
//        for (InterinfoModel *model in baseModel.interinfoModel) {
//            WorkAllTempModel *allModel = [[WorkAllTempModel alloc] init];
//            allModel.alarm = model.alarm;
//            allModel.audio = model.audio;
//            allModel.camera_direction = @"";
//            allModel.camera_id = @"";
//            allModel.content = model.content;
//            allModel.creattime = model.creattime;
//            allModel.gid = model.gid;
//            allModel.gps_h = model.gps_h;
//            allModel.gps_w = model.gps_w;
//            allModel.picture = model.picture;
//            allModel.posi = @"";
//            allModel.remote_id = @"";
//            allModel.title = model.title;
//            allModel.type = @"";
//            allModel.video = model.video;
//            allModel.workid = model.workid;
//            allModel.interid = model.interid;
//            allModel.position = model.position;
//            allModel.pushtime = model.pushtime;
//            allModel.my_type = @"2";
//            [tempArray addObject:allModel];
//        }
//        for (LinesignModel *model in baseModel.linesignModel) {
//            WorkAllTempModel *allModel = [[WorkAllTempModel alloc] init];
//            allModel.alarm = model.SG_alarm;
//            allModel.audio = model.SG_audio;
//            allModel.camera_direction = model.SG_camera_direction;
//            allModel.camera_id = model.SG_camera_id;
//            allModel.content = model.SG_content;
//            allModel.creattime = model.SG_signtime;
//            allModel.gid = model.SG_gid;
//            allModel.gps_h = model.SG_gps_h;
//            allModel.gps_w = model.SG_gps_w;
//            allModel.picture = model.SG_picture;
//            allModel.posi = @"";
//            allModel.remote_id = @"";
//            allModel.title = model.SG_title;
//            allModel.type = model.SG_type;
//            allModel.video = model.SG_video;
//            allModel.workid = model.SG_workid;
//            allModel.interid = @"";
//            allModel.position = model.SG_gps_position;
//            allModel.pushtime = @"";
//            allModel.my_type = @"1";
//            [tempArray addObject:allModel];
//        }
//        for (TrackinfoModel *model in baseModel.trackinfoModel) {
//            WorkAllTempModel *allModel = [[WorkAllTempModel alloc] init];
//            allModel.alarm = model.alarm;
//            allModel.audio = model.audio;
//            allModel.camera_direction = @"";
//            allModel.camera_id = @"";
//            allModel.content = model.content;
//            allModel.creattime = model.creattime;
//            allModel.gid = model.gid;
//            allModel.gps_h = model.gps_h;
//            allModel.gps_w = model.gps_w;
//            allModel.picture = model.picture;
//            allModel.posi = @"";
//            allModel.remote_id = @"";
//            allModel.title = model.title;
//            allModel.type = @"";
//            allModel.video = model.video;
//            allModel.workid = model.workid;
//            allModel.interid = model.interid;
//            allModel.position = model.position;
//            allModel.pushtime = model.pushtime;
//            allModel.my_type = @"2";
//            [tempArray addObject:allModel];
//        }
        [self soureArray:tempArray];
        [self hideHud];
    } fail:^(NSError *error) {
        
    }];
    
}
/*
 #import "LinesignModel.h"
 #import "InterinfoModel.h"
 #import "IntersignModel.h"
 #import "TrackinfoModel.h"
 */
- (void)soureArray:(NSMutableArray *)array {
    
    //将数据按照时间排序
    NSArray *results = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WorkAllTempModel *model1 = obj1;
        WorkAllTempModel *model2 = obj2;
        NSComparisonResult result = [model1.create_time compare:model2.create_time];
        return result == NSOrderedAscending;
    }];
    
    NSString *time1;
    for (WorkAllTempModel *model in results) {
        ZEBLog(@"----------%@-------%@------%@",model.picture,model.video,model.audio);
        NSString *time2 = [model.create_time componentsSeparatedByString:@" "][0];
        if (![time1 isEqualToString:time2]) {
            [self.titleArray addObject:time2];
            time1 = time2;
        }
    }
    for (int i = 0; i < self.titleArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < results.count; j++) {
            WorkAllTempModel *model = results[j];
            NSString *time2 = [model.create_time componentsSeparatedByString:@" "][0];
            if ([time2 isEqualToString:self.titleArray[i]]) {
                
                [array addObject:model];
                
            }
            if (j == self.titleArray.count-1) {
                [self.dateDic setObject:array forKey:self.titleArray[i]];
            }
        }
    }
    ZEBLog(@"%@----",self.dateDic);
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), height(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleArray.count;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString * key = self.titleArray[section];
    
    NSArray * array = self.dateDic[key];
    
    return array.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";

        WorkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[WorkListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
    NSString * key = self.titleArray[indexPath.section];
    
    NSArray * array = self.dateDic[key];
    
    cell.model = array[indexPath.row];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WorkTimeTabelHeaderView *headerView = [WorkTimeTabelHeaderView headerViewWithTableView:tableView];
    headerView.time = self.titleArray[section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * key = self.titleArray[indexPath.section];
    
    NSArray * array = self.dateDic[key];
    WorkAllTempModel *model = array[indexPath.row];
//    _workDesRightView = [[WorkDesRightView alloc] initWithFrame:CGRectMake(kScreenWidth, 64, 0, kScreenHeight-64) widthModel:model withWidth:kScreenWidth-100 block:^(WorkDesRightView *view) {
//        [self.overlayView removeFromSuperview];
//    }];
//    
//    [self.view addSubview:self.overlayView];
//    [self.view addSubview:_workDesRightView];
//    
//    [_workDesRightView show];
    RecordDesViewController *record = [[RecordDesViewController alloc] init];
    record.model = model;
    [self.navigationController pushViewController:record animated:YES];
    
}
#pragma mark -
#pragma mark 废弃
//- (void)workDesRightViewdismiss {
//    CGRect rect = _workDesRightView.frame;
//    rect.size.width = 0;
//    rect.origin.x = kScreenWidth;
//    [UIView animateWithDuration:0.3 animations:^{
//        _workDesRightView.frame = rect;
//    } completion:^(BOOL finished) {
//        
//        [_workDesRightView removeFromSuperview];
//        _workDesRightView = nil;
//    }];
//}
//#pragma mark -
//#pragma mark 展示图片
//- (void)showImages:(NSNotification *)notification {
//    
//    
//    NSDictionary *dic = notification.userInfo;
//    NSString *index = dic[@"index"];
//    NSArray *photos = dic[@"photos"];
//    NSMutableArray *ph = [NSMutableArray array];
//    for (NSString *string in photos) {
//        if (![string isEqualToString:@" "]) {
//            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:string]];
//            [ph addObject:photo];
//        }
//    }
//    
//    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:ph];
//    // IDMPhotoBrowser功能设置
//    browser.displayActionButton = NO;
//    browser.displayArrowButton = NO;
//    browser.displayCounterLabel = YES;
//    browser.displayDoneButton = NO;
//    browser.autoHideInterface = NO;
//    browser.usePopAnimation = YES;
//    browser.disableVerticalSwipe = YES;
//
////    browser.longPressGesResponse=^(UIImage *image){
////        self.image=image;
////        
////        
////        [ZEBIdentify2Code detectorQRCodeImageWithSourceImage:image isDrawWRCodeFrame:NO  completeBlock:^(NSArray *resultArray, UIImage *resultImage) {
////            
////            if (resultArray.count==0) {
////                self.array=@[@"保存到相册"];
////            }else{
////                self.array=@[@"保存到相册",@"识别二维码"];
////                self.codeStr=resultArray.firstObject;
////            }
////            CollectCopyView *collect=[[CollectCopyView alloc]initWidthName:self.array];
////            collect.delegate=self;
////            [collect show];
////            
////        }];
////        
////    };
//    // 设置初始页面
//    [browser setInitialPageIndex:[index integerValue]];
//    
//    self.modalPresentationStyle=UIModalPresentationPageSheet;
//    UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:browser];
//    
//    [self presentViewController:navigation animated:YES completion:nil];
//}
//#pragma mark -
//#pragma mark 播放视频
//- (void)playVideo:(NSNotification *)notification {
//    
//    NSString *videoPath = notification.object;
//    
//    VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:videoPath];
//    [self presentViewController:vc animated:YES completion:nil];
//    
//}
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
