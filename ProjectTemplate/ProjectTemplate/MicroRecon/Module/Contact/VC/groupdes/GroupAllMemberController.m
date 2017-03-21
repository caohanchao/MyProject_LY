//
//  GroupAllMemberController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupAllMemberController.h"
#import "GroupMemberModel.h"
#import "UserDesInfoController.h"
#import "UserInfoViewController.h"

@interface GroupAllMemberController ()<UITableViewDelegate, UITableViewDataSource> {

    UITableView *_tableView;
}

@end

@implementation GroupAllMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initall];
}
- (void)initall {

    
}
- (void)setDataArray:(NSMutableArray *)dataArray {

    _dataArray = dataArray;
    self.title = [NSString stringWithFormat:@"参与成员(%ld)",_dataArray.count];
   [self createTableView];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor =LineColor;
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
    return _dataArray.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:35.f/2 rectCornerType:UIRectCornerAllCorners];
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupMemberModel *model = self.dataArray[indexPath.row];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    if ([model.ME_uid isEqualToString:alarm]) {
      
        UserInfoViewController *userController = [[UserInfoViewController alloc] init];
        
        
        [self.navigationController pushViewController:userController animated:YES];
        
    }else {
    UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
    userDes.RE_alarmNum = model.ME_uid;
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
