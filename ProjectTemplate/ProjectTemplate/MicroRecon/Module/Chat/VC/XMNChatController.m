//
//  XMNChatController.m
//  XMChatBarExample
//
//  Created by shscce on 15/11/20.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatController.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+XMNCellRegister.h"
#import "XMNChatMessageCell+XMNCellIdentifier.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ChatLocationViewController.h"
#import "AppDelegate.h"
#import "HttpsManager.h"
#import "Masonry.h"
#import "VideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "IDMPhotoBrowser.h"
#import "DBManager.h"
#import "GroupDesSetingController.h"
#import "UploadingSQ.h"
#import "UserDesInfoController.h"
#import "UserInfoViewController.h"
#import <MJRefresh.h>
#import "MessageDAO.h"
#import "ChatGroupAtController.h"
#import "UserInfoModel.h"
#import "HttpsManager.h"
#import "UserChatModel.h"
#import "ChatBusiness.h"
#import "CollectCopyView.h"
#import "ZEBIdentify2Code.h"
#import "QRResultGroupController.h"
#import "QRCodelWebController.h"
#import "ChatMessageForwardController.h"
#import "NearestImage.h"
#import "ChatBusiness.h"
#import "GroupDesModel.h"
#import "ZMLPlaceholderTextView.h"
#import "XMNMessageStateManager.h"
#import "MessageDoubleTapViewController.h"
#import "UIViewController+BackButtonHandler.h"
@class chatModel;
@interface XMNChatController () <XMChatBarDelegate,XMNAVAudioPlayerDelegate,XMNChatMessageCellDelegate,XMNChatViewModelDelegate,CollectCopyDelegate>


@property (nonatomic, strong) UILabel *attentionLabel;

@property (assign, nonatomic) XMNMessageChat messageChatType;


@property (nonatomic, copy) NSString *alarm; // 登录时的警号
@property (nonatomic, copy) NSString *token; // 登录成功服务器返回的token
@property (nonatomic, copy) NSString *headpic; // 头像
@property (nonatomic, copy) NSString *name; // 姓名
@property (nonatomic, copy) NSString *rid; //接受者警号
@property (nonatomic,copy) NSString *sid; //发送者警号
@property (nonatomic, assign) NSInteger qid; //消息标示
@property (nonatomic,assign) int page;//消息缓存中页数
@property (nonatomic, copy) NSString *chatType;//消息类型
@property (nonatomic, assign) int count;
@property (nonatomic, strong) CollectCopyView *collect;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,copy) NSString *codeStr;
@property (nonatomic,strong) NSURL *filePath;
@property (nonatomic,strong)IDMPhotoBrowser *browser;
@property (nonatomic,assign) BOOL hidden;

@property(nonatomic,strong)NearestImage  *nearsetImage;

@property(nonatomic,strong)NSMutableArray  * selectIndexArray;

@property(nonatomic,strong)NSMutableDictionary  * selectLabelDic;

@property(nonatomic,strong)XMNChatMessageCell  * lastSelsetCell;

@property (nonatomic,assign) BOOL isExistTimeout;

@end

@implementation XMNChatController


#pragma mark - Life Cycle

- (instancetype)initWithChatType:(XMNMessageChat)messageChatType{
    self = [super init];
    if (self) {

//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _messageChatType = messageChatType;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        //    [user setObject:userInfo.alarm forKey:@"alarm"];
        _alarm = [user objectForKey:@"alarm"];
        _token = [user objectForKey:@"token"];
        UserInfoModel *uModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
        _headpic = uModel.headpic;
        _name = uModel.name;
        
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.chatterName;
    [self createRightBarBtn];
    [XMNAVAudioPlayer sharePlayer].delegate = self;
    self.chatViewModel = [[XMNChatViewModel alloc] initWithParentVC:self];
    //set chat server
    self.chatViewModel.delegate = self;
   
    self.chatViewModel.dataArray = self.dataArray;
    self.chatViewModel.chatBar = self.chatBar;
    
    self.view.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234/255.0f blue:234/255.f alpha:1.0f];
    
    [self.view addSubview:self.chatBar];
    [self.view addSubview:self.tableView];
    self.tableView.userInteractionEnabled=YES;
    
    
//    [self makeConstraints];
    // 1.监听键盘弹出，把inputToolBar（输入工具条）往上移
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.监听键盘退出，inputToolBar回复原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //刷新ui
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:ChatControllerRefreshUINotification object:nil];
    //当有图片／视频来的时候刷新ui
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageVideoComingrefreshUI:) name:@"ImageVideoComing" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHind:) name:@"ShowHindNotfication" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLinkUrl:) name:@"ClickLinkUrlNotification" object:nil];
    
    //刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMe:) name:@"GroupDeleteManMotification" object:nil];
    
    //发送相册中最近的照片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendNearestImage:) name:@"SendNearestImageNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatGroupName:) name:RefreshGroupNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"ChatControllerBackNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFireMessageWithAtindex) name:RemoveFireMessageNotification object:nil];
    //阅后即焚别人已读
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireMessageBeRead:) name:ReadFireMessageNotification object:nil];
    
    [self scrollToBottom:NO];
    
    _selectIndexArray = [NSMutableArray arrayWithCapacity:0];
    [_selectIndexArray removeAllObjects];
    _selectLabelDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [_selectLabelDic removeAllObjects];
    
}

- (void)deleteMe:(NSNotification *)notification {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    if ([notification.object isEqualToString: chatId]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}


- (BOOL)navigationShouldPopOnBackButton {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
//    [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:chatId];
//    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:chatId];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableViewAndClearNewMessageCount" object:chatId];
//    [self.navigationController popToRootViewControllerAnimated:NO];
    return YES;
}

- (void)back {
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *chatId = [user objectForKey:@"chatId"];
//    [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:chatId];
//    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:chatId];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
//展示提醒框
- (void)showHind:(NSNotification *)notification {
    
    self.attentionLabel.text = notification.object;
    [self.view addSubview:_attentionLabel];
    [UIView animateWithDuration:1 animations:^{
       self.attentionLabel.frame = CGRectMake(20, 62, kScreenWidth-40, 35);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hindHind) withObject:self afterDelay:5];
    }];
    

}
- (void)hindHind {
    [UIView animateWithDuration:1 animations:^{
        self.attentionLabel.frame = CGRectMake(20, 0, kScreenWidth-40, 0);
    } completion:^(BOOL finished) {
        [self.attentionLabel removeFromSuperview];
    }];
}
//刷新ui
- (void)refreshUI:(NSNotification *)notification {
    
    _dataArray = nil;
    self.chatViewModel.dataArray = self.dataArray;
    [self.tableView reloadData];
}

