//
//  UserDesInfoController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserDesInfoController.h"
#import "FriendsListModel.h"
#import "XMNChatController.h"
#import "UserAllModel.h"
#import "FriendModel.h"
#import "UnitListModel.h"
#import "FriendAddViewController.h"
#import "UserInfoBaseModel.h"
#import "UserInfoModel.h"
#import "HttpsManager.h"
#import "BaseResponseModel.h"
#import "CHCBlurImageEffects.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIButton+EnlargeEdge.h"
#import "CHCDownMenuView.h"
#import "ChatMapViewController.h"

#define Margin 20
#define LeftMargin 10
#define ScreenBounds [[UIScreen mainScreen]bounds]

@interface UserDesInfoController ()<CHCDownMenuViewDelegate>
{
    UIView * _navBarview;
    UIImageView * _bgView;
    UIImageView *_TXImageView;
    UILabel *_nameLabel;
    UILabel *_alertLabel;
    UILabel *_nickNameLabel;
    UILabel *_phoneLabel;
    UILabel *_orLabel;
    UILabel *_postLabel;
    UIButton *_sendMessageBtn;
    UIButton *_deleteFriendBtn;
    
}
@property(nonatomic,strong) CHCDownMenuView *menuView;
@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, copy) NSString *unitStr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headpic;
@property (nonatomic, copy) NSString *phoneNum;

@end

@implementation UserDesInfoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavBar];
    [self createMenuView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"详细资料";
    
}

-(void)creatNavBar
{
    _navBarview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 64)];
    _navBarview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navBarview];
    
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"chatmapBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setEnlargeEdge:20];
    [_navBarview addSubview:leftBtn];
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"detail_navBar_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setEnlargeEdge:20];
    [_navBarview addSubview:rightBtn];
    
    UILabel *title =[UILabel new];
    title.text = @"详情资料";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment =NSTextAlignmentCenter;
    [_navBarview addSubview:title];

    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(_navBarview.mas_left).with.offset(10);;
       make.top.offset(30);
       make.width.offset(25);
       make.height.offset(25);
       
   }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navBarview.mas_right).with.offset(-15);
        make.centerY.equalTo(leftBtn.mas_centerY).with.offset(0);
        make.width.offset(30);
        make.height.offset(10);
        
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerX.equalTo(_navBarview.mas_centerX).with.offset(0);
        make.centerY.equalTo(leftBtn.mas_centerY).with.offset(0);
        make.width.offset(80);
        make.height.offset(20);
    }];
  
}


#pragma mark - NAVBarClick
-(void)leftBtnCLick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnCLick
{
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView show];
    }
}

-(void)createMenuView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //计算ableView的frame
    CGFloat ViewW = 130;
    CGFloat ViewH = 44;
    CGFloat ViewX = screenWidth - ViewW - 5;
    CGFloat ViewY = 64;
    CHCDownMenuView *menuView = [[CHCDownMenuView alloc]initWithFrame:CGRectMake(ViewX, ViewY, ViewW, ViewH)];
    menuView.delegate = self;
    self.menuView = menuView;
}


#pragma mark - CHCDownMenuViewDelegate

- (void)CHCDownMenuView:(CHCDownMenuView *)view tag:(NSInteger)tag
{
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView show];
    }
    if(tag == 0)
    {
        [self presentDeleteFriedndToolBar];
    }

}

