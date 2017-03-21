//
//  ChatViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//


#import "ChatViewController.h"

#import <AudioToolbox/AudioToolbox.h>
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
#import "GroupDesModel.h"
#import "XMNMessageStateManager.h"
#import "MessageDoubleTapViewController.h"
#import "ZEBPhotoBrowser.h"
#import "Photo.h"
#import "UIImage+UIImageScale.h"
#import "ChatTableView.h"
#import "EmojiViewController.h"
#import "CreateCollCallViewController.h"

#import "CJFlieLookUpVC.h"
#import "XMNChatFileMessageCell.h"

#import "GroupMemberBaseModel.h"
#import "GroupMemberModel.h"

@class chatModel;

@interface ChatViewController () <XMChatBarDelegate,XMNAVAudioPlayerDelegate,XMNChatMessageCellDelegate,XMNChatViewModelDelegate,CollectCopyDelegate> {
    UIActivityIndicatorView* _activity;
    UIView* _headView;
}



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
//@property (nonatomic,strong)IDMPhotoBrowser *browser;
@property (nonatomic,strong)ZEBPhotoBrowser *browser;
@property (nonatomic,assign) BOOL hidden;

@property(nonatomic,strong)NearestImage  *nearsetImage;

@property (nonatomic,assign) BOOL isShowBrowser;
@property (nonatomic, assign) BOOL isDeleteLoadNewData;

@property (nonatomic, strong) NSMutableArray *memberDataArray;
@end

@implementation ChatViewController

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
    [[SDImageCache sharedImageCache] clearMemory];
}
-(void)configChatBarParamData
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"gid"] = self.rid;
    param[@"alarm"] = self.alarm;
    param[@"token"] = self.token;
    param[@"gname"] = self.chatterName;
    
    self.chatBar.paramData = param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.chatterName;
    
    [XMNAVAudioPlayer sharePlayer].delegate = self;
    self.chatViewModel = [[XMNChatViewModel alloc] initWithParentVC:self];
    //set chat server
    self.chatViewModel.delegate = self;
    
    self.chatViewModel.dataArray = self.dataArray;
    self.chatViewModel.chatBar = self.chatBar;
    
    [self configChatBarParamData];
    
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
    
    [self scrollToBottom:NO];
    
    //发送相册中最近的照片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendNearestImage:) name:@"SendNearestImageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"ChatControllerBackNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUIByMessageCuid:) name:@"refreshUIByMessageCuid" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatGroupName:) name:RefreshGroupNameNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"AllMessageReloadNotification" object:nil];
    
    //地图聊天群跳转点名
    WeakSelf
    [LYRouter registerURLPattern:@"ly://mapGroupGotoCallRoll" toHandler:^(NSDictionary *routerParameters) {
        
        [weakSelf httpGetGroupMemberInfo];
    }];
    
}
- (void)deleteMe:(NSNotification *)notification {
    
}

#pragma mark -
#pragma mark 自己发消息自己回调
- (void)refreshUIByMessageCuid:(NSNotification *)notification {
    ICometModel *model = notification.object;
    NSInteger count = self.dataArray.count;
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *message = self.dataArray[i];
        if ([model.cuid isEqualToString:message[kXMNMessageConfigurationCUIDKey]]) {
            message[kXMNMessageConfigurationQIDKey] = [NSString stringWithFormat:@"%ld",model.qid];
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)back {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:chatId];
    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:chatId];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isShowBrowser) {
        self.navigationController.navigationBar.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
    
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
    ICometModel *model = notification.object;
    NSInteger index = [self modelIndex:model];
    if (index >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSInteger)modelIndex:(ICometModel *)model {
    
    NSInteger j = -1;
    NSInteger count = self.chatViewModel.dataArray.count;
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *message = self.chatViewModel.dataArray[i];
        if ([model.cuid isEqualToString:message[kXMNMessageConfigurationCUIDKey]]) {
            message[kXMNMessageConfigurationQIDKey] = @(model.qid);
            j = i;
            break;
        }
    }
    return j;
}
#pragma mark - 比较时间

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
//                //                dict[kXMNMessageConfigurationTimeKey] = _beginTime;
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