- (void)imageVideoComingrefreshUI:(NSNotification *)notification {
   // NSString *cuid = notification.object;
    _dataArray = nil;
    self.chatViewModel.dataArray = self.dataArray;
    [self.tableView reloadData];
}
- (void)createRightBarBtn {


    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatType = [user objectForKey:@"chatType"];
    NSString *chatId = [user objectForKey:@"chatId"];
    
    if ([chatType isEqualToString:@"S"]) {
        BOOL ret = [[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:chatId];
        if (ret) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 40);
            
            [button addTarget:self action:@selector(rightBtnG:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"chat_person_normal"] forState:UIControlStateNormal];
            UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = rightBar;
        }
    }else if ([chatType isEqualToString:@"G"]) {
        BOOL ret = [[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:chatId];
        if (ret) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 25, 25);
            
            [button addTarget:self action:@selector(rightBtnG:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"chatmapGroup"] forState:UIControlStateNormal];
            UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = rightBar;
        }
        
    }
    
    
    
}
#pragma mark -
#pragma mark 创建右边按钮
- (void)rightBtnG:(UIButton *)btn {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatType = [user objectForKey:@"chatType"];
    NSString *chatId = [user objectForKey:@"chatId"];
    if ([chatType isEqualToString:@"S"]) {
        UserDesInfoController *uController = [[UserDesInfoController alloc] init];
        uController.alarm = chatId;
        uController.cType = ChatControlelr;
        self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:uController animated:YES];
    }else if ([chatType isEqualToString:@"G"]) {
        NSString *chatId = [user objectForKey:@"chatId"];
        GroupDesSetingController *grSetc = [[GroupDesSetingController alloc] init];
        if (self.cType == ChatList) {
            grSetc.cType = 1;
        }else if (self.cType == GroupTeam) {
            grSetc.cType = 2;
        }else if (self.cType == SearchC) {
            grSetc.cType = 3;
        }
        grSetc.gid = chatId;
        [self.navigationController pushViewController:grSetc animated:YES];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
}


//-(void)timeCompare:(NSMutableDictionary *)dict withTime:(NSString *)time
//{
//    
//    NSInteger maxQid;
//    if (self.messageChatType == XMNMessageChatGroup) {
//        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
//    }
//    else
//    {
//        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
//    }
//    
//    if(!_beginTime)
//    {
//        
//        for (NSInteger qid = maxQid; qid > 0; qid--) {
//            
//            ICometModel *model = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
//            
//            if ([model.cmd isEqualToString:@"3"])
//            {
//                _beginTime = time;
//                dict[kXMNMessageConfigurationTimeKey] = time;
//                return;
//            }
//            
//            if (![model.time isEqualToString:@"0"] || !model.time )
//            {
//                _beginTime = model.time;
//                
////                dict[kXMNMessageConfigurationTimeKey] = _beginTime;
//                
//                if ([ChatBusiness isTimeCompareWithTime:time WithBtime:_beginTime])
//                {
//                    _beginTime = time;
//                    dict[kXMNMessageConfigurationTimeKey] = time;
//                }
//                else
//                {
//                    dict[kXMNMessageConfigurationTimeKey] = @"0";
//                }
//                
//                return;
//            }
//
//        }
//        
//    }
//    else
//    {
//        if ([ChatBusiness isTimeCompareWithTime:time WithBtime:_beginTime])
//        {
//            _beginTime = time;
//            dict[kXMNMessageConfigurationTimeKey] = _beginTime;
//        }
//        else
//        {
//            dict[kXMNMessageConfigurationTimeKey] = @"0";
//        }
//    
//    }
// 
//}


-(void)timeCompare:(NSMutableDictionary *)dict withTime:(NSString *)time
{
    NSInteger maxQid;
    if (self.messageChatType == XMNMessageChatGroup) {
        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidGroup];
    }
    else
    {
        maxQid = [[[DBManager sharedManager] MessageDAO] getMaxQidSingle];
    }
    
    ICometModel *model = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:maxQid];
    if ([ChatBusiness isTimeCompareWithTime:time WithBtime:model.beginTime])
    {
        dict[kXMNMessageConfigurationTimeKey] = time;
    }
    else
    {
        dict[kXMNMessageConfigurationTimeKey] = @"0";
    }
    
}

#pragma mark - XMChatBarDelegate

