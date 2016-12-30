//
//  ChatListViewController.m
//  ProjectTemplate
//
//  Created by Jomper Chow on 16/7/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatListViewController.h"
#import "XMNChatController.h"
#import "XMNChatViewModel.h"
#import "ChatListCell.h"
#import "Masonry.h"
#import "UIImageView+XMWebImage.h"
#import "ICometModel.h"
#import "GroupLogic.h"
#import "GroupInfoResponseModel.h"
#import "DBManager.h"
#import "UserlistModel.h"
#import "FriendsListModel.h"
#import "UIView+Extension.h"
#import "JHDownMenuView.h"
#import "NewFriendsViewController.h"
#import "SearchViewController.h"
#import "CreateGroupController.h"
#import "ScanViewController.h"
#import "UserInfoModel.h"
#import "NSDate+Extensions.h"
#import "CUrlServer.h"
#import "ChatMapViewController.h"
#import "CreateTaskViewController.h"
#import "ChatBusiness.h"
#import "NSString+Time.h"
#import "TeamsModel.h"
#import "SystemRemindController.h"

#define kSelfName @"MicroRecon-iOS"
#define kSelfThumb @"http://img1.touxiang.cn/uploads/20131114/14-065809_117.jpg"

@interface ChatListViewController()<UITableViewDelegate,UITableViewDataSource,JHDownMenuViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *networkStateView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *allMsgArray;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger maxQid;

@property (nonatomic, strong) JHDownMenuView *menuView;
@property (assign, nonatomic) XMNMessageChat messageChatType;
@property (nonatomic, strong) XMNChatViewModel *chatViewModel;
/**
 * 标题上Loading View
 */
@property (nonatomic, strong) UIView *titleView;
@property(weak,nonatomic)UILabel *netTitle;
@property(assign,nonatomic)BOOL isLunch;

@end

@implementation ChatListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    
    
    self.tableView.backgroundColor=[UIColor clearColor];
    [self setNavigationBar];
    [self createDownMenu];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.allMsgArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(reloadMessage:) userInfo:nil repeats:YES];
    
//    [self loadDatas];
    
    // 注册观察者
    // 观察者 self 在收到名为 @"NOTIFICATION_NAME" 的事件是执行 @selector(execute:)，最后一个参数是表示会对哪个发送者对象发出的事件作出响应，nil 时表示接受所有发送者的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute:) name: @"ReceiveMessage" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObserverNetWork:) name: @"NetWork" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: @"chatlistRefreshNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipChat:) name: @"skipChatNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChat:) name:PushGroupChatNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskGroupChat:) name:PushTaskGroupChatNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTitle) name:AllMessageReloadNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatGroupName:) name:ReloadChatGroupNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewMessageCount:) name:@"ReloadTableViewAndClearNewMessageCount" object:nil];
    
    //将自己的组织类型存入本地
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:alarm];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:model.RE_department];
    [[NSUserDefaults standardUserDefaults] setObject:uModel.DE_type forKey:DEType];
    [[NSUserDefaults standardUserDefaults] setObject:uModel.DE_name forKey:DEName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reloadChatGroupName:(NSNotification *)notification
{

    _dataArray = [[[DBManager sharedManager] UserlistDAO] selectUserlists];
    
    [_tableView reloadData];
}

- (void)reloadNewMessageCount:(NSNotification *)notification {
    
    NSString *chatID = notification.object;
    [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:chatID];
    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:chatID];
    [self.dataArray removeAllObjects];
    self.dataArray = [[[DBManager sharedManager] UserlistDAO] selectUserlists];
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden =NO;
    }
    if (self.tabBarController.tabBar.hidden) {
        [self.tabBarController.tabBar setHidden:NO];
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showtimeout" object:nil];
}

- (void)skipChat:(NSNotification *)notification {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([notification.object isKindOfClass:[UserInfoModel class]]) {
        UserInfoModel *userInfoModel = notification.object ;
        
        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatSingle];
        
        [user setObj:@"S" forKey:@"chatType"];
        chatC.chatterName = userInfoModel.name;
        chatC.cType = ChatList;
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:userInfoModel.alarm];
        
        chatC.chatterThumb = userInfoModel.headpic;
        chatC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:chatC animated:YES];
    }else if ([notification.object isKindOfClass:[TeamsListModel class]]) {
        
        TeamsListModel *teamModel = notification.object;
        [user setObj:teamModel.gid forKey:@"chatId"];
        [user setObj:@"G" forKey:@"chatType"];
        if ([teamModel.type isEqualToString:@"0"]) {
            
            ChatMapViewController *chatMap = [[ChatMapViewController alloc] initWithChatType:XMNMessageChatGroup chatname:teamModel.gname type:1];
            chatMap.chatView = [[ChatView alloc] init];
            
            [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:teamModel.gid];
            chatMap.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatMap animated:YES];
            
        }else {
            
            XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
            
            chatC.chatterName = teamModel.gname;
            chatC.cType = GroupTeam;
            [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:teamModel.gid];
            
            chatC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatC animated:YES];
        }
    }
    
    
}

