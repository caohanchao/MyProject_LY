//
//  ChatMapViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatMapViewController.h"
#import "MapViewController.h"
#import "GroupDesSetingController.h"
#import "UserInfoViewController.h"
#import "UserDesInfoController.h"
#import "UIButton+EnlargeEdge.h"
#import "ChatMapBaseModel.h"
#import "ZEBBubbleView.h"
#import "SuspectlistBaseModel.h"
#import "TopTaskListView.h"
#import "WorkDesViewController.h"
#import "MapBottomView.h"
#import "MapCancelNextView.h"
#import "ChatBusiness.h"
#import "CameraDirectionView.h"
#import "CameraMarkViewController.h"
#import "RecordDesViewController.h"
#import "WorkListsViewController.h"
#import "WarningView.h"
#import "PhysicsViewController.h"
#import "SeePathViewController.h"
//#import "UIViewController+BackButtonHandler.h"

@interface ChatMapViewController () {
    //经度
    NSString *_latitude;
    //纬度
    NSString *_longitude;
}

@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, weak) UIImageView *downImageView;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, assign) XMNMessageChat messageChatType;
@property (nonatomic, strong) UIVisualEffectView * effectView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) MapViewController *map;
@property (nonatomic, strong) ZEBBubbleView *bubbleView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) TopTaskListView *topTaskListView;
@property (nonatomic, strong) NSMutableArray *taskArray;

@property (nonatomic, strong) MapBottomView *cameraView;//摄像头记录
@property (nonatomic, strong) MapBottomView *visitView;//走访记录

@property (nonatomic, assign) MARKTYPE markType;//mark类型
@property (nonatomic, assign) NSInteger signType;//摄像头类型 走访标记类型
@property (nonatomic, assign) NSInteger dircation;//摄像头方向
@property (nonatomic, copy) NSString *workId;//任务id
@property (nonatomic, copy) NSString *workName;//任务名称
@property (nonatomic, strong) MapCancelNextView *mapNextView;//下一步操作

@property (nonatomic, strong ) CameraDirectionView *cameraDirectionView;//摄像头方向view

@property (nonatomic, copy) NSString *gid;

@property (nonatomic, assign) BOOL isAddTask;

@property (nonatomic, strong)UIButton *groupBtn;

@property (nonatomic, strong) WarningView *warningView; // 提醒框
@property (nonatomic, strong) UIButton *seePathBtn; // 查看轨迹

@property (nonatomic, strong) NSMutableArray *selectPathArray; // 选中的轨迹

@end

@implementation ChatMapViewController