- (void)chatBar:(XMChatBar *)chatBar sendMessage:(NSString *)message withType:(ChatFireMessageType)messageType  {
    
    if (messageType == messageLock) {
        self.fireMessageType = messageLock;
    }
    else
    {
         self.fireMessageType = messageUNLock;
    }
    
    NSMutableDictionary *textMessageDict = [NSMutableDictionary dictionary];
//    textMessageDict[kXMNMessageConfigurationQIDKey] =@(self.qid);
    textMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeText);
    textMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    textMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    textMessageDict[kXMNMessageConfigurationTextKey] = message;
    textMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    textMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    textMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    textMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    textMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    
    if (self.fireMessageType == messageLock) {
        textMessageDict[kXMNMessageConfigurationFireKey] = @"LOCK";
    }
    else
    {
        textMessageDict[kXMNMessageConfigurationFireKey] = @"";
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    textMessageDict[kXMNMessageConfigurationTimeKey] = time;

    [self timeCompare:textMessageDict withTime:time];
    

    
    [self addMessage:textMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds{
    
    NSMutableDictionary *voiceMessageDict = [NSMutableDictionary dictionary];
//    voiceMessageDict[kXMNMessageConfigurationQIDKey] =@(self.qid);
    voiceMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVoice);
    voiceMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    voiceMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    voiceMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    voiceMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    voiceMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    voiceMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    voiceMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    voiceMessageDict[kXMNMessageConfigurationVoiceKey] = voiceFileName;
    voiceMessageDict[kXMNMessageConfigurationVoiceSecondsKey] = @(seconds);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    voiceMessageDict[kXMNMessageConfigurationTimeKey] = time;
     [self timeCompare:voiceMessageDict withTime:time];
    

    
    [self addMessage:voiceMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendPictures:(NSArray *)pictures{
    
    NSMutableDictionary *imageMessageDict = [NSMutableDictionary dictionary];
//    imageMessageDict[kXMNMessageConfigurationQIDKey] =@(self.qid);
    imageMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeImage);
    imageMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    imageMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    imageMessageDict[kXMNMessageConfigurationImageKey] = [pictures firstObject];
    imageMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    imageMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    imageMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    imageMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    imageMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    imageMessageDict[kXMNMessageConfigurationTimeKey] = time;
    
     [self timeCompare:imageMessageDict withTime:time];

    
    
    [self addMessage:imageMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendLocation:(NSString *)location locationText:(NSString *)locationText{
    NSMutableDictionary *locationMessageDict = [NSMutableDictionary dictionary];
//    locationMessageDict[kXMNMessageConfigurationQIDKey] =@(self.qid);
    locationMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeLocation);
    locationMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    locationMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    locationMessageDict[kXMNMessageConfigurationTextKey] = locationText;
    locationMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    locationMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    locationMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    locationMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    locationMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    locationMessageDict[kXMNMessageConfigurationLocationKey] = location;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    locationMessageDict[kXMNMessageConfigurationTimeKey] = time;
    
     [self timeCompare:locationMessageDict withTime:time];

    
    
    [self addMessage:locationMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendVideo:(NSURL *) assetURL{
    NSMutableDictionary *videoMessageDict = [NSMutableDictionary dictionary];
//    videoMessageDict[kXMNMessageConfigurationQIDKey] =@(self.qid);
    videoMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVideo);
    videoMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    videoMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    videoMessageDict[kXMNMessageConfigurationVideoKey] = assetURL;
    videoMessageDict[kXMNMessageConfigurationImageKey] = [ChatBusiness firstFrameWithVideoURL:assetURL];
    videoMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    videoMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    videoMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    videoMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    videoMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    videoMessageDict[kXMNMessageConfigurationTimeKey] = time;
     [self timeCompare:videoMessageDict withTime:time];
    

    
    [self addMessage:videoMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar scrollBottom:(BOOL)animated {
    [self scrollToBottom:animated];
}

- (void)chatBarFrameDidChange:(XMChatBar *)chatBar frame:(CGRect)frame{
    
    
    if (frame.origin.y == self.tableView.frame.size.height) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:CGRectMake(0, 0, kScreen_Width, frame.origin.y)];
        [self scrollToBottom:NO];
    }];
}




#pragma mark - XMNChatMessageCellDelegate
- (void)messageCellFailState:(XMNChatMessageCell *)messageCell {
    
    [CHCUI presentAlertStyleDefauleForTitle:@"温馨提示" andMessage:@"您是否要重发这条消息!" andCancel:^(UIAlertAction *action) {
        
    } andDefault:^(UIAlertAction *action) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
        NSDictionary *message = self.dataArray[indexPath.row];
        [self.chatViewModel sendMessage:message];
        
    } andCompletion:^(UIAlertController *alert) {
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }];
    
}

- (void)messageCellTappedHead:(XMNChatMessageCell *)messageCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if ([self.alarm isEqualToString:dict[kXMNMessageConfigurationAlarmKey]]) {
        UserInfoViewController *userController = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userController animated:YES];
    }else {
        UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
        userDes.RE_alarmNum = dict[kXMNMessageConfigurationAlarmKey];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatType = [user objectForKey:@"chatType"];
        if ([chatType isEqualToString:@"S"]) {
          userDes.cType = ChatControlelr;
        }else if ([chatType isEqualToString:@"G"]) {
           userDes.cType = Others;
        }
        userDes.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userDes animated:YES];
    }
}




- (void)messageCellTappedBlank:(XMNChatMessageCell *)messageCell {
   // NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    [self.chatBar endInputing];
    
    if(self.nearsetImage){
        [self.nearsetImage removeFromSuperview];
    }
}