- (void)chatBar:(XMChatBar *)chatBar sendMessage:(NSString *)message withType:(ChatFireMessageType)messageType {
    

    NSMutableDictionary *textMessageDict = [NSMutableDictionary dictionary];
    
    if ([message rangeOfString:@"[img]file:///storage/emulated/0/MicroRecon/Emoticons/"].location == NSNotFound) {
        textMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeText);
    }else {
        textMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeEmotions);
    }
    textMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    textMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    textMessageDict[kXMNMessageConfigurationTextKey] = message;
    textMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    textMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    textMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    textMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    textMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    textMessageDict[kXMNMessageConfigurationTimeKey] = time;
    
    [self timeCompare:textMessageDict withTime:time];
    [self addMessage:textMessageDict];
    
    
}

- (void)chatBar:(XMChatBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds withType:(ChatFireMessageType)messageType{
    
    NSMutableDictionary *voiceMessageDict = [NSMutableDictionary dictionary];
    voiceMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVoice);
    voiceMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    voiceMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    voiceMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    voiceMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    voiceMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    voiceMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
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

- (void)chatBar:(XMChatBar *)chatBar sendPictures:(NSArray *)pictures withType:(ChatFireMessageType)messageType{
    
    NSMutableDictionary *imageMessageDict = [NSMutableDictionary dictionary];
    imageMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeImage);
    imageMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    imageMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    imageMessageDict[kXMNMessageConfigurationImageKey] = [pictures firstObject];
    imageMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    imageMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    imageMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    imageMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    imageMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    imageMessageDict[kXMNMessageConfigurationTimeKey] = time;
    [self timeCompare:imageMessageDict withTime:time];
    
    [self addMessage:imageMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendLocation:(NSString *)location locationText:(NSString *)locationText{
    NSMutableDictionary *locationMessageDict = [NSMutableDictionary dictionary];
    locationMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeLocation);
    locationMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    locationMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    locationMessageDict[kXMNMessageConfigurationTextKey] = locationText;
    locationMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    locationMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    locationMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    locationMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
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
    videoMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeVideo);
    videoMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    videoMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    videoMessageDict[kXMNMessageConfigurationVideoKey] = assetURL;
    videoMessageDict[kXMNMessageConfigurationImageKey] = [self firstFrameWithVideoURL:assetURL];
    videoMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    videoMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    videoMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    videoMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    videoMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
//    videoMessageDict[kXMNMessageConfigurationTimeKey] = time;
    [self timeCompare:videoMessageDict withTime:time];
    
    [self addMessage:videoMessageDict];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendfile:(CJFileObjModel *)fileModel {
    NSMutableDictionary *fileMessageDict = [NSMutableDictionary dictionary];
    //    locationMessageDict[kXMNMessageConfigurationQIDKey] =@(self.qid);
    fileMessageDict[kXMNMessageConfigurationTypeKey] = @(XMNMessageTypeFiles);
    fileMessageDict[kXMNMessageConfigurationOwnerKey] = @(XMNMessageOwnerSelf);
    fileMessageDict[kXMNMessageConfigurationGroupKey] = @(self.messageChatType);
    fileMessageDict[kXMNMessageConfigurationTextKey] = fileModel.name;
    fileMessageDict[kXMNMessageConfigurationNicknameKey] = self.name;
    fileMessageDict[kXMNMessageConfigurationAvatarKey] = self.headpic;
    fileMessageDict[kXMNMessageConfigurationDETypeKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEType];
    fileMessageDict[kXMNMessageConfigurationDENameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:DEName];
    fileMessageDict[kXMNMessageConfigurationAlarmKey] = self.alarm;
    fileMessageDict[kXMNMessageConfigurationFileSizeKey] = fileModel.fileSize;
    fileMessageDict[kXMNMessageConfigurationFileKey] = fileModel;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    //    locationMessageDict[kXMNMessageConfigurationTimeKey] = time;
    
    [self timeCompare:fileMessageDict withTime:time];
    [self addMessage:fileMessageDict];
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
        
        [self.myUIViewController.navigationController presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)messageCellTappedHead:(XMNChatMessageCell *)messageCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if ([self.alarm isEqualToString:dict[kXMNMessageConfigurationAlarmKey]]) {
        UserInfoViewController *userController = [[UserInfoViewController alloc] init];
        [self.myUIViewController.navigationController pushViewController:userController animated:YES];
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
        [self.myUIViewController.navigationController pushViewController:userDes animated:YES];
    }
}

- (void)messageCellTappedBlank:(XMNChatMessageCell *)messageCell {
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    [self.chatBar endInputing];
    if(self.nearsetImage){
        [self.nearsetImage removeFromSuperview];
    }
    
}

- (void)messageCellTappedMessage:(XMNChatMessageCell *)messageCell {
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    switch (messageCell.messageType) {
        case XMNMessageTypeEmotions:
        {
            NSMutableDictionary * dic =  self.dataArray[indexPath.row];
            NSString *image = dic[kXMNMessageConfigurationTextKey];
            NSArray *images = [image componentsSeparatedByString:@"/"];
            EmojiViewController *emojiCon = [[EmojiViewController alloc] init];
            emojiCon.emojiName = [images lastObject];
            [self.myUIViewController.navigationController pushViewController:emojiCon animated:YES];
        }
            break;
        case XMNMessageTypeImage:
        {
            XMNChatImageMessageCell *imageCell = (XMNChatImageMessageCell *)messageCell;
            NSUInteger index = 0;
            NSMutableArray *photos = [NSMutableArray array];
            for (int i = 0; i < self.dataArray.count; i++) {
                NSDictionary *dict = self.dataArray[i];
                if ([dict[kXMNMessageConfigurationTypeKey] isEqual: @(XMNMessageTypeImage)]) {
                    id image = dict[kXMNMessageConfigurationImageKey];
                    if ([image isKindOfClass:NSString.class]) {
                        //                        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:image]];
                        [photos addObject:image];
                    } else if ([image isKindOfClass:UIImage.class]) {
                        //                        IDMPhoto *photo = [IDMPhoto photoWithImage:image];
                        [photos addObject:image];
                    }
                    if (i == indexPath.row) {
                        index = photos.count - 1;
                    }
                }
            }
            ZEBPhotoBrowser *browser = [ZEBPhotoBrowser showFromImageView:imageCell.messageImageView withURLStrings:[self getImageArray:photos] placeholderImage:nil atIndex:index coverView:self.myUIViewController.view dismiss:^(UIImage * _Nullable image, NSInteger index) {
                self.navigationController.navigationBar.hidden = NO;
                self.isShowBrowser = NO;
            }];
            WeakSelf
            
            browser.progressView.hidden = YES;
            browser.timeLabel.hidden = YES;
            browser.longPressBlock=^(UIImage *image, Photo *photo){
                
                if (photo.original) {
                    if (photo.isDownload) {
                        weakSelf.image = [ZEBCache originalImageCacheUrl:photo.originalUrl];
//                        weakSelf.image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@&%@",photo.originalUrl,@"originalUrl"]];
                    }else{
                        weakSelf.image = image;
                    }
                }else {
                    weakSelf.image = image;
                }
                
                UIImage *sourceImage = [weakSelf.image compressionImageToDataMaxFileSize:500];
                [ZEBIdentify2Code detectorQRCodeImageWithSourceImage:sourceImage isDrawWRCodeFrame:NO completeBlock:^(NSArray *resultArray, UIImage *resultImage) {
                    if (resultArray.count==0) {
                        weakSelf.array=@[@"保存到相册"];
                    }else{
                        weakSelf.array=@[@"保存到相册",@"识别二维码"];
                        weakSelf.codeStr = resultArray.firstObject;
                    }
                    CollectCopyView *collect=[[CollectCopyView alloc]initWidthName:self.array];
                    collect.delegate=weakSelf;
                    [collect show];
                }];
            };
            browser.downLoadCompleteBlock = ^(UIImage *image) {
                [weakSelf.tableView reloadData];
            };
            
            self.browser = browser;
            self.isShowBrowser = YES;
            self.navigationController.navigationBar.hidden = YES;

//            NSUInteger index = 0;
//            NSMutableArray *photos = [NSMutableArray array];
//            for (int i = 0; i < self.dataArray.count; i++) {
//                NSDictionary *dict = self.dataArray[i];
//                if ([dict[kXMNMessageConfigurationTypeKey] isEqual: @(XMNMessageTypeImage)]) {
//                    id image = dict[kXMNMessageConfigurationImageKey];
//                    if ([image isKindOfClass:NSString.class]) {
//                        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:image]];
//                        [photos addObject:photo];
//                    } else if ([image isKindOfClass:UIImage.class]) {
//                        IDMPhoto *photo = [IDMPhoto photoWithImage:image];
//                        [photos addObject:photo];
//                    }
//                    if (i == indexPath.row) {
//                        index = photos.count - 1;
//                    }
//                }
//            }
//            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
//            // IDMPhotoBrowser功能设置
//            browser.displayActionButton = NO;
//            browser.displayArrowButton = NO;
//            browser.displayCounterLabel = YES;
//            browser.displayDoneButton = NO;
//            browser.autoHideInterface = NO;
//            browser.usePopAnimation = YES;
//            browser.disableVerticalSwipe = YES;
//            // 设置初始页面
//            [browser setInitialPageIndex:index];
//            self.browser=browser;
//            browser.longPressGesResponse=^(UIImage *image){
//                self.image=image;
//                
//                
//                [ZEBIdentify2Code detectorQRCodeImageWithSourceImage:image isDrawWRCodeFrame:NO  completeBlock:^(NSArray *resultArray, UIImage *resultImage) {
//                    
//                    if (resultArray.count==0) {
//                        self.array=@[@"保存到相册"];
//                    }else{
//                        self.array=@[@"保存到相册",@"识别二维码"];
//                        self.codeStr=resultArray.firstObject;
//                    }
//                    CollectCopyView *collect=[[CollectCopyView alloc]initWidthName:self.array];
//                    collect.delegate=self;
//                    [collect show];
//                    
//                }];
//                
//            };
//           
//            
//            self.myUIViewController.modalPresentationStyle=UIModalPresentationPageSheet;
//            UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:browser];
//            
//            [self.myUIViewController presentViewController:navigation animated:YES completion:nil];
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
            [self.myUIViewController.navigationController pushViewController:vc animated:YES];
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
            [self.myUIViewController presentViewController:vc animated:YES completion:nil];
        }
            break;
            case XMNMessageTypeReleaseTask:
        {
            NSDictionary *dic = [self.chatViewModel messageAtIndex:indexPath.row];
            NSInteger qid = [dic[kXMNMessageConfigurationQIDKey] integerValue];
            ICometModel *icModel = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
            [self BackWorkId:icModel];
        }
            break;
        case XMNMessageTypeFiles:
        {
            NSMutableDictionary * dic =  self.dataArray[indexPath.row];
            
            if ([dic[kXMNMessageConfigurationFileKey] isKindOfClass:[CJFileObjModel class]]) {
                CJFileObjModel *actualFile = dic[kXMNMessageConfigurationFileKey];
                NSString *cachePath =actualFile.filePath;
                NSLog(@"调用文件查看控制器%@---type %zd, %@",actualFile.name,actualFile.fileType,cachePath);
                CJFlieLookUpVC *vc = [[CJFlieLookUpVC alloc] initWithFileModel:actualFile];
                [self.myUIViewController.navigationController pushViewController:vc animated:YES];
            }
            else {
                CJFileObjModel *model = [CJFileObjModel new];
                
                NSString *message = dic[kXMNMessageConfigurationFileKey];
                
                NSDictionary *dict = [ChatBusiness jsonDataToDictionary:message];

                model.fileSize = dict[@"filesize"];
                model.filePath = dict[@"filelocalpath"];
                model.fileUrl = dict[@"fileurl"];
                model.name = dict[@"filename"];
                model.fileSizefloat = [dict[@"filebytes"] floatValue];
                
                //遍历目录下是否有该文件
                if ([[NSFileManager defaultManager] fileExistsAtPath:[HomeFilePath stringByAppendingPathComponent:model.name]]) {
                    model.filePath = [HomeFilePath stringByAppendingPathComponent:model.name];
                }
                
                    CJFlieLookUpVC *vc = [[CJFlieLookUpVC alloc] initWithFileModel:model];
                    vc.cancelBlock = ^(NSString *filePath){
                        
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:[HomeFilePath stringByAppendingPathComponent:model.name]]) {
                            dic[kXMNMessageConfigurationFileStateKey] = @(2); //已经下载
                        }else {
                            dic[kXMNMessageConfigurationFileStateKey] = @(0); //未下载
                        }
                        XMNChatFileMessageCell *cell = (XMNChatFileMessageCell *)messageCell;
                        
                        [cell setDownloadState:[dic[kXMNMessageConfigurationFileStateKey] integerValue]];
                        
                    };
                    
                    [self.myUIViewController.navigationController pushViewController:vc animated:YES];


                
            }
            
            
            
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
        
        
        
        MessageDoubleTapViewController *messageVC = [[MessageDoubleTapViewController alloc] init];
        messageVC.textStr = [message[kXMNMessageConfigurationTextKey] transferredMeaningWithEnter];

        
        messageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.myUIViewController presentViewController:messageVC animated:YES completion:nil];

        
        
    }
    
}


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
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }else if (actionType == XMNChatMessageCellMenuActionTypeDelete) {
        
        NSArray *indexArray = [textField componentsSeparatedByString:@","];
        if (![[[DBManager sharedManager] MessageDAO] deleteMessageForQid:[[indexArray firstObject] integerValue]]) {
            [self showHint:@"删除失败"];
            return;
        }
        NSInteger index = [[indexArray lastObject] integerValue];
        
        if (index == self.chatViewModel.dataArray.count-1) {
            if (index != 0) {
                NSDictionary *dict = self.chatViewModel.dataArray[index-1];
                NSInteger qid = [[NSString stringWithFormat:@"%@",dict[kXMNMessageConfigurationQIDKey]] integerValue];
                ICometModel *model = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
                [[[DBManager sharedManager] UserlistDAO] updateUserlist:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
            }else {
                [self XMNChatViewModelLoadNewData];
                self.isDeleteLoadNewData = YES;
                //                NSDictionary *dict = [self.dataArray lastObject];
                //                NSInteger qid = [[NSString stringWithFormat:@"%@",dict[kXMNMessageConfigurationQIDKey]] integerValue];
                //                ICometModel *model = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
                //                [[[DBManager sharedManager] UserlistDAO] updateUserlist:model];
            }
            
        }
        [self.chatViewModel.dataArray removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //deleteRowAtIndexPath, withRowAnimation 此方法决定删除cell的动画样式
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self performSelector:@selector(reloadtableViewNoAnimation) withObject:nil afterDelay:0.1];
    }
}
- (void)reloadtableViewNoAnimation {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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
#pragma mark 格式化图片数组
- (NSArray *)getImageArray:(NSArray *)arr {
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (id what in arr) {
        if ([what isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)what;
            NSMutableDictionary *parm = [NSMutableDictionary dictionary];
            if ([string containsString:@"?type=1"]) {
                NSArray *arr = [string componentsSeparatedByString:@"?"];
                NSString *parameterString = [arr lastObject];
                NSArray *sizeArr = [parameterString componentsSeparatedByString:@"&"];
                [parm setObject:[arr firstObject] forKey:@"originalUrl"];
                [parm setObject:string forKey:@"thumbnailUrl"];
                for (NSString *str in sizeArr) {
                    if ([str containsString:@"size"]) {
                        [parm setObject:[str substringFromIndex:5] forKey:@"size"];
                        break;
                    }
                }
                
            }else {
                [parm setObject:string forKey:@"thumbnailUrl"];
            }
            [tempArr addObject:parm];
        }else if ([what isKindOfClass:[UIImage class]]){
            [tempArr addObject:(UIImage *)what];
        }
        
    }
    return tempArr;
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
    [ChatBusiness isMenuvisibleOfSystem];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatViewModel.messageCount - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
// 下拉加载
- (void)XMNChatViewModelLoadNewData {
    self.count++;
    [self loadNewData];
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
- (void)addMessageArr:(NSMutableArray *)arr {
    
    for (NSDictionary *message in arr) {
        NSString *cuid = message[kXMNMessageConfigurationCUIDKey];
        NSMutableDictionary *msg = [NSMutableDictionary  dictionaryWithDictionary:message];
        if ([[LZXHelper isNullToString:cuid] isEqualToString:@""]) {
            msg[kXMNMessageConfigurationCUIDKey] = [LZXHelper createCUID];
        }
        
        [self.chatViewModel addMessage:msg];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatViewModel.messageCount - 1 inSection:0];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
   // [self.chatViewModel sendMessage:msg];
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

- (ChatTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ChatTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kMinHeight) style:UITableViewStylePlain];
        //_tableView.contentInset = UIEdgeInsetsMake(66, 0, 0, 0);
        _tableView.delegate = self.chatViewModel;
        _tableView.dataSource = self.chatViewModel;
        [_tableView registerXMNChatMessageCellClass];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            self.count++;
//            [self loadNewData];
//        }];
//        _tableView.mj_header = refreshHeader;
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _headView.backgroundColor = [UIColor clearColor];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.color = zBlackColor;
        [_headView addSubview:_activity];
        _activity.frame = CGRectMake(_headView.frame.size.width/2-10, _headView.frame.size.height/2-5, 20, 20);
        
        _tableView.tableHeaderView = _headView;
        _headView.hidden = YES;
    }

    return _tableView;
}
- (void)startRefreshing {
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _headView.hidden = NO;
    [_activity startAnimating];
    self.chatViewModel.isRefresh = YES;
}
- (void)endRefreshing {
    [_activity stopAnimating];
    _headView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }];
    self.chatViewModel.isRefresh = NO;
}
# pragma to_do
-(void)loadNewData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    [self startRefreshing];
    self.page=[[[DBManager sharedManager] MessageDAO] getSelectMessagesCount:self.chatType];
    
    //等待1s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
    dispatch_get_main_queue(), ^{
    if (self.count > self.page) {
        
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
                
                //                chatModel *lastModel = [results lastObject];
                //                self.qid = lastModel.QID;
                for (chatModel *iModel in results) {
                    
//                    UserlistModel *userListModel = [[[DBManager sharedManager] UserlistDAO] selectUserlistById:iModel.RID];
//                    if (userListModel) {
//                        if ([ChatBusiness isTimeCompareWithTime:iModel.beginTime WithBtime:userListModel.ut_time]) {
//                            iModel.TIME = iModel.beginTime;
//                        }else {
//                            iModel.TIME = @"0";
//                        }
//                    }else {
//                        iModel.TIME = iModel.beginTime;
//                    }
                    
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
                        [[[DBManager sharedManager] taskMarkSQ] insertTaskMarkFormChatModel:iModel];
                        
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
                    
                    if (![[[DBManager sharedManager] MessageDAO ]selectMessageByMsgid:iModel.MSGID]) {
                        [messageArray addObject:dict];
                    }
                    reversedArray=[[messageArray reverseObjectEnumerator]allObjects];
                    [[XMNMessageStateManager shareManager] updateMessageSendState:XMNMessageSendSuccess forArray:reversedArray];
                }
                [self.tableView.mj_header endRefreshing];
                NSRange range=NSMakeRange(0,reversedArray.count);
                NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:range];
                NSUInteger count = self.dataArray.count + 1;
                [self.dataArray insertObjects:reversedArray atIndexes:set];
                [self.tableView reloadData];
                [self endRefreshing];
                if (self.isDeleteLoadNewData) {
                    if (self.dataArray.count > 0) {
                        NSDictionary *dict = [self.dataArray lastObject];
                        NSInteger qid = [[NSString stringWithFormat:@"%@",dict[kXMNMessageConfigurationQIDKey]] integerValue];
                        ICometModel *model = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
                        [[[DBManager sharedManager] UserlistDAO] updateUserlist:model];
                        self.isDeleteLoadNewData = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
                    }else {
                        [[[DBManager sharedManager] UserlistDAO] deleteUserlist:chatId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
                    }
                }

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self endRefreshing];
          // [self.tableView.mj_header endRefreshing];
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
            
            [msgArray addObject:dict];
            reversedArray=[[msgArray reverseObjectEnumerator]allObjects];
            
            [[XMNMessageStateManager shareManager] updateMessageSendState:XMNMessageSendSuccess forArray:reversedArray];
        }
        
      //  [self.tableView.mj_header endRefreshing];
        NSRange range=NSMakeRange(0,reversedArray.count);
        NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:range];
        NSUInteger count = self.dataArray.count + 1;
        [self.dataArray insertObjects:reversedArray atIndexes:set];
        [self.tableView reloadData];
        [self endRefreshing];
        if (self.isDeleteLoadNewData) {
            if (self.dataArray.count > 0) {
                NSDictionary *dict = [self.dataArray lastObject];
                NSInteger qid = [[NSString stringWithFormat:@"%@",dict[kXMNMessageConfigurationQIDKey]] integerValue];
                ICometModel *model = [[[DBManager sharedManager] MessageDAO] selectMessageByQid:qid];
                [[[DBManager sharedManager] UserlistDAO] updateUserlist:model];
                self.isDeleteLoadNewData = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
            }else {
                [[[DBManager sharedManager] UserlistDAO] deleteUserlist:chatId];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
            }
        }

    }
       });
    
}