- (NSMutableArray *)taskArray {
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}
//注册block路由
- (void)initRoutable {
    
    __block typeof(self) mySelf = self;
    //添加摄像头标记
    [LYRouter registerURLPattern:@"ly://addcameraMark" toHandler:^(NSDictionary *routerParameters) {
        [mySelf.mapNextView dismiss];
        [mySelf.centerImageView removeFromSuperview];
        [mySelf.cameraView showIn:mySelf.view];
    }];
    
    //添加快速标记
    [LYRouter registerURLPattern:@"ly://addQuickRecordMark" toHandler:^(NSDictionary *routerParameters) {
        [LYRouter openURL:@"ly://getmapcenterCoordinate"];
        [mySelf configParamWithQuickRecordMark];
    }];
    
    //添加走访标记
    [LYRouter registerURLPattern:@"ly://addvisitMark" toHandler:^(NSDictionary *routerParameters) {
        [mySelf.mapNextView dismiss];
        [mySelf.centerImageView removeFromSuperview];
        [mySelf.visitView showIn:mySelf.view];
    }];
    //获取地图中心位置
    [LYRouter registerURLPattern:@"ly://receivecenterCoordinate" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        _latitude  = userInfo[@"latitude"];
        _longitude = userInfo[@"longitude"];
    }];
    
    
    //跳转记录详情界面
    [LYRouter registerURLPattern:@"ly://skiprecorddesviewcontroller" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        RecordDesViewController *recordDes = [[RecordDesViewController alloc] init];
        if ([userInfo[@"GetrecordByGroupModel"] isKindOfClass:[GetrecordByGroupModel class]]) {
           GetrecordByGroupModel *gModel = userInfo[@"GetrecordByGroupModel"];
            WorkAllTempModel *model = [[WorkAllTempModel alloc] initWithGetrecordByGroupModel:gModel];
            recordDes.model = model;
        }else {
            WorkAllTempModel *model = userInfo[@"GetrecordByGroupModel"];
            recordDes.model = model;
        }
        [mySelf.navigationController pushViewController:recordDes animated:YES];
        
    }];
    [LYRouter registerURLPattern:@"ly://ChatMapViewWorkListsViewController" toHandler:^(NSDictionary *routerParameters) {
        WorkListsViewController *workList = [[WorkListsViewController alloc] init];
        workList.gid = mySelf.gid;
        workList.type = 0;
        [mySelf.navigationController pushViewController:workList animated:YES];
    }];
    [LYRouter registerURLPattern:@"ly://ChatMapAddAndChangeTask" toHandler:^(NSDictionary *routerParameters) {
        //NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        //_topTaskListView = nil;
        mySelf.isAddTask = YES;
        [mySelf httpGetSuspectlist];
    }];
    //topview消失
    [LYRouter registerURLPattern:@"ly://ChatMapControllerTopdismiss" toHandler:^(NSDictionary *routerParameters) {
        [mySelf dismiss];
    }];
    [LYRouter registerURLPattern:@"ly://ChatMapControllerChangeTask" toHandler:^(NSDictionary *routerParameters) {
        [mySelf changeSelect:0];
        [mySelf changeTask:0];
    }];
    [LYRouter registerURLPattern:@"ly://ChatMapControllerChangeTaskForWorkId" toHandler:^(NSDictionary *routerParameters) {
        
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSInteger index = [mySelf getWorkIdIndex:userInfo[@"workid"]];
        [mySelf changeSelect:index];
        [mySelf changeTask:index];
    }];

    [LYRouter registerURLPattern:@"ly://showWarningView" toHandler:^(NSDictionary *routerParameters) {
        
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSString *warning = userInfo[@"warn"];
        [mySelf.warningView setWarn:warning];
        [mySelf.warningView show];
    
    }];
    [LYRouter registerURLPattern:@"ly://dissmissWarningView" toHandler:^(NSDictionary *routerParameters) {
        
        [mySelf.warningView dissmiss];
        
    }];
    //跳转轨迹
    [LYRouter registerURLPattern:@"ly://ChatMapPhysicsViewController" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        PhysicsViewController *pvc =[[PhysicsViewController alloc] init];
        pvc.gid = mySelf.gid;
        pvc.editType = [userInfo[@"editType"] integerValue];
        pvc.fromWhere = [userInfo[@"fromWhere"] integerValue];
        pvc.pointInfo = userInfo[@"pointInfo"];
        if ([mySelf.workId isEqualToString:chooseAll]) {
            mySelf.workId = @"";
        }
        if ([mySelf.workName isEqualToString:chooseAll]) {
            mySelf.workName = @"";
        }
        pvc.workInfo = @{@"workId":mySelf.workId,@"workName":mySelf.workName};
    
        [mySelf.navigationController pushViewController:pvc animated:YES];
    }];
    [LYRouter registerURLPattern:@"ly://ChatMapViewControllerGetPathList" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSMutableArray *pathlist = userInfo[@"pathlist"];
        mySelf.selectPathArray = pathlist;
    }];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    self.gid = chatId;
    self.workId = chooseAll;
    self.workName = chooseAll;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHud:) name:@"ShowHudNotfication" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberAnnotationView:) name:@"memberAnnotationViewNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMe:) name:@"GroupDeleteManMotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatGroupName:) name:RefreshGroupNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpGetGps) name:@"ChatViewRefreshMemberNotification" object:nil];
    
    [self initall];
}

- (void)deleteMe:(NSNotification *)notification {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    if ([notification.object isEqualToString:chatId]) {
        [self.groupBtn setEnabled:YES];
        [self.groupBtn setHidden:YES];
    }
    
}

- (instancetype)initWithChatType:(XMNMessageChat)messageChatType chatname:(NSString *) chatName type:(NSInteger)type {
    self = [super init];
    if (self) {
    
        self.messageChatType = messageChatType;
        self.chatterName = chatName;
        self.type = type;
        
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)showHud:(NSNotification *)notification {
    NSString *str = notification.object;
    [self showHint:str];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsChatMap];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IsChatMap];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)initall {

    [self initMapView];
    [self addSeePathBtn];
    [self.view addSubview:self.warningView];
    [self initChatView];
    [self initEffectView];
    [self initNav];
    [self httpGetGps];
    [self initRoutable];
    
    
}

