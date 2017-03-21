//
//  QRResultGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "QRResultGroupController.h"
#import "GroupDesBaseModel.h"
#import "GroupDesModel.h"


@interface QRResultGroupController () {

    UIImageView *_TImageView;
    UILabel *_nameLabel;
    UILabel *_MCountLabel;
    UILabel *_addGroupLabel;
    UIButton *_addGroupBtn;
    GroupDesModel *_groupDesModel;
    
}

@end

@implementation QRResultGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initall];
}
- (void)initall {
    
}
- (void)createUI {
    
    _TImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _TImageView.center = CGPointMake(kScreenWidth/2, 64+10+30);
    _TImageView.layer.masksToBounds = YES;
    _TImageView.layer.cornerRadius = 5;
    [self.view addSubview:_TImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _nameLabel.center = CGPointMake(kScreenWidth/2, maxY(_TImageView)+10+15);
    _nameLabel.font = ZEBFont(15);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    _MCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _MCountLabel.center = CGPointMake(kScreenWidth/2, maxY(_nameLabel)+15);
    _MCountLabel.font = ZEBFont(12);
    _MCountLabel.textColor = [UIColor grayColor];
    _MCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_MCountLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(_MCountLabel)+5, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    
    _addGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _addGroupLabel.center = CGPointMake(kScreenWidth/2, maxY(line)+45);
    _addGroupLabel.font = ZEBFont(16);
    _addGroupLabel.textColor = [UIColor blackColor];
    _addGroupLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_addGroupLabel];
    
    _addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addGroupBtn.frame = CGRectMake(50, maxY(_addGroupLabel)+15, kScreenWidth-50*2, 45);
    [_addGroupBtn setBackgroundColor:zBlueColor];
    _addGroupBtn.layer.masksToBounds = YES;
    _addGroupBtn.layer.cornerRadius = 5;
    [_addGroupBtn addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addGroupBtn];

}
- (void)setOtherAlarm:(NSString *)otherAlarm {

    _otherAlarm = otherAlarm;
    [self createUI];
    [self httpGtGroupDesInfo];
    [self reloadData];
    
}

- (void)reloadData {
    
    NSString *imageStr = @"";
    switch ([_gtype integerValue]) {
        case 0:
            // imageStr = @"group_zhencha";
            imageStr = @"G_zhencha";
            break;
        case 1:
            // imageStr = @"group_qunliao";
            imageStr = @"G_zudui";
            break;
        case 2:
            // imageStr = @"group_anbao";
            imageStr = @"G_pancha";
            break;
        case 3:
            //imageStr = @"group_xunkong";
            imageStr = @"G_xunkong";
            break;
        case 4:
            //  imageStr = @"group_sos";
            imageStr = @"G_zengyuan";
            break;
        case 5:
            imageStr = @"G_duikang";
            break;
            
        default:
            break;
    }
    TeamsListModel *gModel = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:self.gid];
    _TImageView.image = [UIImage imageNamed:imageStr];
    _nameLabel.text = _gname;
    
    if ([[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:self.gid]) {
       // _addGroupBtn.hidden = YES;
        _addGroupLabel.hidden = YES;
        _MCountLabel.text = [NSString stringWithFormat:@"（共%@人）",gModel.count];
        [_addGroupBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    }else {
    _addGroupLabel.text = @"确认加入该群";
        [_addGroupBtn setTitle:@"加入该群" forState:UIControlStateNormal];
    }
    
}
- (void)addGroup:(UIButton *)btn {
    if ([[btn currentTitle] isEqualToString:@"加入该群"]) {
        [self httpJoinGroup];
    }else if ([[btn currentTitle] isEqualToString:@"发送消息"]){
        [self sendMessage];
    }
}
#pragma mark -
#pragma mark 加入群组
- (void)httpJoinGroup {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"usertogroup";
    params[@"gid"] = self.gid;
    params[@"token"] = token;
    params[@"alarm"] = alarm;
    params[@"sid"] = self.otherAlarm;
   
    [self showloadingName:@"正在加入"];
    
    [HYBNetworking postWithUrl:JoinGroupUrl refreshCache:YES params:params success:^(id response) {
        
        if ([response[@"resultmessage"] isEqualToString:@"成功"]) {
            [self hideHud];
            [self showHint:@"加入成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        [self hideHud];
        [self showHint:@"加入失败"];
    }];
}
- (void)sendMessage {
    TeamsListModel *gModel = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:self.gid];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:IDMPhotoBrowserDismissNotification object:nil];
    if (self.myType == CHATLISTQRRESULT) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:gModel];
    }else if (self.myType == CONTACTQRRESULT) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipGroupNotification" object:@[gModel,@(self.myType)]];
    }else if (self.myType == APPLICATIONQRRESULT) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"skipApplicationNotification" object:@[gModel,@(self.myType)]];
    }
    
}
#pragma mark -
#pragma mark 请求群详细信息
- (void)httpGtGroupDesInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GetGroupDesUrl,alarm,self.gid,token];
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        GroupDesBaseModel *gDesModel = [GroupDesBaseModel getInfoWithData:response];
        
        
        _groupDesModel = gDesModel.results[0];
        _MCountLabel.text = [NSString stringWithFormat:@"（共%@人）",_groupDesModel.count];
        
    } fail:^(NSError *error) {
        
    }];
    
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