- (XMChatBar *)chatBar {
    if (!_chatBar) {
        //        _chatBar = [XMChatBar new];
        _chatBar = [[XMChatBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kMinHeight, self.view.frame.size.width, kMinHeight)];
        _chatBar.delegate = self;
        _chatBar.chatBarType = ChatBarShowMapGroup;
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
        if (dbArray.count == 0) {
            [self XMNChatViewModelLoadNewData];
        }else {
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
        
//        //添加发送失败的消息
//        MessageResendSQ *messageRendSQ = [[DBManager sharedManager] messageResendSQ];
//        NSArray *failMessageArray = [messageRendSQ selectMessage];
//        failMessageArray = [[failMessageArray reverseObjectEnumerator]allObjects];
//        if (failMessageArray) {
//            for (int j = 0; j < failMessageArray.count; j++) {
//                ICometModel *model1 = failMessageArray[j];
//                for (int i = 0; i < tempArray.count; i++) {
//                    ICometModel *model2 = dbArray[i];
//                    if (model2.qid == model1.qid) {
//                        [dbArray insertObject:model1 atIndex:i];
//                        break;
//                    }
//                }
//            }
//        }
        
        ICometModel *lastModel = [dbArray lastObject];
        self.qid = lastModel.qid;
        // 将数据库中的消息记录信息数组转换成显示到界面上的数组
        for (ICometModel *iModel in dbArray) {
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
        }
        [_dataArray addObjectsFromArray:reversedArray];
        
        }
    }
    return _dataArray;
}
#pragma mark -
#pragma mark 输入@触发的方法
- (void)chatBarForAt:(XMChatBar *)chatBar {
    
    NSString *chatType = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatType"];
    if ([@"G" isEqualToString:chatType]) {
        ChatGroupAtController *atController = [[ChatGroupAtController alloc] init];
        [self.myUIViewController.navigationController pushViewController:atController animated:YES];
    }
}
#pragma mark 键盘显示时会触发的方法
-(void)kbWillShow:(NSNotification *)noti {
    // 4.把消息现在在顶部
    [self scrollToBottom:NO];
}

