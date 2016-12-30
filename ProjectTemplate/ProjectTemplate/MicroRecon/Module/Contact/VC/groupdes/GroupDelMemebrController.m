//
//  GroupDelMemebrController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupDelMemebrController.h"
#import "GroupMemberModel.h"

#define deleteViewText @"左滑删除"

@interface GroupDelMemebrController ()<UITableViewDelegate, UITableViewDataSource> {

    UITableView *_tableView;
    
}


@end

@implementation GroupDelMemebrController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"删除成员";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initall];
}
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"deleteView"]) {
        [self showTixingDeleteView];
    }
    
}
- (void)initall {
   
    
    
}
//第一次进入给出提醒
- (void)showTixingDeleteView {

    UILabel *deleteView = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, kScreen_Width-40, 0)];
    deleteView.text = deleteViewText;
    deleteView.font = ZEBFont(15);
    deleteView.backgroundColor = [UIColor blackColor];
    deleteView.textAlignment = NSTextAlignmentCenter;
    deleteView.alpha = 0.5;
    deleteView.textColor = [UIColor whiteColor];
    deleteView.layer.cornerRadius = 5;
    [self.view addSubview:deleteView];
    
    [UIView animateWithDuration:1.5 animations:^{
        
        deleteView.frame = CGRectMake(20, 64, kScreen_Width-40, 40);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.5 animations:^{
            
            deleteView.frame = CGRectMake(20, 64, kScreen_Width-40, 0);
            deleteView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [deleteView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }];
    
}
- (void)setDataArray:(NSMutableArray *)dataArray {

    _dataArray = dataArray;
    [self createTableView];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    return _dataArray.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:35/2 rectCornerType:UIRectCornerAllCorners];
        imageView.frame = CGRectMake(10, 10, 35, 35);
        imageView.tag = 1001;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(maxX(imageView)+10, 10, 150, 35)];
        label.font = ZEBFont(15);
        label.textColor = [UIColor blackColor];
        label.tag = 1002;
        [cell.contentView addSubview:label];
    }
    GroupMemberModel *model = self.dataArray[indexPath.row];
    
    UIImageView *imageView = [cell.contentView viewWithTag:1001];
    UILabel *label = [cell.contentView viewWithTag:1002];
   // [imageView sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:nil];
    [imageView imageGetCacheForAlarm:model.ME_uid forUrl:model.headpic];
    label.text = model.ME_nickname;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GroupMemberModel *model = self.dataArray[indexPath.row];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([model.ME_uid isEqualToString:alarm] || [model.ME_uid isEqualToString:self.gadmin]) {
        
        return NO;
    }
    return YES;
}

//删除成员
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMemberModel *model = self.dataArray[indexPath.row];
    
    
    [self httpCommitGroupInfoRid:model.ME_uid gid:model.ME_gid];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark -
#pragma mark 删除好友
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
           TeamsListModel *gModel = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:gid];
            NSMutableArray *arr = [gModel.memebers componentsSeparatedByString:@","];
            [arr removeObject:rid];
            NSString *members = [arr componentsJoinedByString:@","];
            [[[DBManager sharedManager] GrouplistSQ] updateGroupMembers:members gid:gid];
            
            if (_delegate && [_delegate respondsToSelector:@selector(groupDelMemebrControllerRefresh:)]) {
                [_delegate groupDelMemebrControllerRefresh:self];
            }
//            NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//            parm[@"type"] = @"del";
//            parm[@"uid"] = members;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatViewRefreshMemberNotification" object:nil];
            [self showHint:@"删除成功"];
            [self hideHud];
        }
        
    } fail:^(NSError *error) {
        ZEBLog(@"%@",[error description]);
        [self showHint:@"删除失败"];
        [self hideHud];
        
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