- (void)messageCellTappedMessage:(XMNChatMessageCell *)messageCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
   
    switch (messageCell.messageType) {
        case XMNMessageTypeText:
        {
            NSMutableDictionary * dic =  self.dataArray[indexPath.row];
            NSString * str = dic[kXMNMessageConfigurationFireKey];
            
            NSString * ownerStr = [NSString stringWithFormat:@"%@",dic[kXMNMessageConfigurationOwnerKey]];
            
             if ([str containsString:@"LOCK"]){
                if (![ownerStr isEqualToString:@"2"]) {
                    
                    dic[kXMNMessageConfigurationFireKey] = @"UNLOCK";
                    ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[dic[kXMNMessageConfigurationQIDKey]integerValue]];
                   [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"UNLOCK"];
                    [self messageFirelForQid:model];
                    
                    NSString *  messageAtindex = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    [_selectLabelDic setObject:messageCell forKey:model.msGid];
                    messageCell.fireMessageTimeLabel.hidden = NO;
                    [self getTimeoutWith:messageCell withMSGID:model.msGid withInfo:dic[kXMNMessageConfigurationTextKey] withModel:model];
                    
                    [self.tableView reloadData];
                }
            }
        }
            break;
        case XMNMessageTypeImage:
        {
           // XMNChatImageMessageCell *imageCell = (XMNChatImageMessageCell *)messageCell;
            NSUInteger index = 0;
            NSMutableArray *photos = [NSMutableArray array];
            for (int i = 0; i < self.dataArray.count; i++) {
                NSDictionary *dict = self.dataArray[i];
                if ([dict[kXMNMessageConfigurationTypeKey] isEqual: @(XMNMessageTypeImage)]) {
                    id image = dict[kXMNMessageConfigurationImageKey];
                    if ([image isKindOfClass:NSString.class]) {
                        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:image]];
                        [photos addObject:photo];
                    } else if ([image isKindOfClass:UIImage.class]) {
                        IDMPhoto *photo = [IDMPhoto photoWithImage:image];
                        [photos addObject:photo];
                    }
                    if (i == indexPath.row) {
                        index = photos.count - 1;
                    }
                }
            }

            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
            // IDMPhotoBrowser功能设置
            browser.displayActionButton = NO;
            browser.displayArrowButton = NO;
            browser.displayCounterLabel = YES;
            browser.displayDoneButton = NO;
            browser.autoHideInterface = NO;
            browser.usePopAnimation = YES;
            browser.disableVerticalSwipe = YES;
           // browser.scaleImage = imageCell.messageImageView.image;
            // 设置初始页面
            [browser setInitialPageIndex:index];
            self.browser=browser;
            browser.longPressGesResponse=^(UIImage *image){
            self.image=image;
            [ZEBIdentify2Code detectorQRCodeImageWithSourceImage:image isDrawWRCodeFrame:NO completeBlock:^(NSArray *resultArray, UIImage *resultImage) {
                    if (resultArray.count==0) {
                    self.array=@[@"保存到相册"];
                    }else{
                    self.array=@[@"保存到相册",@"识别二维码"];
                        self.codeStr=resultArray.firstObject;
                    }
                    CollectCopyView *collect=[[CollectCopyView alloc]initWidthName:self.array];
                    collect.delegate=self;
                    [collect show];
                }];
            };
            self.modalPresentationStyle=UIModalPresentationPageSheet;
            UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:browser];
            
            [self presentViewController:navigation animated:YES completion:nil];
        }
            break;
        case XMNMessageTypeVoice:
        {
            NSString *voiceURL = [self.chatViewModel messageAtIndex:indexPath.row][kXMNMessageConfigurationVoiceKey];

            //1.检查URLString是本地文件还是网络文件
            if ([voiceURL hasPrefix:@"http"] || [voiceURL hasPrefix:@"https"]) {
                [[HttpsManager sharedManager] downloadAudio:voiceURL progress:^(NSProgress * _Nonnull progress) {
                    
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse) {
                    return targetPath;
                } completionHandler:^(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    
                    [[XMNAVAudioPlayer sharePlayer] playAudioWithURLString:[filePath absoluteString] atIndex:indexPath.row];
                }];
            } else {
                [[XMNAVAudioPlayer sharePlayer] playAudioWithURLString:voiceURL atIndex:indexPath.row];
            }
            
        }
            break;
        case XMNMessageTypeLocation:
        {
            ChatLocationViewController *vc = [[ChatLocationViewController alloc] init];
            vc.locationUrl = [self.chatViewModel messageAtIndex:indexPath.row][kXMNMessageConfigurationLocationKey];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case XMNMessageTypeVideo:
        {
            id videoPath = [self.chatViewModel messageAtIndex:indexPath.row][kXMNMessageConfigurationVideoKey];
            VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:videoPath];
            vc.videoLongPress=^(NSURL *filePath){
                self.filePath=filePath;
                NSArray *array=@[@"视频保存到相册"];
                CollectCopyView *collect=[[CollectCopyView alloc]initWidthName:array];
                collect.delegate=self;
                [collect show];
            };
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

- (void)messageCellDoubleTappedMessage:(XMNChatMessageCell *)messageCell {
    
    if (messageCell.messageType == XMNMessageTypeText) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
        NSDictionary *message = self.dataArray[indexPath.row];
        
        NSString * fireStr = [NSString stringWithFormat:@"%@",message[kXMNMessageConfigurationFireKey] ];
        NSString * ownerStr = [NSString stringWithFormat:@"%@",message[kXMNMessageConfigurationOwnerKey]];
        
        if ([ownerStr isEqualToString:@"2"]) {
            MessageDoubleTapViewController *messageVC = [[MessageDoubleTapViewController alloc] init];
            messageVC.textStr = message[kXMNMessageConfigurationTextKey];
            //        __weak  MessageDoubleTapViewController *weakVC = messageVC;
            //        messageVC.tapMissBlock = ^{
            //            [weakVC removeFromParentViewController];
            //
            //        };
            
            messageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:messageVC animated:YES completion:nil];
            
            //        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
            //        [keywindow addSubview:messageVC.view];
        }
        else if ([ownerStr isEqualToString:@"3"])
        {

            MessageDoubleTapViewController *messageVC = [[MessageDoubleTapViewController alloc] init];
            messageVC.textStr = [message[kXMNMessageConfigurationTextKey] transferredMeaningWithEnter];
            //        __weak  MessageDoubleTapViewController *weakVC = messageVC;
            //        messageVC.tapMissBlock = ^{
            //            [weakVC removeFromParentViewController];
            //
            //        };
            
            messageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:messageVC animated:YES completion:nil];

            if (![fireStr isEqualToString:@"LOCK"]) {
                MessageDoubleTapViewController *messageVC = [[MessageDoubleTapViewController alloc] init];
                messageVC.textStr = message[kXMNMessageConfigurationTextKey];
                //        __weak  MessageDoubleTapViewController *weakVC = messageVC;
                //        messageVC.tapMissBlock = ^{
                //            [weakVC removeFromParentViewController];
                //
                //        };
                
                messageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self.navigationController presentViewController:messageVC animated:YES completion:nil];
                
                //        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
                //        [keywindow addSubview:messageVC.view];
            }

            
        }

        
//        MessageDoubleTapViewController *messageVC = [[MessageDoubleTapViewController alloc] init];
//        messageVC.textStr = [message[kXMNMessageConfigurationTextKey] transferredMeaningWithEnter];
////        __weak  MessageDoubleTapViewController *weakVC = messageVC;
////        messageVC.tapMissBlock = ^{
////            [weakVC removeFromParentViewController];
////            
////        };
//        
//        messageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self.navigationController presentViewController:messageVC animated:YES completion:nil];
//
////        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
////        [keywindow addSubview:messageVC.view];
    }
    
}