-(void)presentDeleteFriedndToolBar
{
    NSString *title =[NSString stringWithFormat:@"将好友\"%@\"删除,同时删除与该好友的聊天记录",self.userInfoModel.name];
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:self.alarm]) {
            [self deleteFriednd];
        }
        
        else
        {
            [self showHint:@"删除失败,他还不是您的好友"];
        }
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}
- (void)httpGetUserInfo:(NSString *)alarm {

    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GtUserDesInfoUrl,alarm,token];
    
    ZEBLog(@"%@",urlString);
    [self showloadingName:@"正在加载"];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        UserInfoBaseModel *baseModel = [UserInfoBaseModel getInfoWithData:response];
        if ([baseModel.resultmessage isEqualToString:@"成功"]) {
            self.userInfoModel = baseModel.results[0];
            //更新头像
            [self cacheImageUrl];
            [self createUI];
            if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:alarm]) {
                [_sendMessageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
                _deleteFriendBtn.hidden=NO;
            }else {
                [_sendMessageBtn setTitle:@"加为好友" forState:UIControlStateNormal];
                _deleteFriendBtn.hidden=YES;
            }
            
            [self refreshUI];
            [self hideHud];
            //更新本地头像缓存
            [ZEBCache imageCacheUrlString:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userInfoModel.headpic]]] alarm:self.userInfoModel.alarm];
            //更新数据库
            [[[DBManager sharedManager] personnelInformationSQ] updateNewPersonnelInformationOfUserInfoModel:self.userInfoModel];
            if (![[[DBManager sharedManager] personnelInformationSQ] isExistForAlarm:self.userInfoModel.alarm]) {
                
                [[[DBManager sharedManager] personnelInformationSQ] insertPersonnelInformationOfUserInfoModel:self.userInfoModel];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDepaetmentsNotification object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatControllerRefreshUINotification object:nil];
        } else if ([baseModel.resultmessage isEqualToString:@"未知账号"]) {
            [self createUI];
            _sendMessageBtn.hidden = YES;
            [self refreshUIWithNULL];
            [self hideHud];
            [self showHint:@"未知账号"];
        }
        
        
        
    } fail:^(NSError *error) {
        
        FriendsListModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlistById:alarm];
        if (!model) {
            [self createUI];
            _sendMessageBtn.hidden = YES;
            [self refreshUIWithNULL];
            [self hideHud];
        }
        else {
            self.userInfoModel = [[UserInfoModel alloc] initWithFriendsListModel:model];
            [self createUI];
            if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:alarm]) {
                [_sendMessageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
                _deleteFriendBtn.hidden=NO;
            }else {
                [_sendMessageBtn setTitle:@"加为好友" forState:UIControlStateNormal];
                _deleteFriendBtn.hidden=YES;
            }
            [self refreshUIWithCache:model];
            [self hideHud];
        }
        

    }];

}
#pragma mark -
#pragma mark 来自好友界面
- (void)setAlarm:(NSString *)alarm {

    _alarm = alarm;

    [self httpGetUserInfo:alarm];
    
}
#pragma mark -
#pragma mark 来自单位界面
- (void)setRE_alarmNum:(NSString *)RE_alarmNum {

    _RE_alarmNum = RE_alarmNum;
    _alarm = RE_alarmNum;
    [self httpGetUserInfo:RE_alarmNum];

}



- (void)createUI {

    self.view.backgroundColor =[UIColor whiteColor];
    
    UIView *view1 =[UIView new];
    
    [self.view addSubview:view1];
    [self.view insertSubview:view1 belowSubview:_navBarview];
    
    _bgView = [UIImageView new];
    
    
    [view1 addSubview:_bgView];
    
//    UIToolbar *toolbar = [UIToolbar new];
//    
//    toolbar.barStyle = UIBarStyleDefault;
//    
//    [_bgView addSubview:toolbar];
    

    
//    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark];
//    
//    //  毛玻璃视图
//    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    //关闭事件响应
////    effectView.userInteractionEnabled = NO;
//    //添加到要有毛玻璃特效的控件中
//    effectView.alpha = 0.9;
////    effectView.frame = _bgView.bounds;
//    
//    effectView.backgroundColor =[UIColor colorWithRed:0.09 green:0.51 blue:0.98 alpha:0.50];
//    
//    [_bgView addSubview:effectView];

    
    UIImageView *effectView =[CHCUI createImageWithbackGroundImageV:@"bgview_userinfo"];
    [_bgView addSubview:effectView];

    
//    
    _TXImageView = [UIImageView new];
    _TXImageView.layer.masksToBounds = YES;
    _TXImageView.layer.cornerRadius = 32;
    _TXImageView.contentMode = UIViewContentModeScaleAspectFill;
    _TXImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_TXImageView addGestureRecognizer:tap];
    
    UIView *imgBg =[UIView new];
    imgBg.layer.masksToBounds = YES;
    imgBg.layer.cornerRadius = 33;
    
    imgBg.backgroundColor =[UIColor whiteColor];
    
    [imgBg addSubview:_TXImageView];
    [view1 addSubview:imgBg];
    
    UIImageView *userImg =[UIImageView new];
    userImg.image =[UIImage imageNamed:@"detail_userImg"];
    [view1 addSubview:userImg];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = ZEBFont(14);
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:_nameLabel];
    
    _alertLabel =[UILabel new];
    _alertLabel.textColor = [UIColor whiteColor];
    _alertLabel.font = ZEBFont(13);
    _alertLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:_alertLabel];
    
    _postLabel = [UILabel new];
    _postLabel.layer.masksToBounds =YES;
    _postLabel.layer.cornerRadius = 3;
    _postLabel.textAlignment =NSTextAlignmentCenter;
    _postLabel.font = ZEBFont(10);
    _postLabel.textColor = [UIColor whiteColor];
    [view1 addSubview:_postLabel];
    
    
    UIView *line1 =[UIView new];
    line1.backgroundColor = zGroupTableViewBackgroundColor;
    [self.view addSubview:line1];
    
    UIView *view2 =[UIView new];
