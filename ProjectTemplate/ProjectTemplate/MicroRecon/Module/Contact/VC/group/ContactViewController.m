//
//  ContactViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ContactViewController.h"
#import "UIView+Common.h"
#import "FriendsViewController.h"
#import "TeamViewController.h"
#import "UnitViewController.h"
#import "JHDownMenuView.h"
#import "UnitNextViewController.h"
#import "UserDesInfoController.h"
#import "FriendsListModel.h"
#import "XMNChatController.h"
#import "TeamsListModel.h"
#import "NewFriendsViewController.h"
#import "SearchViewController.h"
#import "CreateGroupController.h"
#import "UserInfoViewController.h"
#import "ScanViewController.h"
#import "GroupDesBaseModel.h"
#import "GroupDesModel.h"
#import "ChatMapViewController.h"
#import "UIButton+EnlargeEdge.h"
#import "CreateTaskViewController.h"


#define LeftMargin 8
#define TopMargin 10


@interface ContactViewController ()<UnitViewControllerPushDelegate,FriendsViewControllerPushDelegate,teamViewControllerPushDelegate,JHDownMenuViewDelegate> {

    UIView *_bottomView;
    UIView *_topView;
    FriendsViewController *_friendsViewController;
    TeamViewController *_teamViewController;
    UnitViewController *_unitViewController;
    
}
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, copy) NSString *searchPlStr;
@property (nonatomic, assign) NSInteger searchType;
@property (nonatomic, strong) UIControl *coverView;

@property (nonatomic, strong) JHDownMenuView *menuView;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.searchPlStr = @"输入姓名或警号搜索好友";
    self.searchType = 1;
    [self initall];
    
}
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initall {

    
    
    [self setNavigationBar];
    [self createSearBtn];
    [self createFRbtn];
    [self initController];
    //[self createCover];
    [self createDownMenu];
    [self creatNotification];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden =NO;
    }
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
    }
}
#pragma mark -
#pragma mark 创建通知中心 页面通讯
- (void)creatNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTopView) name:HideTopViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopView) name:ShowTopViewHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpGtGroupDesInfo:) name:@"httpGtGroupDesInfoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipGroup:) name: @"skipGroupNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChat:) name: PushGroupChatNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskGroupChat:) name: PushTaskGroupChatNotification object:nil];
}


- (void)skipGroup:(NSNotification *)notification {
    
    NSInteger type = [[notification.object lastObject] integerValue];
  
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:[notification.object firstObject]];
    
//    if ([notification.object isKindOfClass:[UserChatModel class]]) {
//        UserInfoModel *userInfoModel = notification.object;
//        
//        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatSingle];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user setObject:@"S" forKey:@"chatType"];
//        chatC.chatterName = userInfoModel.name;
//        chatC.cType = GroupTeam;
//        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:userInfoModel.alarm];
//        chatC.chatterThumb = userInfoModel.headpic;
//        chatC.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:chatC animated:YES];
//        
//  
//    }else if ([notification.object isKindOfClass:[TeamsListModel class]]) {
//        
//    }
}

//创建群组后push到群组页面
- (void)groupChat:(NSNotification *)notification{
    
    TeamsListModel *model = [notification.object firstObject];
    GroupVCComeType type =[[notification.object lastObject] integerValue];
    if (type == GroupTeamVCToGroup) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"G" forKey:@"chatType"];
        [user setObject:model.gid forKey:@"chatId"];
        
        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
        chatC.chatterName = model.gname;
        chatC.cType = ChatList;
        
        chatC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatC animated:YES];
    }

}

- (void)taskGroupChat:(NSNotification *)notification {
    
    TeamsListModel *model = [notification.object firstObject];
    TaskGroupVCComeType type =[[notification.object lastObject] integerValue];
    if (type == GroupTeamVCToTaskGroup) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"G" forKey:@"chatType"];
        [user setObject:model.gid forKey:@"chatId"];
        
        ChatMapViewController *chatMap = [[ChatMapViewController alloc] initWithChatType:XMNMessageChatGroup chatname:model.gname type:2];
        chatMap.chatterName = model.gname;
        chatMap.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatMap animated:YES];
    }
    
}