//遮罩消失
//- (void)dismiss {
//    [self.treeVC selectCell];
//    [UIView animateWithDuration:.1 animations:^{
//        
//        self.unitView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self.overlayView removeFromSuperview];
//            [self.unitView removeFromSuperview];
//        }
//    }];
//}

- (void)messageCell:(XMNChatMessageCell *)messageCell withActionType:(XMNChatMessageCellMenuActionType)actionType textField:(NSString *)textField{

    if (actionType == XMNChatMessageCellMenuActionTypeCopy) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string =textField;
        
    }else if (actionType == XMNChatMessageCellMenuActionTypeRelay) {
        
        ChatMessageForwardController *forwardVC =[[ChatMessageForwardController alloc]init];
        forwardVC.messageID = [textField integerValue];
        UINavigationController *nvc =[[UINavigationController alloc]initWithRootViewController:forwardVC];
        [self presentViewController:nvc animated:YES completion:^{
        }];
        
    }else if (actionType == XMNChatMessageCellMenuActionTypeWithdraw) {
        
        ICometModel *iModel = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:[textField integerValue]];
        
        /*获取当前时间*/
        NSDate *data =[NSDate date];
        /*以 YYYY-MM-dd 格式把时间字符串打印*/
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *d1 = [dateFormatter stringFromDate:data];
        
        if ([ChatBusiness isTimeCompareWithATime:d1 WithBtime:iModel.beginTime]) {
             [self messageRecallForQid:iModel];
        }else {
           
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发送时间超过2分钟的信息，不能被撤回。" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action1];
            
            [self presentViewController:alertController animated:YES completion:^{
                
            }];

        }
       
    }
    
}
#pragma mark -
#pragma mark 消息撤回
- (void)messageRecallForQid:(ICometModel *)iModel {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"messagerecall";// action
    param[@"alarm"] = alarm;// 警号
    param[@"token"] = token;// token
    param[@"msgid"] = iModel.msGid;// 消息id
    param[@"rid"] = iModel.rid;// 接收方id
    
    [[HttpsManager sharedManager] post:MessageRecallUrl parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                             options:NSJSONReadingMutableContainers error:nil];
        
        ZEBLog(@"success-----%@",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZEBLog(@"fail");
    }];
}

#pragma mark -
#pragma mark 阅后即焚
- (void)messageFirelForQid:(ICometModel *)iModel
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"messageburn";// action
    param[@"alarm"] = alarm;// 警号
    param[@"token"] = token;// token
    param[@"qid"] = iModel.msGid;// 消息id
    param[@"rid"] = iModel.sid;// 发送方id
    
    [[HttpsManager sharedManager] post:MessageFirelUrl parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - XMNChatViewModelDelegate

- (NSString *)chatterNickname {
    return self.chatterName;
}

- (NSString *)chatterHeadAvator {
    return self.chatterThumb;
}

- (void)messageReadStateChanged:(XMNMessageReadState)readState withProgress:(CGFloat)progress forIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    XMNChatMessageCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView.visibleCells containsObject:messageCell]) {
        return;
    }
    messageCell.messageReadState = readState;
}

- (void)messageSendStateChanged:(XMNMessageSendState)sendState withProgress:(CGFloat)progress forIndex:(NSUInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    XMNChatMessageCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (self.fireMessageType == messageLock) {
        messageCell.fireMessageType = messageLock;
    }
    
    if (![self.tableView.visibleCells containsObject:messageCell]) {
        return;
    }
    if (messageCell.messageType == XMNMessageTypeImage) {
        [(XMNChatImageMessageCell *)messageCell setUploadProgress:progress];
    } else if (messageCell.messageType == XMNMessageTypeVideo) {
        [(XMNChatVideoMessageCell *)messageCell setUploadProgress:progress];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        messageCell.messageSendState = sendState;                                                                       
    });
}

- (void)reloadAfterReceiveMessage:(NSDictionary *)message {
    
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatViewModel.messageCount - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - XMNAVAudioPlayerDelegate

- (void)audioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    XMNChatVoiceMessageCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        [voiceMessageCell setVoiceMessageState:audioPlayerState];
    });
}

#pragma mark - Private Methods

- (void)addMessage:(NSDictionary *)message {
    
    NSString *cuid = message[kXMNMessageConfigurationCUIDKey];
    NSMutableDictionary *msg = [NSMutableDictionary  dictionaryWithDictionary:message];
    if ([[LZXHelper isNullToString:cuid] isEqualToString:@""]) {
        msg[kXMNMessageConfigurationCUIDKey] = [LZXHelper createCUID];
    }
    
    [self.chatViewModel addMessage:msg];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatViewModel.messageCount - 1 inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [self.chatViewModel sendMessage:msg];
}

/**
 *  让tableView滚动到最底部
 */
- (void)scrollToBottom:(BOOL)animated {
    // 1.获取最后一行
    if (self.dataArray.count == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)scrollToRow:(BOOL)animated row:(NSUInteger)row {
    // 1.获取最后一行
    if (self.dataArray.count == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - row) + 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - Getters

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kMinHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(66, 0, 0, 0);
        _tableView.delegate = self.chatViewModel;
        _tableView.dataSource = self.chatViewModel;
        [_tableView registerXMNChatMessageCellClass];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.count++;
            [weakSelf loadNewData];
        }];
        _tableView.mj_header = refreshHeader;
        }
    return _tableView;
}

