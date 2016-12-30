//
//  GroupDesSetingController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupDesSetingController.h"
#import "GroupMemberBaseModel.h"
#import "GroupMemberModel.h"
#import "GroupDesBaseModel.h"
#import "GroupDesModel.h"
#import "GroupNameCell.h"
#import "TaskIntroducedCell.h"
#import "MessageNotDisturbCell.h"
#import "ClearAllMessageCell.h"
#import "GroupAllMemeberCell.h"
#import "GroupDesHeaderView.h"
#import "GroupAllMemberController.h"
#import "GroupNameController.h"
#import "GroupTaskController.h"
#import "UserDesInfoController.h"
#import "GroupDelMemebrController.h"
#import "AddGroupMemberController.h"
#import "FriendsListModel.h"
#import "UserAllModel.h"
#import "UserInfoViewController.h"
#import "GroupQRCodeCell.h"
#import "QRViewController.h"
#import "WorkListsViewController.h"

#define btnHeight 50
#define TopMargin 15
#define TopViewHeight 152

@interface GroupDesSetingController ()<UITableViewDelegate, UITableViewDataSource, GroupNameControllerDelegate, GroupTaskControllerDelegate, GroupDesHeaderViewDelegate, GroupDelMemebrControllerDelegate, AddGroupMemberControllerDelegate> {

    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_titleLabel;
    GroupDesModel *_desModel;
    
}

@property (nonatomic,strong) NSMutableArray *desDataArray;
@property (nonatomic, strong) NSMutableArray *memberDataArray;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation GroupDesSetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createActivityIndicatorView];
    [self initall];
    
}