//    view2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view2];
    
    UILabel *pho = [UILabel new];
    pho.textColor = [UIColor grayColor];
    pho.text = @"电话号码";
    pho.font = ZEBFont(15);
    [view2 addSubview:pho];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.font = ZEBFont(15);

    [view2 addSubview:_phoneLabel];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [callBtn setEnlargeEdge:10];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"friend_detail_callphone"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:callBtn];
    
    
    
    UIView *line2 =[UIView new];
    line2.backgroundColor = zGroupTableViewBackgroundColor;
    [self.view addSubview:line2];
    
    
    UIView *view3 =[UIView new];
    [self.view addSubview:view3];
    
    UILabel *or = [UILabel new];
    or.textColor = [UIColor grayColor];
    or.text = @"所属单位";
    or.font = ZEBFont(15);
    [view3 addSubview:or];
    
    
    _orLabel = [UILabel new];
    _orLabel.textColor = [UIColor blackColor];
    _orLabel.font = ZEBFont(15);
    [view3 addSubview:_orLabel];
    
    
    UIView *line3 =[UIView new];
    line3.backgroundColor = zGroupTableViewBackgroundColor;
    [self.view addSubview:line3];
    
    
    _sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendMessageBtn.layer.masksToBounds = YES;
    _sendMessageBtn.layer.cornerRadius = 5;
    _sendMessageBtn.titleLabel.font = ZEBFont(18);
    [_sendMessageBtn setBackgroundColor:zBlueColor];
    [_sendMessageBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendMessageBtn];
    

    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.offset(230);
        
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view1.mas_top).with.offset(0);
        make.left.equalTo(view1.mas_left).with.offset(0);
        make.right.equalTo(view1.mas_right).with.offset(0);
        make.bottom.equalTo(view1.mas_bottom).with.offset(0);
    }];

    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.offset(230);
        
    }];
    
    [imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(view1.mas_centerX).offset(0);
        make.top.equalTo(_navBarview.mas_bottom).offset(30);
        make.width.and.height.offset(66);
        
    }];
    
    [_TXImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imgBg.mas_centerX).offset(0);
        make.top.equalTo(imgBg.mas_top).offset(1);
        make.width.and.height.offset(64);
        
    }];
    
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_TXImageView.mas_bottom).offset(12);
        make.trailing.equalTo(_TXImageView.mas_trailing).offset(0);
        make.height.offset(15);
        make.width.offset(12);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userImg.mas_left).offset(-10);
        make.centerY.equalTo(userImg.mas_centerY).offset(0);
        make.height.offset(15);
        make.width.offset(100);
    }];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_TXImageView.mas_leading).offset(35);
        make.top.equalTo(_nameLabel.mas_bottom).offset(8);
        make.width.offset(100);
        make.height.offset(15);
        
    }];
    
    [_postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_alertLabel.mas_left).with.offset(-10);
        make.centerY.equalTo(_alertLabel.mas_centerY).with.offset(0);
        make.height.equalTo(_alertLabel.mas_height).with.offset(0);
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@12);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.offset(50);
    }];
    
    [pho mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.centerY.equalTo(view2.mas_centerY).with.offset(0);
        make.width.offset(80);
        make.height.offset(15);
    }];
    
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pho.mas_right).with.offset(30);
        make.centerY.equalTo(view2.mas_centerY).with.offset(0);
        make.width.lessThanOrEqualTo(@150);
        make.height.equalTo(pho.mas_height);
        
    }];
    
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view2.mas_right).with.offset(-12);
        make.centerY.equalTo(view2.mas_centerY).with.offset(0);
        make.width.and.height.offset(20);

    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(view2.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@12);
    }];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.offset(50);
    }];
    
    [or mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.centerY.equalTo(view3.mas_centerY).with.offset(0);
        make.width.offset(80);
        make.height.offset(15);
    }];
    
    [_orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(or.mas_right).with.offset(30);
        make.centerY.equalTo(view3.mas_centerY).with.offset(0);
//        make.width.lessThanOrEqualTo(@200);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.height.equalTo(or.mas_height);
        
    }];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view3.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