# pragma to_do
-(void)loadNewData{
    
    if (_isExistTimeout == YES) {
         [self.tableView.mj_header endRefreshing];
        return;
    }
    
    self.page=[[[DBManager sharedManager] MessageDAO] getSelectMessagesCount:self.chatType];
    
    if (self.count > self.page) {
        
//            __block NSUInteger msgStateIndex;
            NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            NSInteger qid = 0;
            if ([@"S" isEqualToString:self.chatType]) {
                qid = [[[DBManager sharedManager] MessageDAO] getMinQidSingle];
            } else if ([@"G" isEqualToString:self.chatType]) {
                qid = [[[DBManager sharedManager] MessageDAO] getMinQidGroup];
        }
            paramDict[@"rid"] = self.rid;
            paramDict[@"sid"] = self.sid;
            paramDict[@"alarm"] = alarm;
            paramDict[@"token"] = token;
            paramDict[@"action"] = @"getappmessage";
            paramDict[@"qid"] = [NSString stringWithFormat:@"%ld",qid];

        
            [[HttpsManager sharedManager]post:RequestNewUrl parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                
                BaseResponseModel *responseResult=[BaseResponseModel ResponseWithData:reponse];
                if ([responseResult.resultcode integerValue]==0) {
                    
                    UserChatModel *user=[UserChatModel UserChatWithData:reponse];

                    NSMutableArray *messageArray=[NSMutableArray array];
                    NSArray *reversedArray=[NSArray new];
                    //将数据按照qid排序
                    NSArray *results = [user.results sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        chatModel *model1 = obj1;
                        chatModel *model2 = obj2;
                        NSComparisonResult result = [[NSString stringWithFormat:@"%ld",model1.QID] compare:[NSString stringWithFormat:@"%ld",model2.QID]];
                        return result == NSOrderedAscending;
                    }];
                 //   ZEBLog(@"2----------%@",results);
                    //                chatModel *lastModel = [results lastObject];
                    //                self.qid = lastModel.QID;
                    for (chatModel *iModel in results) {
                        if (![[[DBManager sharedManager] MessageDAO] selectMessageByMsgid:iModel.MSGID]){
//                        UserlistModel *userListModel = [[[DBManager sharedManager] UserlistDAO] selectUserlistById:iModel.RID];
//                        if (userListModel) {
//                            if ([ChatBusiness isTimeCompareWithTime:iModel.beginTime WithBtime:userListModel.ut_time]) {
//                                iModel.beginTime = iModel.TIME;
//                            }else {
//                                iModel.beginTime = @"0";
//                            }
//                        }else {
//                            iModel.beginTime = iModel.TIME;
//                        }
//                        
                        
                        if ([iModel.CMD isEqualToString:@"1"]) {
                            
                            [[[DBManager sharedManager] MessageDAO] insertMessageOfchatModell:iModel];
                            
                        }else if ([iModel.CMD isEqualToString:@"2"]) {
                            
                        }else if ([iModel.CMD isEqualToString:@"3"]) {
                            //格式化model
                            [ChatBusiness backChatModel:iModel];
                            
                        }else if ([iModel.CMD isEqualToString:@"4"]) {
                            if ([iModel.MSG.MTYPE isEqualToString:@"7"]) {
                                [ChatBusiness backSystemChatmodel:iModel];
                            }
                        }else if ([iModel.CMD isEqualToString:@"5"]) {
                            [[[DBManager sharedManager] MessageDAO] insertMessageOfchatModell:iModel];
                        }
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[kXMNMessageConfigurationTextKey] = iModel.MSG.DATA;
                        if ([@"S" isEqualToString:self.chatType]) {
                            dict[kXMNMessageConfigurationGroupKey] = @(XMNMessageChatSingle);
                        } else if ([@"G" isEqualToString:self.chatType]) {
                            dict[kXMNMessageConfigurationGroupKey] = @(XMNMessageChatGroup);
                        }
                        //放在ChatBusiness处理
                        [ChatBusiness getHistoryReloadView:dict chatModel:iModel];
                        
                            //if (![dict[kXMNMessageConfigurationFireKey] isEqualToString:@"READ"]) {
                                [messageArray addObject:dict];
                          //  }
                        
                        reversedArray=[[messageArray reverseObjectEnumerator]allObjects];
                        
//                        msgStateIndex = [reversedArray indexOfObject:dict];
                        
                        [[XMNMessageStateManager shareManager] updateMessageSendState:XMNMessageSendSuccess forArray:reversedArray];
                    }
                    }
                    [self.tableView.mj_header endRefreshing];
                    NSRange range=NSMakeRange(0,reversedArray.count);
                    NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:range];
                    NSUInteger count = self.dataArray.count + 1;
                    
                    [self.dataArray insertObjects:reversedArray atIndexes:set];
                    [self.tableView reloadData];
                    
                    
                    if (count > 3) {
                        [self scrollToRow:NO row:count];
                    }
                    [self scrollToRow:NO row:count];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [self.tableView.mj_header endRefreshing];
            }];
        
        }else{
       //int newcount=++self.count;
            NSMutableArray *msgArray = [NSMutableArray array];
            NSArray *reversedArray=[NSArray new];
            NSMutableArray *dbArray=[[[DBManager sharedManager]MessageDAO]selectMessages:self.chatType maxQid:self.qid page:self.count];
            ICometModel *lastModel = [dbArray lastObject];
            self.qid = lastModel.qid;
        for (ICometModel *iModel in dbArray) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            dict[kXMNMessageConfigurationTextKey] = iModel.data;
            if ([@"S" isEqualToString:self.chatType]) {
                dict[kXMNMessageConfigurationGroupKey] = @(XMNMessageChatSingle);
            } else if ([@"G" isEqualToString:self.chatType]) {
                dict[kXMNMessageConfigurationGroupKey] = @(XMNMessageChatGroup);
            }
             //放在ChatBusiness处理
            [ChatBusiness getNewsForDb:dict iComdeModel:iModel];
            
          //  if (![dict[kXMNMessageConfigurationFireKey] isEqualToString:@"READ"]) {
                [msgArray addObject:dict];
          //  }
            reversedArray=[[msgArray reverseObjectEnumerator]allObjects];
            
            [[XMNMessageStateManager shareManager] updateMessageSendState:XMNMessageSendSuccess forArray:reversedArray];
        }
            
        [self.tableView.mj_header endRefreshing];
        NSRange range=NSMakeRange(0,reversedArray.count);
        NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:range];
        NSUInteger count = self.dataArray.count + 1;
        [self.dataArray insertObjects:reversedArray atIndexes:set];
        [self.tableView reloadData];
        
        [self scrollToRow:NO row:count];
            
    }
    
   
}