#pragma mark -
#pragma mark 请求群详细信息
- (void)httpGtGroupDesInfo:(NSNotification *)notification {
    
    NSString *gid = notification.object;
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GetGroupDesUrl,alarm,gid,token];
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        GroupDesBaseModel *gDesModel = [GroupDesBaseModel getInfoWithData:response];
        
        
        GroupDesModel *desModel = gDesModel.results[0];
       
        [[[DBManager sharedManager] GrouplistSQ] insertGrouplistGroupSuccess:desModel.gid gname:desModel.gname gadmin:desModel.gadmin gcreatetime:desModel.gcreatetime gtype:desModel.gtype gusercount:desModel.count];
      
        [_teamViewController refreshUI];
    } fail:^(NSError *error) {
        [self showHint:[error description]];
    }];
    
}
- (void)initController {

    _friendsViewController = [[FriendsViewController alloc] init];
    _friendsViewController.delegate = self;
    [_bottomView addSubview:_friendsViewController.view];
    
    _teamViewController = [[TeamViewController alloc] init];
    _teamViewController.delegate = self;
    _unitViewController = [[UnitViewController alloc] init];
    _unitViewController.delegate = self;

}

#pragma mark -
#pragma mark 创建搜索按钮
- (void)createSearBtn {

    UIButton *searBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    searBtn.backgroundColor =[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    searBtn.frame = CGRectMake(LeftMargin, TopMargin, screenWidth()-2*LeftMargin, 27);
//    searBtn.backgroundColor = [UIColor whiteColor];
    searBtn.layer.masksToBounds = YES;
    searBtn.layer.cornerRadius = 6;
    [searBtn setEnlargeEdgeWithTop:10 right:10 bottom:5 left:10];
    
    [searBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:searBtn];
    
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    searImg.center = CGPointMake(screenWidth()/2-30, 27/2);
    searImg.image = [UIImage imageNamed:@"actionbar_search_icon"];
    [searBtn addSubview:searImg];
    
    
    UILabel *searLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    searLab.center = CGPointMake(screenWidth()/2+10, 27/2);
    searLab.text = @"搜索";
    searLab.textColor = [UIColor grayColor];
    searLab.font = ZEBFont(14);
    [searBtn addSubview:searLab];
    
    UILabel *lab =[UILabel new];
    lab.frame = CGRectMake(0, _topView.bounds.size.height-20, screenWidth(),20);
    lab.backgroundColor =[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    [_topView addSubview:lab];
    
    
}
#pragma mark -
#pragma mark 创建搜索下面三个按钮
- (void)createFRbtn {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 2*TopMargin+27, screenWidth(), 80)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:bgView];
    
//    CGFloat width = (screenWidth()-2)/3;
    
//    for (int i = 0 ; i < 2; i++) {
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*width, TopMargin, 1, 80-TopMargin*2)];
//        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [bgView addSubview:line];
//    }
    
    
    CGFloat left = 45;
    CGFloat btnMargin = 35;
    
    CGFloat wid = (screenWidth() - 90 - btnMargin*2 - 45)/2;
    
    
    CGFloat heightBtn = btnMargin;
    CGFloat widthBtn = btnMargin;
    
    NSArray *titleAry = @[@"好友",@"组队",@"单位"];
    NSArray *imageAry = @[@"contact_friend_icon",@"contact_team_icon",@"contact_organization_icon"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        if (i == 0) {
            btn.frame = CGRectMake(left+i*(widthBtn+wid) , TopMargin, widthBtn, heightBtn);
        }else if (i == 1){
            btn.frame = CGRectMake(left+i*(widthBtn+wid) , TopMargin, widthBtn+10, heightBtn);
        }else if (i == 2){
            btn.frame = CGRectMake(left+i*(widthBtn+wid+5), TopMargin, widthBtn, heightBtn);
        }
        
        
        [btn setBackgroundImage:[UIImage imageNamed:imageAry[i]] forState:UIControlStateNormal];
        btn.tag = 1000+i;
        [btn setEnlargeEdgeWithTop:35 right:50 bottom:35 left:50];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        UILabel *title = [UILabel new];
        
        title.frame = CGRectMake(minX(btn), maxY(btn), widthBtn, 80 - 2*TopMargin - heightBtn+5);
        if(i == 1)
        {
            title.frame = CGRectMake(minX(btn)+5, maxY(btn), widthBtn, 80 - 2*TopMargin - heightBtn+5);
        }
        

        title.text = titleAry[i];
        title.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            title.textColor = zBlueColor;
        }else {
            title.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
        }
        title.font = [UIFont systemFontOfSize:14];
        title.tag = 10000+i;
        [bgView addSubview:title];
    }
    
    
}
#pragma mark -
#pragma mark 搜索下面三个按钮点击事件
- (void)btnClick:(UIButton *)btn {
    
    NSInteger btnTag = btn.tag-1000;
    UILabel *lab1 = [self.view viewWithTag:10000];
    UILabel *lab2 = [self.view viewWithTag:10001];
    UILabel *lab3 = [self.view viewWithTag:10002];
    switch (btnTag) {
        case 0:
            self.searchPlStr = @"输入姓名或警号搜索好友";
            self.searchType = 1;
            lab1.textColor = zBlueColor;
            lab2.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            lab3.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            [self clickFriends:btnTag];
            break;
        case 1:
            self.searchPlStr = @"输入群名搜索群";
            self.searchType = 2;
            lab1.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            lab2.textColor = zBlueColor;
            lab3.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            [self clickTeam:btnTag];
            break;
        case 2:
            self.searchPlStr = @"输入姓名或警号搜索警员";
            self.searchType = 3;
            lab1.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            lab2.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            lab3.textColor = zBlueColor;
            [self clickUnit:btnTag];
            break;
        default:
            break;
    }

}
#pragma mark -
#pragma mark 点击好友
- (void)clickFriends:(NSInteger)inter {

    [_bottomView addSubview:_friendsViewController.view];
    
    [_teamViewController.view removeFromSuperview];
    [_unitViewController.view removeFromSuperview];

}
#pragma mark -
#pragma mark 点击组队
- (void)clickTeam:(NSInteger)inter {

    [_bottomView addSubview:_teamViewController.view];
    [_friendsViewController.view removeFromSuperview];
    [_unitViewController.view removeFromSuperview];
    
}
#pragma mark -
#pragma mark 点击单位
- (void)clickUnit:(NSInteger)inter {

    [_bottomView addSubview:_unitViewController.view];
    [_teamViewController.view removeFromSuperview];
    [_friendsViewController.view removeFromSuperview];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"clickUnitFirst"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"clickUnitFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"httpGetInfoNotification" object:nil];
        self.navigationItem.titleView = self.titleView;
    }
}
#pragma mark -
#pragma mark 搜索按钮事件
-(void)searchAction:(UIButton *)btn {

    SearchViewController *search = [[SearchViewController alloc] init];
   
    search.type = self.searchType;
    search.cType = 2;
    search.str = self.searchPlStr;
    
    search.modalTransitionStyle = 2;
    UINavigationController *searNav = [[UINavigationController alloc] initWithRootViewController:search];
    [self presentViewController:searNav animated:YES completion:^{
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setNavigationBar {
    self.navigationItem.title = @"通讯录";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 19, 19);
    [button setBackgroundImage:[UIImage imageNamed:@"friend_add_normal"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), TopMargin*4+30+80)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY(_topView), screenWidth(), screenHeight()-(maxY(_topView))-44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
}
#pragma mark -
#pragma mark 上托上面隐藏
- (void)hideTopView {

    [UIView animateWithDuration:0.3 animations:^{
        _topView.frame = CGRectMake(0, 0, screenWidth(), 0);
        _bottomView.frame = CGRectMake(0, 64, screenWidth(), screenHeight()-64);
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -
#pragma mark 下拉上面隐藏
- (void)showTopView {
    [UIView animateWithDuration:0.3 animations:^{
        
        
        _topView.frame = CGRectMake(0, 64, screenWidth(), TopMargin*4+30+80);
        _bottomView.frame = CGRectMake(0, maxY(_topView), screenWidth(), screenHeight()-64);
        
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark -
#pragma mark ＋号菜单
//- (void)createCover
//{
//    UIControl *cover = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    cover.tag = 1;
//    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
//    [self.view addSubview:cover];
//    [cover addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    cover.hidden = YES;
//    
//    self.coverView = cover;
//}
//- (void)click:(UIControl *)cover {
//    
//    if (self.menuView.hidden) {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            self.menuView.hidden = NO;
//            self.coverView.hidden = NO;
//        }];
//        
//    }else
//    {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            self.menuView.hidden = YES;
//            self.coverView.hidden = YES;
//        }];
//        
//    }
//    
//}
- (void)createDownMenu
{
    //屏幕的宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //计算ableView的frame
    CGFloat ViewW = 130;
    CGFloat ViewH = 180+2*44;
    CGFloat ViewX = screenWidth - ViewW - 5;
    CGFloat ViewY = 64;
    
    JHDownMenuView *menuView = [[JHDownMenuView alloc]initWithFrame:CGRectMake(ViewX, ViewY, ViewW, ViewH)];
    menuView.delegate = self;
    self.menuView = menuView;
    
}

- (void)rightBtn:(UIButton *)btn {

    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView show];
    }
}

#pragma mark -
#pragma mark downmenuview代理实现
- (void)jHDownMenuView:(JHDownMenuView *)view tag:(NSInteger)tag {

    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView show];
    }
    switch (tag) {
        case 0:
            [self skipCreateGroup];
            break;
        case 1:
            [self addFriend];
            break;
        case 2:
            [self scan];
            break;
        case 3:
            [self skipCreateTask];
            break;
        default:
            break;
    }
    
}
/**
 *  扫一扫
 */
- (void)scan {
    ScanViewController *scanView = [[ScanViewController alloc] init];
    scanView.pageType = 2;
    scanView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanView animated:YES];
}
- (void)skipCreateGroup {

    CreateGroupController *createGroupC = [[CreateGroupController alloc] init];
    createGroupC.hidesBottomBarWhenPushed = YES;
    createGroupC.comeType = GroupTeamVCToGroup;
    [self.navigationController pushViewController:createGroupC animated:YES];
}




- (void)addFriend {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.type = 3;
    search.cType = 2;
    search.str = @"输入姓名或警号搜索警员";
    UINavigationController *searNav = [[UINavigationController alloc] initWithRootViewController:search];
    [self presentViewController:searNav animated:YES completion:nil];
}
- (void)skipCreateTask {
    CreateTaskViewController *task = [[CreateTaskViewController alloc] init];
    task.hidesBottomBarWhenPushed = YES;;
    task.type = GroupTeamVCToTaskGroup;
    [self.navigationController pushViewController:task animated:YES];
}
#pragma mark -
#pragma mark  好友跳转界面
- (void)friendsViewControllerPush:(FriendsViewController *)con frModel:(FriendsListModel *)frModel{

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([frModel.alarm isEqualToString:alarm]) {
        UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
        userInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoController animated:YES];
    }else {
        UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
        userDes.alarm = frModel.alarm;
        userDes.cType = GroupController;
        userDes.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userDes animated:YES];
    }
}
- (void)friendsViewControllerPushToNewFr:(FriendsViewController *)con {
    
    NewFriendsViewController *controller = [[NewFriendsViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:RemoveTag object:nil];
    
}
#pragma mark -
#pragma mark  组队跳转界面
- (void)teamViewControllerPush:(TeamViewController *)con teamListModel:(TeamsListModel *)model{

    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObj:model.gid forKey:@"chatId"];
    [user setObj:@"G" forKey:@"chatType"];
    if ([model.type isEqualToString:@"0"]) {
        
        ChatMapViewController *chatMap = [[ChatMapViewController alloc] initWithChatType:XMNMessageChatGroup chatname:model.gname type:2];
        chatMap.chatView = [[ChatView alloc] init];
        
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.gid];
        chatMap.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatMap animated:YES];
        
    }else {
        
        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
        
        chatC.chatterName = model.gname;
        chatC.cType = GroupTeam;
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.gid];
        
        chatC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatC animated:YES];
    }
}
#pragma mark -
#pragma mark  单位跳转界面
- (void)unitViewControllerPush:(UnitViewController *)con title:(NSString *)title arr:(NSMutableArray *)arr allUser:(NSMutableArray *)allUser allDepart:(NSMutableArray *)allDepart nextUser:(NSMutableArray *)nextUser{
    
    
    UnitNextViewController *next = [[UnitNextViewController alloc] init];
    next.hidesBottomBarWhenPushed = YES;
    next.userArray = allUser;
    next.departArray = allDepart;
    next.nextUserArr = nextUser;
    next.titleStr = title;
    next.arr = arr;
    
    [self.navigationController pushViewController:next animated:YES];
}
- (void)unitViewControllerPushUserInfo:(UnitViewController *)con userAllModel:(UserAllModel *)model {

    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([model.RE_alarmNum isEqualToString:alarm]) {
        UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
        userInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoController animated:YES];
    }else {
        UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
        userDes.RE_alarmNum = model.RE_alarmNum;
        userDes.cType = GroupController;
        userDes.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userDes animated:YES];
    }
}
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 0, 100, 30);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 35)];
        lbl.text = @"通讯录";
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont boldSystemFontOfSize:18.f];
        [_titleView addSubview:lbl];
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];//指定进度轮的大小
        [aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
        CGAffineTransform transform = CGAffineTransformMakeScale(.7f, .7f);
        aiv.transform = transform;
        [aiv startAnimating];
        [_titleView addSubview:aiv];
    }
    
    return _titleView;
}
- (void)changeTitleView {
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"通讯录";
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