- (void)groupChat:(NSNotification *)notification{

    TeamsListModel *model = [notification.object firstObject];
    GroupVCComeType type =[[notification.object lastObject] integerValue];
    if (type == ChatListVCToGroup) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"G" forKey:@"chatType"];
        [user setObject:model.gid forKey:@"chatId"];
        
        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
        chatC.chatterName = model.gname;
        chatC.cType = ChatList;
        
        chatC.hidesBottomBarWhenPushed = YES;
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.gid];
        [self.navigationController pushViewController:chatC animated:YES];
    }
    
    
}

- (void)taskGroupChat:(NSNotification *)notification {
    
    TeamsListModel *model = [notification.object firstObject];
    TaskGroupVCComeType type =[[notification.object lastObject] integerValue];
    if (type == ChatListVCToTaskGroup) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"G" forKey:@"chatType"];
        [user setObject:model.gid forKey:@"chatId"];
        
        ChatMapViewController *chatMap = [[ChatMapViewController alloc] initWithChatType:XMNMessageChatGroup chatname:model.gname type:1];
        chatMap.chatterName = model.gname;
        chatMap.hidesBottomBarWhenPushed = YES;
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.gid];
        
        [self.navigationController pushViewController:chatMap animated:YES];
    }

}
//删除好友刷新列表
- (void)reloadData {
    self.dataArray = nil;
    [self.tableView reloadData];
}
-(void)addObserverNetWork:(NSNotification *)notification{
    UILabel *label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor colorWithRed:254/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height =35;
    if (notification.userInfo[@"message"]!=nil && [notification.userInfo[@"message"] isEqualToString:@"网络未连接"]) {
        //CUrlServer *cur=[CUrlServer sharedManager];
       // cur.isComet=false;
        [[UIApplication sharedApplication].keyWindow.rootViewController showHint:@"网络未连接"];
        if (self.tableView.tableHeaderView==nil) {
            label.textColor =[UIColor colorWithRed:115/255.0 green:116/255.0 blue:122/255.0 alpha:1.0];
            label.text=notification.userInfo[@"message"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:16];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.tableHeaderView=label;
        }];
        }
        }
        if (notification.userInfo[@"message"]!=nil && ([notification.userInfo[@"message"] isEqualToString:@"3G|4G网络"] || [notification.userInfo[@"message"] isEqualToString:@"wifi网络"])) {
            
            //刷新标题
            [self refreshTitle];
        }
   
}

-(void)refreshTitle
{
    CGFloat duration = 0.5; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        
        self.tableView.tableHeaderView=nil;
        // [AgainLoginRequest aginLoginRequest];
        self.navigationItem.titleView = self.titleView;
    }];
}