- (XMChatBar *)chatBar {
    if (!_chatBar) {
//        _chatBar = [XMChatBar new];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatType = [user objectForKey:@"chatType"];
        _chatBar = [[XMChatBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kMinHeight, self.view.frame.size.width, kMinHeight)];
        _chatBar.delegate = self;
        if ([chatType isEqualToString:@"S"])
        {
            _chatBar.chatBarType = ChatBarShowNomalSingel;
        }
        else if ([chatType isEqualToString:@"G"])
        {
            _chatBar.chatBarType = ChatBarShowNomalGroup;
        }
        _chatBar.winHeight = kScreenHeight;
    }
    return _chatBar;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.count=1;
        _dataArray = [NSMutableArray array];
        
        NSMutableArray *msgArray = [NSMutableArray array];
        NSArray *reversedArray=[NSArray new];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatType = [user objectForKey:@"chatType"];
        self.chatType=chatType;
        MessageDAO *messageDAO = [[DBManager sharedManager] MessageDAO];
        UploadingSQ *uploadingSQ = [[DBManager sharedManager] uploadingSQ];
        self.page=[[[DBManager sharedManager] MessageDAO] getSelectMessagesCount:self.chatType];
        NSInteger maxQid = 0;
        if ([@"S" isEqualToString:chatType]) {
            maxQid = [messageDAO getMaxQidSingle];
        } else if ([@"G" isEqualToString:chatType]) {
            maxQid = [messageDAO getMaxQidGroup];
        }
        
        NSMutableArray *dbArray = (NSMutableArray *)[messageDAO selectMessages:chatType maxQid:maxQid page:self.count];
        NSArray *uploadingArray = [uploadingSQ selectUploading];
        NSArray *tempArray = [NSArray arrayWithArray:dbArray];
        for (int j = 0; j < uploadingArray.count; j++) {
            ICometModel *model1 = uploadingArray[j];
            for (int i = 0; i < tempArray.count; i++) {
                ICometModel *model2 = dbArray[i];
                if (model2.qid == model1.qid) {
                    [dbArray insertObject:model1 atIndex:i];
                    break;
                }
            }
        }
        
        //添加发送失败的消息
        MessageResendSQ *messageRendSQ = [[DBManager sharedManager] messageResendSQ];
        NSArray *failMessageArray = [messageRendSQ selectMessage];
        failMessageArray = [[failMessageArray reverseObjectEnumerator]allObjects];
        if (failMessageArray) {
            for (int j = 0; j < failMessageArray.count; j++) {
                ICometModel *model1 = failMessageArray[j];
                for (int i = 0; i < tempArray.count; i++) {
                    ICometModel *model2 = dbArray[i];
                    if (model2.qid == model1.qid) {
                        [dbArray insertObject:model1 atIndex:i];
                        break;
                    }
                }
            }
        }
        
        ICometModel *lastModel = [dbArray lastObject];
        ZEBLog(@"1----------%@",dbArray);
        self.qid = lastModel.qid;
        // 将数据库中的消息记录信息数组转换成显示到界面上的数组
        for (ICometModel *iModel in dbArray) {
           // if (![iModel.FIRE isEqualToString:@"READ"]) {
                self.rid=iModel.rid;
                self.sid=iModel.sid;
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[kXMNMessageConfigurationTextKey] = iModel.data;
                if ([@"S" isEqualToString:chatType]) {
                    dict[kXMNMessageConfigurationGroupKey] = @(XMNMessageChatSingle);
                } else if ([@"G" isEqualToString:chatType]) {
                    dict[kXMNMessageConfigurationGroupKey] = @(XMNMessageChatGroup);
                }
                //放在ChatBusiness处理
                [ChatBusiness getNewsForDb:dict iComdeModel:iModel];
                 [msgArray addObject:dict];
                reversedArray=[[msgArray reverseObjectEnumerator]allObjects];
          //  }
           
            }
        [_dataArray addObjectsFromArray:reversedArray];
    }
    
    return _dataArray;
}
#pragma mark -
#pragma mark 输入@触发的方法
- (void)chatBarForAt:(XMChatBar *)chatBar {
    
    NSString *chatType = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatType"];
    if ([@"G" isEqualToString:chatType]) {
        ChatGroupAtController *atController = [[ChatGroupAtController alloc] init];
        [self.navigationController pushViewController:atController animated:YES];
    }
}
#pragma mark 键盘显示时会触发的方法
-(void)kbWillShow:(NSNotification *)noti {
    // 4.把消息现在在顶部
    [self scrollToBottom:NO];
    
    
}

#pragma mark 键盘退出时会触发的方法
-(void)kbWillHide:(NSNotification *)noti{
    
    [self.nearsetImage removeFromSuperview];
    
}
- (UILabel *)attentionLabel {

    if (_attentionLabel == nil) {
        _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, kScreenWidth-40, 0)];
        _attentionLabel.font = ZEBFont(15);
        _attentionLabel.textColor = [UIColor whiteColor];
        _attentionLabel.backgroundColor = [UIColor grayColor];
        _attentionLabel.alpha = 0.6;
        _attentionLabel.layer.masksToBounds = YES;
        _attentionLabel.textAlignment = NSTextAlignmentCenter;
        _attentionLabel.layer.cornerRadius = 5;
        
    }
    return _attentionLabel;
}
#pragma mark - Masonry
- (void)makeConstraints {
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-kMinHeight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chatBar.mas_top);
        make.top.right.and.left.equalTo(self.view);
    }];
}


//collectcopyView--Delegate
-(void)collectCopy:(CollectCopyView *)view index:(NSInteger)index title:(NSString *)title{

    
    if ([title isEqualToString:@"保存到相册"]) {
        [self saveImageToPhoto];
    }
    if ([title isEqualToString:@"识别二维码"]) {
        [self handelURLString:self.codeStr];
    }
    if ([title isEqualToString:@"视频保存到相册"]) {
        [self saveVideoToPhoto];
    }
    
}

//保存图片到相册
-(void)saveImageToPhoto{
    
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        [self showHint:@"保存成功"];
    }else{
        [self showHint:@"保存失败"];
    }
}

//保存视频到相册