- (void)addSeePathBtn {
    
    [self.view addSubview:self.seePathBtn];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((width(self.seePathBtn.frame)-20)/2, height(self.seePathBtn.frame)-20,20, 15)];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = @"看轨迹";
    titleLabel.textColor = zWhiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.seePathBtn addSubview:titleLabel];
}
- (void)initNav {

    TeamsListModel *model = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:self.gid];
    self.map.gname = model.gname;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    imageView.image = [UIImage imageNamed:@"chatmaptop"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 20, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"chatmapBack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdge:20];
    [backBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    CGFloat width = [LZXHelper textWidthFromTextString:model.gname height:height(backBtn.frame) fontSize:15];
    
    if (width>100)
    {
        width = 100;
    }
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width+(25/2)*2, height(backBtn.frame))];
    Label.center = CGPointMake(kScreen_Width/2, minY(backBtn)+height(backBtn.frame)/2);
    Label.font = ZEBFont(15);
    Label.textColor = [UIColor whiteColor];
    Label.textAlignment = NSTextAlignmentCenter;
    Label.text = model.gname;
    [self.view addSubview:Label];
    self.titleLabel = Label;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRenwu:)];
    [self.titleLabel addGestureRecognizer:tap];
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(minX(self.titleLabel)-20, minY(self.titleLabel)+2.5, 20, 20)];//指定进度轮的大小
    [aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    CGAffineTransform transform = CGAffineTransformMakeScale(.7f, .7f);
    aiv.transform = transform;
    [self.view addSubview:aiv];
    self.activityIndicatorView = aiv;
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 6)];
    downImageView.center = CGPointMake(minX(self.titleLabel)-5, midY(self.titleLabel));
    downImageView.image = [UIImage imageNamed:@"chatmap_title"];
    downImageView.hidden = YES;
    [self.view addSubview:downImageView];
    self.downImageView = downImageView;
    
    self.groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.groupBtn.frame = CGRectMake(kScreen_Width-30-15, 20, 25, 25);
    [self.groupBtn setBackgroundImage:[UIImage imageNamed:@"chatmapGroup"] forState:UIControlStateNormal];
    [self.groupBtn setEnlargeEdge:25];
    [self.groupBtn addTarget:self action:@selector(groupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.groupBtn];
    
    
}
-(void)memberAnnotationView:(NSNotification *)notification {
    
    NSString *theAlarm = notification.object;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
        
        if ([alarm isEqualToString:theAlarm]) {
            UserInfoViewController *userController = [[UserInfoViewController alloc] init];
            [self.navigationController pushViewController:userController animated:YES];
        }else {
            UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
            userDes.RE_alarmNum = theAlarm;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *chatType = [user objectForKey:@"chatType"];
           
            userDes.cType = Others;
            
            [self.navigationController pushViewController:userDes animated:YES];
        }
        
}


- (void)initChatView {
    _chatView = [[ChatView alloc] initWithFrame:CGRectMake(0, HeightC, kScreen_Width, kScreenHeight - HeightC) ChatType:self.messageChatType chatname:self.chatterName type:self.type];
    _chatView.chatController.myUIViewController = self;
    [self.view addSubview:_chatView];
}
//添加毛玻璃效果
- (void)initEffectView {

    /**  毛玻璃特效类型
     *   UIBlurEffectStyleExtraLight,
     *   UIBlurEffectStyleLight,
     *   UIBlurEffectStyleDark
     */
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    //  毛玻璃视图
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //关闭事件响应
    effectView.userInteractionEnabled = NO;
    //添加到要有毛玻璃特效的控件中
    effectView.frame = CGRectMake(0, 0, kScreenWidth, HeightC);
    effectView.alpha = 0.0;
    //[self.view addSubview:effectView];
    
    _chatView.effectView = effectView;
}
-(void)onClick
{
    if (self.map.isLocation) {
        
        [LYRouter openURL:@"ly://addPathMark" completion:^(id result) {
            
        }];

        
    } else {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableViewAndClearNewMessageCount" object:chatId];
        
        [self.navigationController popViewControllerAnimated:YES];
        if (_map) {
            [_map clearMapView];
        }
    }
    
    
    
}
- (void)groupBtnClick {
    
        GroupDesSetingController *grSetc = [[GroupDesSetingController alloc] init];
    
        grSetc.cType = self.type;
        grSetc.gid = self.gid;
        [self.navigationController pushViewController:grSetc animated:YES];
    
}