//        make.height.equalTo(@12);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
    }];
    
    [_sendMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
        make.height.offset(45);
        make.top.equalTo(line3.mas_top).with.offset(30);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-12);
        
    }];
    
//
}




//删除好友
-(void)deleteFriednd{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该好友" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"sid"]=alarm;
        dict[@"rid"]=self.userInfoModel.alarm;
        dict[@"token"]=token;
        dict[@"action"]=@"del";
        [[HttpsManager sharedManager]post:DeleteFriendUrl parameters:dict progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            BaseResponseModel *message=[BaseResponseModel ResponseWithData:reponse];
            if ([message.resultcode integerValue]==0&&[message.resultmessage isEqualToString:@"成功"]) {
                
                __block BOOL ifReadOnly;
                dispatch_queue_t q = dispatch_queue_create("zdeletef", DISPATCH_QUEUE_SERIAL);
                
                dispatch_sync(q, ^{
                    ifReadOnly=[[[DBManager sharedManager]personnelInformationSQ] deletePersonelInfomationFriendsListModel:self.userInfoModel.alarm];
                });
                dispatch_sync(q, ^{
                if (ifReadOnly==YES) {
                    dispatch_queue_t q1 = dispatch_queue_create("zifReadOnly", DISPATCH_QUEUE_SERIAL);
                    dispatch_sync(q1, ^{
                      [[[DBManager sharedManager] UserlistDAO] deleteUserlist:chatId];
                        [[[DBManager sharedManager]MessageDAO] clearGroupMessage:self.userInfoModel.alarm];
                    });
                    dispatch_sync(q1, ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatlistRefreshNotification" object:nil];
                    });
                    dispatch_sync(q1, ^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:RefreshFriendsNotification object:self userInfo:nil];
                    });
                    [self showHint:@"删除成功"];
                    
                    self.navigationController.navigationBar.hidden = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                });
         }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showHint:@"删除失败"];
        }];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:confirm];
    [alertView addAction:cancel];
    [self presentViewController:alertView animated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)refreshUI {
//    
//    UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userInfoModel.headpic]]];
    
    [_bgView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            [_bgView imageGetCacheForAlarm:self.userInfoModel.alarm forUrl:self.userInfoModel.headpic];
            
            
        }
    }];
    self.navigationController.navigationBar.translucent =YES;
    _bgView.contentMode = UIViewContentModeScaleToFill;
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:_bgView.bounds];
    
    toolbar.barStyle = UIBarStyleBlackOpaque;
    
    [_bgView addSubview:toolbar];

    [_TXImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            [_TXImageView imageGetCacheForAlarm:self.userInfoModel.alarm forUrl:self.userInfoModel.headpic];
        }
    }];
    _TXImageView.contentMode = UIViewContentModeScaleAspectFill;
    _nameLabel.text = self.userInfoModel.name;
    _alertLabel.text = [NSString stringWithFormat:@"%@",self.userInfoModel.useralarm];
    
    
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.userInfoModel.alarm];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    NSString *DE_type = uModel.DE_type;

    CGFloat width =_postLabel.frame.size.width;
    
    if ([[LZXHelper isNullToString:self.userInfoModel.post] isEqualToString:@""]) {
        
            _postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            _postLabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];

    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            _postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            _postLabel.text = [NSString stringWithFormat:@" %@ ",self.userInfoModel.post];

            
        }else if ([DE_type isEqualToString:@"1"]) {
            _postLabel.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            _postLabel.text = [NSString stringWithFormat:@" %@ ",self.userInfoModel.post];

        }
        
    }
    
    width = [LZXHelper textWidthFromTextString:_postLabel.text height:20 fontSize:10];
    [_postLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_alertLabel.mas_left).with.offset(-10);
        make.centerY.equalTo(_alertLabel.mas_centerY).with.offset(0);
        make.height.equalTo(_alertLabel.mas_height).with.offset(0);
        make.width.offset(width);
        
    }];


//    _nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.userInfoModel.name];
//
    _phoneLabel.text = self.userInfoModel.phonenum;
//
    _orLabel.text = self.userInfoModel.department;
    
}