#pragma mark 键盘退出时会触发的方法
-(void)kbWillHide:(NSNotification *)noti{
    
    [self.nearsetImage removeFromSuperview] ;

}
- (UILabel *)attentionLabel {
    
    if (_attentionLabel == nil) {
        _attentionLabel = [[UILabel alloc] init]; 
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

#pragma mark - Video Methods
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url {
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    int minute = 0, second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    if (second >= 60) {
        int index = second / 60;
        minute = index;
        second = second - index*60;
    }
    // 视频时长
    NSString *videoTime = [NSString stringWithFormat:@"%02d:%02d",minute, second];
    
    NSArray *tracks = [urlAsset tracks];
    float estimatedSize = 0.0 ;
    for (AVAssetTrack * track in tracks) {
        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
        float seconds = CMTimeGetSeconds([track timeRange].duration);
        estimatedSize += seconds * rate;
    }
    float sizeInMB = estimatedSize / 1024 / 1024;
    // 视频文件大小
    NSString *videoSize = [NSString stringWithFormat:@"%.2fM", sizeInMB];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    if (error == nil)
    {
        return [ChatBusiness addVideoLogo:[UIImage imageWithCGImage:imageRef] videoTime:videoTime videoSize:videoSize];
    }
    return nil;
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
        [self.myUIViewController.navigationController pushViewController:web animated:YES];
        self.navigationController.navigationBar.hidden = NO;
        
    }else {
        
        NSDictionary *dic = [self dictionaryWithJsonString:string];
        
        if ([dic[@"type"] isEqualToString:@"1"]) {
            NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
            if ([dic[@"key"] isEqualToString:alarm]) {
                UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
                [self.myUIViewController.navigationController pushViewController:userInfoController animated:YES];
                self.navigationController.navigationBar.hidden = NO;
            }else {
                
                UserDesInfoController *userCon = [[UserDesInfoController alloc] init];
                userCon.RE_alarmNum = dic[@"key"];
                if (self.cType == ChatList1) {
                    userCon.cType = Others;
                }else if (self.cType == GroupTeam1) {
                    userCon.cType = GroupController;
                }else if (self.cType == SearchC1) {
                    userCon.cType = Search;
                }
                userCon.cgType = Code;
                [self.myUIViewController.navigationController pushViewController:userCon animated:YES];
                self.navigationController.navigationBar.hidden = NO;
                
            }
            
        }else if ([dic[@"type"] isEqualToString:@"2"]) {
            QRResultGroupController *groupCon = [[QRResultGroupController alloc] init];
            groupCon.gid = dic[@"gid"];
            groupCon.gname = dic[@"gname"];
            groupCon.gtype = dic[@"gtype"];
            groupCon.otherAlarm = dic[@"alarm"];
            if (self.cType == ChatList1) {
               groupCon.myType = CHATLISTQRRESULT;
            }else if (self.cType == GroupTeam1) {
                groupCon.myType = CONTACTQRRESULT;
            }else if (self.cType == SearchC1) {
                
            }
            
            [self.myUIViewController.navigationController pushViewController:groupCon animated:YES];
            self.navigationController.navigationBar.hidden = NO;
            
        }else {
            QRCodelWebController *web = [[QRCodelWebController alloc] init];
            web.title = @"扫描结果";
            web.codeStr = string;
            [self.myUIViewController.navigationController pushViewController:web animated:YES];
            self.navigationController.navigationBar.hidden = NO;
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
    [self.myUIViewController.navigationController pushViewController:web animated:YES];
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
//    tap.delegate =self;
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
    UIImage *image = [img.img.image compressionImageToDataMaxFileSize:300];
    [self chatBar:self.chatBar sendPictures:@[image] withType:messageUnknow];
    [img removeFromSuperview];

}

- (NSString *)BackWorkId:(ICometModel *)iModel {
    
    NSString *workId = @"";
    if ([iModel.mtype isEqualToString:@"S"]) {//疑情
        //这是什么
        [LYRouter openURL:@"ly://ChatMapControllerChangeTask"];
        [[NSNotificationCenter defaultCenter] postNotificationName:MapShowEventNotification object:iModel];
        
    }else if ([iModel.mtype isEqualToString:@"X"]) {;//聊天群创建侦察任务群
        
        
        
    }else if ([iModel.mtype isEqualToString:@"N"]) {//通知（新增记录，标记）
        //将任务切换到全部
        [LYRouter openURL:@"ly://ChatMapControllerChangeTask"];
        [[NSNotificationCenter defaultCenter] postNotificationName:MapShowEventNotification object:iModel];
        
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

//-(void)reloadChatGroupName:(NSNotification *)notification
//{
//     self.navigationItem.title = notification.object;
//}

#pragma  mark ------ 点名
- (void)mapGroupGotoCallRoll
{
    CreateCollCallViewController * callRoll = [[CreateCollCallViewController alloc]init];
    callRoll.teamUserListArray = self.memberDataArray;
    [self.myUIViewController.navigationController pushViewController:callRoll animated:YES];
}

#pragma mark -
#pragma mark 请求群好友列表数据
- (void)httpGetGroupMemberInfo {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:FriendsLise_URL,alarm,@"3",chatId,token];
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        GroupMemberBaseModel *baseModel = [GroupMemberBaseModel getInfoWithData:response];
        [self.memberDataArray removeAllObjects];
        [self.memberDataArray addObjectsFromArray:baseModel.results];
        if (self.memberDataArray.count != 0) {
            
            [self mapGroupGotoCallRoll];
            
        }else
        {
            [self showHint:@"群成员获取失败"];
        }
        
    } fail:^(NSError *error) {
        [self showHint:@"群成员请求失败"];
    }];
}

- (NSMutableArray *)memberDataArray {
    if (_memberDataArray == nil) {
        _memberDataArray = [NSMutableArray array];
    }
    return _memberDataArray;
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