- (void)dealloc {
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - NSTimer
/*
 * NSTimer每隔2s调用一次该方法
 */
- (void)reloadMessage:(id)userinfo {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (!token || [@"" isEqualToString:token]) {
        return;
    }

    NSInteger newMaxQid = [[[DBManager sharedManager] MessageDAO] getMaxQid];
    // 只有当有了新消息后才会重新加载 UITableView
    if (newMaxQid > self.maxQid) {
        self.dataArray = [[[DBManager sharedManager] UserlistDAO] selectUserlists];
        [self.tableView reloadData];
    }
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"消息";
    self.maxQid = newMaxQid;
}

/**
 * 定义一个事件到来时执行的方法
 */
- (void)execute:(NSNotification *)notification {
    
    //do something when received notification
    if(notification.object && [notification.object isKindOfClass:[ICometModel class]]){
        
//        ICometModel *model = notification.object;
//        // 存放在所有记录中
//        [self.allMsgArray addObject:model];
//        // 先删除相同人发的消息
//        for (ICometModel *iModel in self.dataArray) {
//            if ([iModel isUpdateOnChatList:model]) {
//                [self.dataArray removeObject:iModel];
//                break;
//            }
//        }
//        // 然后在把消息插入到第一个
//        [self.dataArray insertObject:model atIndex:0];
        /*
         * 来一条消息刷新一次列表很影响程序运行效果，
         * 现在改为用NSTimer每隔2s，判断如果有新的数据就刷新
         */
//        [self.tableView reloadData];
    }
  
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
    UserlistModel *model = self.dataArray[indexPath.row];

    
    NSString *lastMsg = [ChatBusiness getLastMessage:model];
        
    if ([@"G" isEqualToString:model.ut_type]) {
        [self setGroupName:cell groupId:model.ut_alarm];
      // NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        BOOL isAtMe = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"@%@",model.ut_alarm]];
        if (isAtMe) {
            NSString *lastMessage = [NSString stringWithFormat:@"[有人@我]%@：%@",model.ut_name, lastMsg];
            NSMutableAttributedString *lastStr = [[NSMutableAttributedString alloc] initWithString:lastMessage];
            NSRange redRange = NSMakeRange(0, [[lastStr string] rangeOfString:@"]"].location);
            [lastStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
            [cell.lastMessageLabel setAttributedText:lastStr];
        }else {
            //群组中聊天当发送者是自己时，不显示自己的名字
            if([model.ut_sendid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]])
            {
                NSString *lastMessage = [NSString stringWithFormat:@"%@",lastMsg];
                [cell.lastMessageLabel setText:lastMessage];
            }
            else
            {
                if ([model.ut_cmd isEqualToString:@"1"]) {
                    
                    NSString *lastMessage = [NSString stringWithFormat:@"%@ : %@", model.ut_name, lastMsg];
                    [cell.lastMessageLabel setText:lastMessage];
                }
                else
                {
                    NSString *lastMessage = [NSString stringWithFormat:@"%@",lastMsg];
                    [cell.lastMessageLabel setText:lastMessage];
                }
                
            }
        }
        
    }else if ([@"B" isEqualToString:model.ut_type]){
        NSString *lastMessage = [NSString stringWithFormat:@"%@",lastMsg];
        [cell.lastMessageLabel setText:lastMessage];
        [cell.titleLabel setText:@"系统消息提醒"];
        [cell.headImageView setImage:[UIImage imageNamed:@"system_remind"]];
        
    }else {
        
        FriendsListModel *fModel = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlistById:model.ut_alarm];
        
        [cell.titleLabel setText:fModel.name];
        if ([model.ut_fire  containsString:@"LOCK"]) {
            NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
            if ([model.ut_sendid isEqualToString:alarm]) {
                [cell.lastMessageLabel setText:@"你发送了一条悄悄话"];
            }
            else
            {
               [cell.lastMessageLabel setText:@"你收到了一条悄悄话"]; ;
            }
            
        }
        else
        {
            [cell.lastMessageLabel setText:lastMsg];
        }
        [cell.headImageView imageGetCacheForAlarm:fModel.alarm forUrl:fModel.headpic];
    }
    
    
    [cell.timeLabel setText:[model.ut_time timeChage]];
    NSInteger newMsgCount = [model.ut_newmsgcount integerValue];
    cell.unReadCount = newMsgCount;
//    cell.unreadLabel.text = [[NSString alloc] initWithFormat:@"%ld", cell.unReadCount];
//    cell.unreadLabel.hidden = newMsgCount < 1;
    return cell;
}
#pragma mark -
#pragma mark 删除某个会话
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除会话
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserlistModel *model = self.dataArray[indexPath.row];
    [[[DBManager sharedManager] UserlistDAO] deleteUserlist:model.ut_alarm];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}





/**
 * 通过群id来设置群名称
 */