- (void)httpGetGps {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"getgps";
    params[@"gid"] = self.gid;
    params[@"token"] = token;
    params[@"alarm"] = alarm;
    
    [self.activityIndicatorView startAnimating];
    [HYBNetworking postWithUrl:GetGPSUrl refreshCache:YES params:params success:^(id response) {
        
        ChatMapBaseModel *baseModel = [ChatMapBaseModel getInfoWithData:response];
        [_chatView.groupMemberArray addObjectsFromArray:baseModel.results];
        
        //刷新cell
        [_chatView reload:baseModel.results];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (ChatMapModel *gModel in baseModel.results) {
            [tempArray addObject:gModel.alarm];
        }
        
        NSString *membersStr = [tempArray componentsJoinedByString:@","];
        
        //将群成员更新到数据库
        [[[DBManager sharedManager] GrouplistSQ] updateGroupMembers:membersStr gid:self.gid];
        [[NSNotificationCenter defaultCenter] postNotificationName:MapAddMemberNotification object:_chatView.groupMemberArray];
        [self httpGetSuspectlist];
        
    } fail:^(NSError *error) {
        [self getDataSource];
        self.titleLabel.userInteractionEnabled = YES;
        [self.activityIndicatorView stopAnimating];
        self.downImageView.hidden = NO;
    }];
}

//获取任务列表
- (void)httpGetSuspectlist {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GetSuspectlistUrl,alarm,token];
    
    ZEBLog(@"%@",urlString);
   
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        SuspectlistBaseModel *baseModel = [SuspectlistBaseModel getInfoWithData:response];
        
        [[[DBManager sharedManager] suspectAlllistSQ] transactionInsertSuspectAlllist:baseModel.results];
       
        
        [self.taskArray removeAllObjects];
        [self getDataSource];
        self.titleLabel.userInteractionEnabled = YES;
        [self.activityIndicatorView stopAnimating];
        self.downImageView.hidden = NO;
    } fail:^(NSError *error) {
        [self getDataSource];
        self.titleLabel.userInteractionEnabled = YES;
        [self.activityIndicatorView stopAnimating];
        self.downImageView.hidden = NO;
    }];
}
- (void)getDataSource {
    
    [self.taskArray addObjectsFromArray:[[[DBManager sharedManager] suspectAlllistSQ]  selectSuspectlistByGid:self.gid]];
    SuspectlistModel *model = [[SuspectlistModel alloc] init];
    model.suspectid = chooseAll;
    model.suspectname = @"全部";
    [self.taskArray insertObject:model atIndex:0];
    if (self.isAddTask) {
        [self changeTask:self.taskArray.count-1];
        [self changeSelect:self.taskArray.count-1];
    }
}
- (void)initMapView {
    _map = [[MapViewController alloc] init];
    _map.view.frame = self.view.bounds;
    [self.view addSubview:_map.view];
}