- (void)initall {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMe:) name:@"GroupDeleteManMotification" object:nil];
    
    [_activityIndicator startAnimating];
    
    [self getGidForUserdefault];
    [self createTableView];
    
    [self httpGetGroupMemberInfo];
    [self httpGtGroupDesInfo];
    
    
    
    
}
- (void)deleteMe:(NSNotification *)notification {
    
    if ([self.gid isEqualToString: notification.object]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)createActivityIndicatorView {

    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.center = CGPointMake(kScreen_Width/2, 64/2);
    self.navigationItem.titleView = _activityIndicator;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2-50, 0, 100, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = ZEBFont(16);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
- (NSMutableArray *)desDataArray {

    if (_desDataArray == nil) {
        _desDataArray = [NSMutableArray array];
    }
    return _desDataArray;
}
- (NSMutableArray *)memberDataArray {
    if (_memberDataArray == nil) {
        _memberDataArray = [NSMutableArray array];
    }
    return _memberDataArray;
}
- (NSArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = @[@[@"群二维码"],@[@"组队名称",@"任务介绍",@"消息免打扰"],@[@"清空聊天记录"]];
    }
    return _dataArray;
}
- (void)getGidForUserdefault {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.gid = [user objectForKey:@"chatId"];
    TeamsListModel *model = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:self.gid];
    NSArray *membersArray = [model.memebers componentsSeparatedByString:@","];
    for (NSString *uid in membersArray) {
        
           GroupMemberModel *gModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentGroupMemberModelById:uid];
      
        if (gModel != nil) {
         [self.memberDataArray addObject:gModel];
        }
        
    }
    [_tableView reloadData];
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
        
        [self showloadingName:@"正在加载"];
        
        [self.desDataArray addObjectsFromArray:gDesModel.results];
        GroupDesModel *desModel = gDesModel.results[0];
        _desModel = desModel;
        
        [_activityIndicator stopAnimating];
        
        self.navigationItem.titleView = _titleLabel;
        _titleLabel.text = [NSString stringWithFormat:@"群组设置(%@)",desModel.count];
        [_tableView reloadData];
        
        [self hideHud];
    } fail:^(NSError *error) {
        [self showHint:@"群详情请求失败"];
    }];
    
}
#pragma mark -
#pragma mark 添加好友
- (void)httpCommitGroupInfoGid:(NSString *)gid ridArray:(NSArray *)ridArray{
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"groupadd";
    params[@"sid"] = alarm;
    params[@"rid"] = [LZXHelper objArrayToJSON:ridArray];
    params[@"gid"] = gid;
    params[@"token"] = token;
    params[@"alarm"] = alarm;
    
    [self showloadingName:@"正在提交"];
    [HYBNetworking postWithUrl:AddGroupMemberUrl refreshCache:YES params:params success:^(id response) {
        
        ZEBLog(@"--------%@",response);
        if ([response[@"resultmessage"] isEqualToString:@"成功"]) {
            _desModel.count = [NSString stringWithFormat:@"%ld",[_desModel.count integerValue]+ridArray.count];
            [self httpGetGroupMemberInfo];
            [[[DBManager sharedManager] GrouplistSQ] updateGroupMemberCount:_desModel.count gid:gid];
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatViewRefreshMemberNotification" object:nil];
             [self showHint:@"添加成功"];
        }
        
    } fail:^(NSError *error) {
        ZEBLog(@"%@",[error description]);
        [self showHint:@"添加失败"];
        
    }];
}
#pragma mark -
#pragma mark 请求群好友列表数据
- (void)httpGetGroupMemberInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:FriendsLise_URL,alarm,@"3",self.gid,token];
    
    
    ZEBLog(@"%@",urlString);
    
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        
        GroupMemberBaseModel *baseModel = [GroupMemberBaseModel getInfoWithData:response];
        [self.memberDataArray removeAllObjects];
        [self.memberDataArray addObjectsFromArray:baseModel.results];
        if (self.memberDataArray.count != 0) {
        self.navigationItem.titleView = _titleLabel;
          _titleLabel.text = [NSString stringWithFormat:@"群组设置(%ld)",self.memberDataArray.count];
        }
        [_tableView reloadData];
        
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (GroupMemberModel *gModel in baseModel.results) {
            [tempArray addObject:gModel.ME_uid];
        }
        NSString *membersStr = [tempArray componentsJoinedByString:@","];
        
        //将群成员更新到数据库
        [[[DBManager sharedManager] GrouplistSQ] updateGroupMembers:membersStr gid:self.gid];
        [self hideHud];
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
    } fail:^(NSError *error) {
        [self showHint:@"群成员请求失败"];
    }];
    
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.separatorColor= LineColor;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
   
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.dataArray[section] count];
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     #import "GroupNameCell.h"
     #import "TaskIntroducedCell.h"
     #import "MessageNotDisturbCell.h"
     #import "ClearAllMessageCell.h"
     GroupAllMemeberCell
     */
    static NSString *identifier0 = @"identifier0";
    static NSString *identifier1 = @"identifier1";
    static NSString *identifier2 = @"identifier2";
    static NSString *identifier3 = @"identifier3";
    static NSString *identifier4 = @"identifier4";
    static NSString *identifier5 = @"identifier5";
    
    if (indexPath.section == 0) {//第一个section
        
        GroupQRCodeCell *cell0 = [tableView dequeueReusableCellWithIdentifier:identifier5];
        
        if (cell0 == nil) {
            cell0 = [[GroupQRCodeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier5];
        }
        return cell0;

    }else if (indexPath.section == 1) {//第二个section
        
        if (indexPath.row == 0) {
            GroupNameCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell1 == nil) {
                cell1 = [[GroupNameCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
            }
            cell1.groupName = _desModel.gname;
            return cell1;
            
            
        }else if (indexPath.row == 1) {
        
            TaskIntroducedCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (cell2 == nil) {
                cell2 = [[TaskIntroducedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
            }
            cell2.introducStr = _desModel.description1;
            return cell2;
        }else if (indexPath.row == 2) {
            
            
            MessageNotDisturbCell *cell3 = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (cell3 == nil) {
                cell3 = [[MessageNotDisturbCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier3];
                cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (![[LZXHelper isNullToString:_desModel.gid] isEqualToString:@""]) {
                cell3.gid = _desModel.gid;
            }
            return cell3;
            
        }
        
        
    }else if (indexPath.section == 2) {//第三个section
    
        if (indexPath.row == 0) {
            
            ClearAllMessageCell *cell4 = [tableView dequeueReusableCellWithIdentifier:identifier4];
            if (cell4 == nil) {
                cell4 = [[ClearAllMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier4];
            }
            
            return cell4;

        }
    }

    
    return [[UITableViewCell alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSInteger memberCount = self.memberDataArray.count + 2;
    if (memberCount > ShowMemberCount) {
        memberCount = ShowMemberCount;
    }
    NSInteger count;
    if (memberCount%5 == 0) {
        count = memberCount/5;
    }else {
        count = memberCount/5 + 1;
    }
    if (section == 0) {
        CGFloat margin = 70;
        CGFloat leftMargin = 40;
        CGFloat topMargin = 20;
        CGFloat widthh = (kScreenWidth-leftMargin*2 - margin*3)/4;
        CGFloat heightt = widthh;
        CGFloat labelHeight = 40;
        CGFloat topviewHeight = topMargin+(heightt+labelHeight)*2;
        return (btnHeight + TopMargin + 15)*count + 60 + topviewHeight+18;
    }
    return 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 2) {
        return 90;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        GroupDesHeaderView *headerView = [GroupDesHeaderView headerViewWithTableView:tableView];
        headerView.type = _desModel.gtype;
        headerView.dataArray = self.memberDataArray;
        headerView.delegate = self;
        return headerView;
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15, 16, kScreen_Width-30, 40);
        [button setBackgroundColor:ZEBRedColor];
        button.layer.cornerRadius = 5;
        button.titleLabel.font = ZEBFont(18);
        button.layer.masksToBounds = YES;
        [button setTitle:@"删除并退出" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteGroup) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    return [[UIView alloc] init];
}
#pragma mark -
#pragma mark 删除并退出
- (void)deleteGroup {

    if ([self isGroupAdmin]) {
        [self showHint:@"群主不能退群"];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出该群组？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        [self httpCommitGroupInfoRid:alarm gid:_desModel.gid];

        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
        
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//第一个section
        
        if (indexPath.row == 0) {
            
            [self goToGroupQRView];

           
        }
    }else if (indexPath.section == 1) {//第二个section
        
        if (indexPath.row == 0) {
           
            GroupNameController *gNameController = [[GroupNameController alloc] init];
            gNameController.gDesModel = _desModel;
            gNameController.delegate = self;
            gNameController.isgAdmin = [self isGroupAdmin];
            [self.navigationController pushViewController:gNameController animated:YES];
            
        }else if (indexPath.row == 1) {
           
            GroupTaskController *gTaskController = [[GroupTaskController alloc] init];
            gTaskController.gDesModel = _desModel;
            gTaskController.delegate = self;
            gTaskController.isgAdmin = [self isGroupAdmin];
            [self.navigationController pushViewController:gTaskController animated:YES];
          
        }else if (indexPath.row == 2) {
            
            
        }
        
    }else if (indexPath.section == 2) {//第三个section
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要清空聊天记录吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
           BOOL ret = [[[DBManager sharedManager] MessageDAO] clearGroupMessage:self.gid];
            if (ret) {
                [self showHint:@"清空成功"];
                //刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:ChatControllerRefreshUINotification object:nil];
            }else {
                [self showHint:@"清空失败"];
            }
        
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            
        }];
        
        [alertController addAction:action2];
        [alertController addAction:action1];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    

    }


    
}
 
/**
 *  群二维码
 */
- (void)goToGroupQRView {
    QRViewController *qr = [[QRViewController alloc] init];
    qr.title = @"群二维码";
    qr.gModel = _desModel;
    qr.ugType = GROUP;
    [self.navigationController pushViewController:qr animated:YES];
}
#pragma mark -
#pragma mark 退群
- (void)httpCommitGroupInfoRid:(NSString *)rid gid:(NSString *)gid{
    
    
    [self.view endEditing:YES];
    
    NSArray *delArray = [NSArray arrayWithObject:rid];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"groupdel";
    params[@"sid"] = alarm;
    params[@"rid"] = [LZXHelper objArrayToJSON:delArray];
    params[@"gid"] = gid;
    params[@"token"] = token;
    params[@"alarm"] = alarm;
    
    [self showloadingName:@"正在提交"];
    [HYBNetworking postWithUrl:delGroupMemberUrl refreshCache:YES params:params success:^(id response) {
        
        ZEBLog(@"--------%@",response);
        if ([response[@"resultmessage"] isEqualToString:@"成功"]) {
            
        [[[DBManager sharedManager] MessageDAO] clearGroupMessage:gid];
        
        
        [[[DBManager sharedManager] GrouplistSQ] deleteGrouplist:gid];
        
        
        [[[DBManager sharedManager] UserlistDAO] deleteUserlist:gid];
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatlistRefreshNotification" object:nil];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
        
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self hideHud];
        [self showHint:@"退群成功"];
        
        }
        
    } fail:^(NSError *error) {
        ZEBLog(@"%@",[error description]);
        [self showHint:@"退群失败"];
        
    }];
}
#pragma mark -
#pragma mark 刷新组队名称
- (void)groupNameControllerRefresh:(GroupNameController *)con name:(NSString *)name {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"gName"] = name;
    param[@"gid"] = _desModel.gid;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:name];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshGroupNameNotification object:param];
    _desModel.gname = name;
    [_tableView reloadData];

}
#pragma mark -
#pragma mark 刷新任务介绍
- (void)groupTaskControllerRefresh:(GroupTaskController *)con intro:(NSString *)intro {

    _desModel.description1 = intro;
    
    [_tableView reloadData];
}
#pragma mark -
#pragma mark 头部图片点击
-(void)groupDesHeaderViewAllMember:(GroupDesHeaderView *)view
{
    GroupAllMemberController *controller = [[GroupAllMemberController alloc] init];
    controller.dataArray = self.memberDataArray;
    controller.cType = self.cType;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)groupDesHeaderView:(GroupDesHeaderView *)view gMemberModel:(GroupMemberModel *)gMemberModel {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([gMemberModel.ME_uid isEqualToString:alarm]) {
        UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userInfoController animated:YES];
    }else {
    UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
    userDes.RE_alarmNum = gMemberModel.ME_uid;
        if (self.cType == 1) {
            userDes.cType = Others;
        }else if (self.cType == 2) {
            userDes.cType = GroupController;
        }else if (self.cType == 3) {
            userDes.cType = Search;
        }
    
    userDes.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userDes animated:YES];
    }
    
}
- (void)groupDesHeaderViewAddMember:(GroupDesHeaderView *)view  {

    AddGroupMemberController *addController = [[AddGroupMemberController alloc] init];
    
    addController.selGid = _desModel.gid;
    
//    addController.selectFRArray = [self soureFRArray];
//    addController.selectTMArray = [self soureTMArray];
//    addController.selectUTArray = [self soureUTArray];
    [addController.TempTMArray addObjectsFromArray:self.memberDataArray];
    [addController.selectTempTMArray addObjectsFromArray:self.memberDataArray];
    addController.fromeWhere = FromeGroupDes;
    addController.delegate = self;
    addController.gMCount = [_desModel.count integerValue];
    [self.navigationController pushViewController:addController animated:YES];

}
- (void)groupDesHeaderViewDeleteMember:(GroupDesHeaderView *)view  {

    GroupDelMemebrController *delController = [[GroupDelMemebrController alloc] init];
    delController.dataArray = self.memberDataArray;
    delController.gadmin = _desModel.gadmin;
    delController.delegate = self;
    [self.navigationController pushViewController:delController animated:YES];
}
- (void)groupDelMemebrControllerRefresh:(GroupDelMemebrController *)con {
    _desModel.count = [NSString stringWithFormat:@"%ld",[_desModel.count integerValue]-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
    _titleLabel.text = [NSString stringWithFormat:@"群组设置(%ld)",self.memberDataArray.count];
    [_tableView reloadData];
   
}

#pragma mark -
#pragma mark 添加好友
- (void)addGroupMemberController:(AddGroupMemberController *)con selectFRArray:(NSMutableArray *)FRArray selectTMArray:(NSMutableArray *)TMArray selectUTArray:(NSMutableArray *)UTArray selectTempFRArray:(NSMutableArray *)tempFRArray selectTempTMArray:(NSMutableArray *)tempTMArray selectTempUTArray:(NSMutableArray *)tempUTArray selGid:(NSString *)selGid {
    self.selectFRArray = tempFRArray;
    self.selectTMArray = tempTMArray;
    self.selectUTArray = tempUTArray;
    self.selGid = selGid;
    
    
    NSMutableArray *ridSameArray = [NSMutableArray array];
    
    for (FriendsListModel *model1 in self.selectFRArray) {
        [ridSameArray addObject:model1.alarm];
    }
    
    for (GroupMemberModel *model1 in self.selectTMArray) {
        [ridSameArray addObject:model1.ME_uid];
    }
    
    for (UserAllModel *model1 in self.selectUTArray) {
        [ridSameArray addObject:model1.RE_alarmNum];
    }
    
    [self httpCommitGroupInfoGid:_desModel.gid ridArray:ridSameArray];
    

}

- (NSMutableArray *)soureFRArray {

    NSMutableArray *frArray = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist];
    NSMutableArray *FRArray = [NSMutableArray array];
    for (FriendsListModel *model1 in frArray) {
        for (GroupMemberModel *model2 in self.memberDataArray) {
            if ([model1.alarm isEqualToString:model2.ME_uid]) {
                [FRArray addObject:model1];
            }
        }
    }
    return FRArray;

}
- (NSMutableArray *)soureTMArray {
    
    return self.memberDataArray;
    
}
- (NSMutableArray *)soureUTArray {
    
    NSMutableArray *utArray = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlist];
    NSMutableArray *UTArray = [NSMutableArray array];
    for (UserAllModel *model1 in utArray) {
        for (GroupMemberModel *model2 in self.memberDataArray) {
            if ([model1.RE_alarmNum isEqualToString:model2.ME_uid]) {
                [UTArray addObject:model1];
            }
        }
    }
    return UTArray;
    
}
- (void)groupDesHeaderView:(GroupDesHeaderView *)view type:(NSInteger)type {

    switch (type) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
        
            break;
        case 5:
        {
            WorkListsViewController *workList = [[WorkListsViewController alloc] init];
            workList.gid = self.gid;
            workList.type = 0;
            [self.navigationController pushViewController:workList animated:YES];
        }
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark 判断自己是不是群主
- (BOOL)isGroupAdmin {
    
    BOOL ret = NO;
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([alarm isEqualToString:_desModel.gadmin]) {
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