-(void)saveVideoToPhoto{

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:self.filePath
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (!error) {
                                        [self showHint:@"保存成功"];
                                    } else {
                                        [self showHint:@"保存失败"];
                                    }
                                }];
}




// 处理扫描的字符串
-(void)handelURLString:(NSString *)string
{
    if ([ZEBUtils checkURLHTTPWWW:string]) {//判断是不是URL
        
        QRCodelWebController *web = [[QRCodelWebController alloc] init];
        web.title = @"扫描结果";
        web.detailURL = string;
        [self.browser.navigationController pushViewController:web animated:YES];
        
    }else {
        
        NSDictionary *dic = [self dictionaryWithJsonString:string];
        
        if ([dic[@"type"] isEqualToString:@"1"]) {
            NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
            if ([dic[@"key"] isEqualToString:alarm]) {
                UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
                [self.browser.navigationController pushViewController:userInfoController animated:YES];
            }else {

                UserDesInfoController *userCon = [[UserDesInfoController alloc] init];
                userCon.RE_alarmNum = dic[@"key"];
                if (self.cType == ChatList) {
                    userCon.cType = Others;
                }else if (self.cType == GroupTeam) {
                    userCon.cType = GroupController;
                }else if (self.cType == SearchC) {
                    userCon.cType = Search;
                }
                userCon.cgType = Code;
//                self.browser.navigationController.navigationBar.hidden = NO;
                [self.browser.navigationController pushViewController:userCon animated:YES];
                
                
            }
            
        }else if ([dic[@"type"] isEqualToString:@"2"]) {
            QRResultGroupController *groupCon = [[QRResultGroupController alloc] init];
            groupCon.gid = dic[@"gid"];
            groupCon.gname = dic[@"gname"];
            groupCon.gtype = dic[@"gtype"];
            groupCon.otherAlarm = dic[@"alarm"];
            if (self.cType == ChatList) {
                groupCon.myType = CHATLISTQRRESULT;
            }else if (self.cType == GroupTeam) {
                groupCon.myType = CONTACTQRRESULT;
            }else if (self.cType == SearchC) {
                
            }
            [self.browser.navigationController pushViewController:groupCon animated:YES];
            
        }else {
            QRCodelWebController *web = [[QRCodelWebController alloc] init];
            web.title = @"扫描结果";
            web.codeStr = string;
            [self.browser.navigationController pushViewController:web animated:YES];
        }
    }
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
       
        return nil;
    }
    return dic;
}

- (void)clickLinkUrl:(NSNotification *)notification {
    
    NSString *url = notification.object;
    QRCodelWebController *web = [[QRCodelWebController alloc] init];
    web.detailURL = url;
    [self.navigationController pushViewController:web animated:YES];
}


-(void)sendNearestImage:(NSNotification *)notification
{
    self.nearsetImage = [[NearestImage alloc]init];
    self.nearsetImage.backgroundColor =[UIColor whiteColor];

    [self.nearsetImage configureImage:notification.object];
    self.nearsetImage.layer.masksToBounds = YES;
    self.nearsetImage.layer.cornerRadius =10;
    self.nearsetImage.userInteractionEnabled =YES;
    [self.view addSubview:self.nearsetImage];
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendImageClick:)];
    [self.nearsetImage addGestureRecognizer:tap];
    [self.nearsetImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.chatBar.mas_top).with.offset(-10);
        make.height.offset(100);
        make.width.offset(80);
    }];
    
    
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveLinear animations:^{
        self.nearsetImage.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
        if (self.nearsetImage != nil) {
            self.nearsetImage.alpha = 0;
            [self.nearsetImage removeFromSuperview];
        }
    }];
}

-(void)sendImageClick:(UITapGestureRecognizer *)ges
{
    NearestImage *img = ges.view;
    [self chatBar:self.chatBar sendPictures:@[img.img.image]];
    [img removeFromSuperview];
}


-(void)reloadChatGroupName:(NSNotification *)notification
{
    NSMutableDictionary *param = notification.object;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    if ([param[@"gid"] isEqualToString:chatId]) {
        self.title = param[@"gName"];
    }

}

//- (void)removeFireMessageWithAtindexWithIndex:(NSString*)index
//{
//    [_selectIndexArray addObject:index];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_selectIndexArray removeObjectAtIndex:0];
//        [self.chatViewModel removeMessageAtIndex:[_selectIndexArray[0]integerValue]];
//        [_selectLabelDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
//        [self.tableView reloadData];
//        });
//}

- (void)fireMessageBeRead:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo[@"readQid"]);
    for (NSDictionary * dic in _dataArray) {
        NSString * str = [NSString stringWithFormat:@"%@",dic[kXMNMessageConfigurationQIDKey]];
        
        if ([str isEqualToString:notification.userInfo[@"readQid"]]) {
            [_dataArray removeObject:dic];
        }
    }
    [self.tableView reloadData];
}

//按钮变成倒计时
-(void)getTimeoutWith:(XMNChatMessageCell*)messageCell withMSGID:(NSString *)string withInfo:(NSString*)info withModel:(ICometModel*)model
{
    
    if (![_selectIndexArray containsObject:model.msGid]) {
        
        XMNChatMessageCell * messageSelectCell = [_selectLabelDic objectForKey:model.msGid];
        
        [_selectIndexArray addObject:model.msGid];
        
        int a = info.length;
        __block int timeout ;
        if (a>18) {
            timeout = 11+(a-18)/2;
        }
        else
        {
            timeout = 11;
        }
        
        dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0)
            {
                dispatch_source_cancel(_timer);
                
                 _isExistTimeout = NO;
                
                [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
                [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_selectIndexArray removeObject:model.msGid];
                    // [[NSNotificationCenter defaultCenter]postNotificationName:@"showtimeout" object:nil];
                    //timeout = 0;
                   
                    [self refreshUI:nil];
                });
            }else{
                
                _isExistTimeout = YES;
                
                 [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:[NSString stringWithFormat:@"%d",timeout]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    messageSelectCell.fireMessageTimeLabel.text = [NSString stringWithFormat:@"%d",timeout];
                   
                  //  [self refreshUI:nil];
                });
                
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
}

@end