- (void)showRenwu:(UITapGestureRecognizer *)recognizer {
   
    [_map dismiss];
    [self.bubbleView addSubview:self.topTaskListView];
    [self.bubbleView showInPoint:CGPointMake([recognizer view].center.x, [recognizer view].center.y + 20)];
    
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.bubbleView];

}
- (ZEBBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[ZEBBubbleView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
        _bubbleView.direction = TriangleDirection_Up;
        _bubbleView.cornerRadius = 5;
        _bubbleView.color = [UIColor whiteColor];
        _bubbleView.triangleXY = 150/2;
        _bubbleView.triangleW = 20;
    }
    return _bubbleView;
}
- (TopTaskListView *)topTaskListView {
    if (!_topTaskListView) {
        _topTaskListView = [[TopTaskListView alloc] initWithFrame:CGRectMake(0, 10, width(_bubbleView.frame), height(_bubbleView.frame)-20) widthDataArray:self.taskArray withBlock:^(TopTaskListView *view, NSInteger index) {
            [self dismiss];
            ZEBLog(@"----%ld",index);
            [self changeTask:index];
        }];
        NSInteger count = self.taskArray.count;
        _topTaskListView.selectedIndex = 0;
        _topTaskListView.backgroundColor = [UIColor clearColor];
    }
    return _topTaskListView;
}
- (void)changeSelect:(NSInteger)k {
    _topTaskListView.selectedIndex = k;
}
//切换任务
- (void)changeTask:(NSInteger)index {
    
    NSInteger count = self.taskArray.count;
    if (index+1 > count) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    SuspectlistModel *mdoel = self.taskArray[index];
    self.workId = mdoel.suspectid;
    self.workName = mdoel.suspectname;
    dic[taskId] = mdoel.suspectid;
    dic[taskName] = mdoel.suspectname;
    [[NSNotificationCenter defaultCenter] postNotificationName:MapshowOneTaskAnnontationNotification object:nil userInfo:dic];
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
    [_topTaskListView removeFromSuperview];
    [_bubbleView removeFromSuperview];
    [_overlayView removeFromSuperview];
}
//摄像头标记
- (MapBottomView *)cameraView {

    if (!_cameraView) {
        _cameraView = [[MapBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) markType:CAMERAMARK block:^(MARKTYPE type, NSInteger tag) {
            self.markType = type;
            [self cameraMrk:tag];
        }];
    }
    return _cameraView;
}
- (void)cameraMrk:(NSInteger)tag {
    self.signType = tag;
    [self.cameraView dismiss];
    [self.cameraDirectionView showIn:self.view];
}
//走访标记
- (MapBottomView *)visitView {
    if (!_visitView) {
        _visitView = [[MapBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) markType:VISITMARK block:^(MARKTYPE type, NSInteger tag) {
            self.markType = type;
            [self visitaMrk:tag];
        }];
    }
    return _visitView;
}
- (void)visitaMrk:(NSInteger)tag {
    [self.visitView dismiss];
    self.signType = tag;
    CGRect rect = self.centerImageView.frame;
    rect.size.height = 20;
    rect.size.width = 20;
    self.centerImageView.frame = rect;
    
    self.centerImageView.image = [ChatBusiness getIntersignZAnnotationIcon:[NSString stringWithFormat:@"%ld",tag]];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.mapNextView];
}
//下一步
- (MapCancelNextView *)mapNextView {
    if (!_mapNextView) {
        _mapNextView = [[MapCancelNextView alloc] initWithFrame:CGRectMake(0, 0, 130, 60) nextBlock:^(MapCancelNextView *view) {
            [self mapNext];
        } cancelBlock:^(MapCancelNextView *view) {
            [self.centerImageView removeFromSuperview];
        }];
        _mapNextView.center = CGPointMake(midX(self.view), kScreenHeight-64-30);
    }
    return _mapNextView;
}
- (void)mapNext {
    [LYRouter openURL:@"ly://getmapcenterCoordinate"];
    [self.mapNextView dismiss];
    [self.centerImageView removeFromSuperview];
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    
    if ([self.workId isEqualToString:chooseAll]) {
        self.workId = @"";
    }
    if ([self.workName isEqualToString:chooseAll]) {
        self.workName = @"";
    }
    
    parma[@"longitude"]  = _longitude;
    parma[@"latitude"] = _latitude;
    parma[@"gid"] = self.gid;//群ID
    parma[@"direction"] = [NSString stringWithFormat:@"%ld",self.dircation];//摄像头方向
    parma[@"workid"] = self.workId;//任务ID
    parma[@"workname"] = self.workName;//任务名称
    parma[@"mode"] = [NSString stringWithFormat:@"%ld",self.markType];//标记类型
    parma[@"type"] = [NSString stringWithFormat:@"%ld",self.signType];//摄像头类型 走访标记类型
    
    ZEBLog(@"看看%@",parma);
    
    CameraMarkViewController *markVC = [[CameraMarkViewController alloc]init];
    markVC.fromWhere = OtherController;
    markVC.markParam = parma;
    [self.navigationController pushViewController:markVC animated:YES];
    
}
//界面中心图标
- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _centerImageView.center = self.view.center;
    }
    return _centerImageView;
}

