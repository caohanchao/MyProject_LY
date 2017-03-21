//
//  TeamViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TeamViewController.h"
#import "UIView+Common.h"
#import "ContactTableViewCell.h"
#import "TeamsModel.h"
#import "TeamsListModel.h"
#import "TeamTableViewCell.h"

@interface TeamViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    TeamsListModel *_desGModel;
}


@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self initall];
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initall {
    
    [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] GrouplistSQ] selectGrouplists]];
    [self createTableView];
    [self initNotifation];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initNotifation {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:CreateGroupNotification object:nil];
}

- (void)refreshUI {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] GrouplistSQ] selectGrouplists]];
    [_tableView reloadData];
}

- (void)addMessageDisturb {

    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    
    for (TeamsListModel *model in self.dataArray) {
        
        [userDefaule setBool:YES forKey:model.gid];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-64-44-142) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
}

#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"identifier";
    
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TeamTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.isContact = YES;
    cell.teamListModel = self.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
#pragma mark -
#pragma mark 选择cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(teamViewControllerPush:teamListModel:)]) {
        [_delegate teamViewControllerPush:self teamListModel:self.dataArray[indexPath.row]];
    }
    
    
}

#pragma mark -
#pragma mark 删除某个组队
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除某个组队
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _desGModel = self.dataArray[indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除并退出该群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        [self httpCommitGroupInfoRid:alarm gid:_desGModel.gid];
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark 退群
- (void)httpCommitGroupInfoRid:(NSString *)rid gid:(NSString *)gid{
    
    if ([self isGroupAdmin]) {
        [self showHint:@"群主不能退群"];
        return;
    }
    
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
            [self showHint:@"删除并退出成功"];
            
        }
        
    } fail:^(NSError *error) {
        ZEBLog(@"%@",[error description]);
        [self showHint:@"删除并退出失败"];
        
    }];
}

#pragma mark -
#pragma mark 判断自己是不是群主
- (BOOL)isGroupAdmin {
    
    BOOL ret = NO;
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([alarm isEqualToString:_desGModel.admin]) {
        ret = YES;
    }
    return ret;
}

#pragma mark -
#pragma mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentPostion = scrollView.mj_offsetY;
    
    if (currentPostion > 20) {
        _tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-49-64);
        [[NSNotificationCenter defaultCenter] postNotificationName:HideTopViewNotification object:nil];
    }
    
    if (currentPostion < 0) {
        _tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-64-44-142);
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTopViewHideNotification object:nil];
    }
    
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