- (void)setGroupName:(ChatListCell *)cell groupId:(NSString *)gid {
    /**
     *  先从本地缓存取
     */
    NSString *imageStr = @"";
    TeamsListModel *gModel = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:gid];
    if (gModel) {
        switch ([gModel.type integerValue]) {
            case 0:
                imageStr = @"group_zhencha";
                break;
            case 1:
                imageStr = @"group_qunliao";
                break;
            case 2:
                imageStr = @"group_anbao";
                break;
            case 3:
                imageStr = @"group_xunkong";
                break;
            case 4:
                imageStr = @"group_sos";
                break;
            default:
                imageStr = @"ph_g";
                break;
        }
        cell.titleLabel.text = gModel.gname;
        cell.headImageView.image = [UIImage imageNamed:imageStr];
    }
    if ([[LZXHelper isNullToString:gModel.gname] isEqualToString:@""]) {
        
        [[GroupLogic sharedManager] logicGetGroupInfoByGroupId:gid progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            GroupInfoResponseModel *model = [GroupInfoResponseModel groupInfoWithData:reponse];
            GroupInfo *rgim = model.groups[0];
            NSString *imageStr = @"";
            switch ([gModel.type integerValue]) {
                case 0:
                    imageStr = @"group_zhencha";
                    break;
                case 1:
                    imageStr = @"group_qunliao";
                    break;
                case 2:
                    imageStr = @"group_anbao";
                    break;
                case 3:
                    imageStr = @"group_xunkong";
                    break;
                case 4:
                    imageStr = @"group_sos";
                    break;
                default:
                    imageStr = @"ph_g";
                    break;
            }
            cell.titleLabel.text = rgim.gname;
            cell.headImageView.image = [UIImage imageNamed:imageStr];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserlistModel *model = self.dataArray[indexPath.row];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:model.ut_alarm forKey:@"chatId"];
    TeamsListModel *teamModel;
    // 根据 type 判断是单聊还是群聊
    if ([@"G" isEqualToString:model.ut_type]) {
    teamModel = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:model.ut_alarm];
    }
    
    if ([teamModel.type isEqualToString:@"0"]) {
        
        [user setObject:@"G" forKey:@"chatType"];
        
        ChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        ChatMapViewController *chatMap = [[ChatMapViewController alloc] initWithChatType:XMNMessageChatGroup chatname:cell.titleLabel.text type:1];
    
        [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:model.ut_alarm];
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.ut_alarm];
        [self.dataArray removeAllObjects];
        self.dataArray = nil;
        [self.tableView reloadData];
        chatMap.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatMap animated:YES];
        
    }else if ([@"B" isEqualToString:model.ut_type]){
        SystemRemindController *svc = [[SystemRemindController alloc] init];
        
        [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:model.ut_alarm];
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.ut_alarm];
        [self.dataArray removeAllObjects];
        self.dataArray = nil;
        [self.tableView reloadData];
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
        
    }else {
    XMNChatController *chatC;
    // 根据 type 判断是单聊还是群聊
    if ([@"G" isEqualToString:model.ut_type]) {
        [user setObject:@"G" forKey:@"chatType"];
        chatC =[[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
    } else {
        [user setObject:@"S" forKey:@"chatType"];
        chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatSingle];
    }
    ChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    chatC.chatterName = cell.titleLabel.text;
    chatC.cType = ChatList;
    //cell.unreadLabel.hidden = YES;
    [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:model.ut_alarm];
    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.ut_alarm];
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    [self.tableView reloadData];
   //chatC.chatterThumb = model.ut_message;
    chatC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatC animated:YES];
    }
}


#pragma mark - Private Methods

- (void)setNavigationBar {
    self.navigationItem.titleView = self.titleView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 19, 19);
    [button setBackgroundImage:[UIImage imageNamed:@"friend_add_normal"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
}

//- (void)loadDatas{
//    self.dataArray = [NSMutableArray array];
//    [self.thumbs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [self.dataArray addObject:@{@"nickName":self.nickNames[idx],@"thumb":obj}];
//    }];
//    [self.tableView reloadData];
//}


#pragma mark - Getters

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 66;
    }
    return _tableView;
}

- (UIView *)networkStateView{
    if (!_networkStateView) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        _networkStateView.backgroundColor = [UIColor orangeColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageSendFail"]];
        [_networkStateView addSubview:iconImageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"世界上最遥远的距离就是没网.检查设置";
        [_networkStateView addSubview:label];
        
        UIImageView *arrwoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_center_arrow_right"]];
        [_networkStateView addSubview:arrwoImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_networkStateView.mas_left).with.offset(4);
            make.centerY.equalTo(_networkStateView.mas_centerY);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).with.offset(4);
            make.centerY.equalTo(_networkStateView.mas_centerY);
        }];
        
        [arrwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_networkStateView.mas_right).with.offset(-8);
            make.centerY.equalTo(_networkStateView.mas_centerY);
        }];
        
    }
    return _networkStateView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[[DBManager sharedManager] UserlistDAO] selectUserlists];
    }
    return _dataArray;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 0, 100, 30);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 35)];
        lbl.text = @"收取中";
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
    scanView.pageType = 1;
    scanView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanView animated:YES];
}
- (void)skipCreateGroup {
    
    CreateGroupController *createGroupC = [[CreateGroupController alloc] init];
    createGroupC.hidesBottomBarWhenPushed = YES;
    createGroupC.comeType = ChatListVCToGroup;
    [self.navigationController pushViewController:createGroupC animated:YES];
}

- (void)addFriend {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.type = 3;
    search.cType = 1;
    search.str = @"输入姓名或警号搜索警员";
    UINavigationController *searNav = [[UINavigationController alloc] initWithRootViewController:search];
    [self presentViewController:searNav animated:YES completion:nil];
}
- (void)skipCreateTask {
    CreateTaskViewController *task = [[CreateTaskViewController alloc] init];
    task.hidesBottomBarWhenPushed = YES;;
    task.type = ChatListVCToTaskGroup;
    [self.navigationController pushViewController:task animated:YES];
}

@end