//摄像头方向
- (CameraDirectionView *)cameraDirectionView {
    if (!_cameraDirectionView) {
        _cameraDirectionView =[[CameraDirectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) cameraDirationBlock:^(CameraDirectionView *view, NSInteger tag) {
            [self chooseDircation:tag];
        }];
    }
    return _cameraDirectionView;
}
- (void)chooseDircation:(NSInteger)tag {
    [self.cameraDirectionView dismiss];
    self.dircation = tag;
    CGRect rect = self.centerImageView.frame;
    rect.size.height = 35;
    rect.size.width = 35;
    self.centerImageView.frame = rect;
    
    self.centerImageView.image = [ChatBusiness getCameraZAnnotationIcon:[NSString stringWithFormat:@"%ld",self.signType] direction:[NSString stringWithFormat:@"%ld",tag]];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.mapNextView];
}

//快速标记
-(void)configParamWithQuickRecordMark
{
    self.markType = FASTMARK;
    
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    if ([self.workId isEqualToString:chooseAll]) {
        self.workId = @"";
    }
    if ([self.workName isEqualToString:chooseAll]) {
        self.workName = @"";
    }
    parma[@"longitude"]  = _longitude;
    parma[@"latitude"] = _latitude;
    parma[@"gid"] = self.gid;//群ID
//    parma[@"direction"] = [NSString stringWithFormat:@"%ld",self.dircation];//摄像头方向
    parma[@"workid"] = self.workId;//任务ID
    parma[@"workname"] = self.workName;//任务名称
    parma[@"mode"] = [NSString stringWithFormat:@"%ld",self.markType];//标记类型
//    parma[@"type"] = [NSString stringWithFormat:@"%ld",self.signType];//摄像头类型 走访标记类型
    
    ZEBLog(@"看看%@",parma);
    
    CameraMarkViewController *markVC = [[CameraMarkViewController alloc]init];
    markVC.fromWhere = OtherController;
    markVC.markParam = parma;
    [self.navigationController pushViewController:markVC animated:YES];
}
//根据workid查找位置
- (NSInteger)getWorkIdIndex:(NSString *)workId {
    
    NSInteger count = self.taskArray.count;
    NSInteger k = 0;
    for (int i = 0; i < count; i++) {
        SuspectlistModel *mdoel = self.taskArray[i];
        if ([workId isEqualToString:mdoel.suspectid]) {
            k = i;
            break;
        }
    }
    return k;
}
-(void)reloadChatGroupName:(NSNotification *)notification
{
    NSMutableDictionary *param = notification.object;
    
    if ([param[@"gid"] isEqualToString: self.gid]) {
        CGRect rect = self.titleLabel.frame;
        
        CGFloat width = [LZXHelper textWidthFromTextString:param[@"gName"] height:25 fontSize:15];
        
        if (width>100)
        {
            width = 100;
        }
        rect.size.width = width+(25/2)*2;
        self.titleLabel.frame = rect;
        self.downImageView.center = CGPointMake(minX(self.titleLabel)-5, midY(self.titleLabel));
        self.activityIndicatorView.frame = CGRectMake(minX(self.titleLabel)-20, minY(self.titleLabel)+2.5, 20, 20);
        self.titleLabel.text = param[@"gName"];
    }
    
}
- (WarningView *)warningView {
    if (!_warningView) {
        _warningView = [[WarningView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 0)];
        _warningView.backgroundColor = [UIColor colorWithRed:0.54 green:0.53 blue:0.52 alpha:1.00];
        _warningView.alpha = 0.8;
    }
    return _warningView;
}
- (UIButton *)seePathBtn {
    if (!_seePathBtn) {
        _seePathBtn = [CHCUI createButtonWithtarg:self sel:@selector(seePath:) titColor:nil font:ZEBFont(10) image:@"seepath"backGroundImage:nil title:@""];
        _seePathBtn.frame = CGRectMake(kScreenWidth-60, TopBarHeight+HEIGHT+10, 35, 35);
        
    }
    return _seePathBtn;
}

#pragma mark -
#pragma mark 查看轨迹
- (void)seePath:(UIButton *)btn {
    SeePathViewController *seePath = [[SeePathViewController alloc] init];
    seePath.gid = self.gid;
    if ([self.workId isEqualToString:chooseAll]) {
        seePath.workId = @"";
    }else {
        seePath.workId = self.workId;
    }
    seePath.haveSelectArray = self.selectPathArray;
    [self.navigationController pushViewController:seePath animated:YES];
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