-(void)refreshUIWithCache:(FriendsListModel *)model
{
    [_bgView imageGetCacheForAlarm:model.alarm forUrl:model.headpic];
    self.navigationController.navigationBar.translucent =YES;
    _bgView.contentMode = UIViewContentModeScaleToFill;
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:_bgView.bounds];
    
    toolbar.barStyle = UIBarStyleBlackOpaque;
    
    [_bgView addSubview:toolbar];
    

    [_TXImageView imageGetCacheForAlarm:model.alarm forUrl:model.headpic];

    _TXImageView.contentMode = UIViewContentModeScaleAspectFill;
    _nameLabel.text = model.name;
    _alertLabel.text = [NSString stringWithFormat:@"%@",model.useralarm];
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:model.alarm];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    NSString *DE_type = uModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:userModel.RE_post];
    
    CGFloat width =_postLabel.frame.size.width;
    
    if ([DE_name isEqualToString:@""]) {
        
        _postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        _postLabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];

        
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            _postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            _postLabel.text = [NSString stringWithFormat:@" %@ ",DE_name];
            
            
        }else if ([DE_type isEqualToString:@"1"]) {
            _postLabel.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            _postLabel.text = [NSString stringWithFormat:@" %@ ",DE_name];
            
        }
        
    }
    
    width = [LZXHelper textWidthFromTextString:_postLabel.text height:20 fontSize:10];
    [_postLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_alertLabel.mas_left).with.offset(-10);
        make.centerY.equalTo(_alertLabel.mas_centerY).with.offset(0);
        make.height.equalTo(_alertLabel.mas_height).with.offset(0);
        make.width.offset(width);
        
    }];
    
    _phoneLabel.text = model.phone;
    _orLabel.text = userModel.RE_department;
}

- (void)refreshUIWithNULL {
    
    [_TXImageView setImage:[UIImage imageNamed:@"ph_s"]];
    _TXImageView.contentMode = UIViewContentModeScaleAspectFill;
    _nameLabel.text =@"该账号不存在";
    _alertLabel.text = @"未知";
    _postLabel.text = @"未知";
    [_postLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_alertLabel.mas_left).with.offset(-10);
        make.centerY.equalTo(_alertLabel.mas_centerY).with.offset(0);
        make.height.equalTo(_alertLabel.mas_height).with.offset(0);
        make.width.offset(40);
        
    }];
    _phoneLabel.text = @"未知";
    _orLabel.text = @"未知";
}

#pragma mark -
#pragma mark 点击图片

- (void)tapClick:(UITapGestureRecognizer *)ges
{
    [self showImage:(UIImageView *)ges.view];
    
}

//展示图片
static CGRect oldframe;

-(void)showImage:(UIImageView *)avatarImageView
{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1000;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark 发送消息
- (void)sendMessage:(UIButton *)btn {


    if ([[btn currentTitle] isEqualToString:@"发送消息"]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.userInfoModel.alarm forKey:@"chatId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.cType == ChatControlelr) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.cType == GroupController){
            [self.navigationController popToRootViewControllerAnimated:NO];
            if (self.cgType == Code) {
               [[NSNotificationCenter defaultCenter] postNotificationName:IDMPhotoBrowserDismissNotification object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"skipGroupNotification" object:@[self.userInfoModel,@(self.cType)]];
        }else if (self.cType == Others){
            [self.navigationController popToRootViewControllerAnimated:NO];
            if (self.cgType == Code) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IDMPhotoBrowserDismissNotification object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:self.userInfoModel];
        }else if (self.cType == Search){
            [self.navigationController popToRootViewControllerAnimated:NO];
            if (self.cgType == Chat) {
                [[NSNotificationCenter defaultCenter] postNotificationName:BackToRootController object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:self.userInfoModel];
            }else if (self.cgType == Group) {
                [[NSNotificationCenter defaultCenter] postNotificationName:BackToRootController object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"skipGroupNotification" object:@[self.userInfoModel,@(self.cType)]];
            }
        }else if (self.cType == ApplicationPage) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            if (self.cgType == Code) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IDMPhotoBrowserDismissNotification object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"skipApplicationNotification" object:@[self.userInfoModel,@(self.cType)]];
        }

        
    } else if ([@"加为好友" isEqualToString:[btn currentTitle]]) {
        FriendAddViewController *friendAddVC = [[FriendAddViewController alloc] init];
        friendAddVC.friendAlarm = self.userInfoModel.alarm;
        friendAddVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendAddVC animated:YES];
    }
    
}
- (void)cacheImageUrl {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
                UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userInfoModel.headpic]]];
                [ZEBCache imageCacheUrlString:image alarm:self.userInfoModel.alarm];
       
    });
    
}
#pragma mark -
#pragma mark 打电话
- (void)call:(UIButton *)btn {

    NSString *phone = self.userInfoModel.phonenum;
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
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
