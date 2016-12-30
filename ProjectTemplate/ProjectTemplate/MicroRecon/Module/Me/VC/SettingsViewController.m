//
//  SettingsViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/30.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SettingsViewController.h"
#import "AccountLogic.h"
#import "CUrlServer.h"
#import "LoginViewController.h"
#import "DBManager.h"
#import "SystemUpdateController.h"
#import "ChatLogic.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSArray *titleDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *headpic;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"系统设置";
    [self initall];
}
- (void)initall {
    [self createTableView];
}
- (NSArray *)titleDataArray {
    
    if (_titleDataArray == nil) {
        //备注:屏蔽
//        _titleDataArray = @[@[@"系统更新"],@[@"退出登陆"]];
        _titleDataArray = @[@[@"退出登陆"]];
    }
    return _titleDataArray;
}
- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    
    return self.titleDataArray.count;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.titleDataArray[section] count];
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier1 = @"identifier1";
    static NSString *identifier2 = @"identifier2";
    NSInteger count = self.titleDataArray.count;
    //备注:屏蔽
//    if (indexPath.section == count-1) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
//            UILabel *loginOut = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
//            loginOut.center = CGPointMake(screenWidth()/2, 45/2);
//            loginOut.textAlignment = NSTextAlignmentCenter;
//            loginOut.font = ZEBFont(16);
//            loginOut.tag = 10000;
//            [cell.contentView addSubview:loginOut];
//        }
//        UILabel *loginOut = [cell.contentView viewWithTag:10000];
//        loginOut.text = @"退出登陆";
//        return cell;
//    }else {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        } 
//        cell.textLabel.text = @"系统更新";
//        cell.textLabel.font = ZEBFont(16);
//        return cell;
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
        UILabel *loginOut = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        loginOut.center = CGPointMake(screenWidth()/2, 45/2);
        loginOut.textAlignment = NSTextAlignmentCenter;
        loginOut.font = ZEBFont(16);
        loginOut.tag = 10000;
        [cell.contentView addSubview:loginOut];
    }
    UILabel *loginOut = [cell.contentView viewWithTag:10000];
    loginOut.text = @"退出登陆";
    return cell;
    
    return [[UITableViewCell alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return scaleHeight(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return scaleHeight(10);
}

CGFloat scaleHeight(CGFloat height) {
    return ([UIScreen mainScreen].bounds.size.height/568.f) * height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger count = self.titleDataArray.count;
    //备注:屏蔽
    
//    if (indexPath.section == count-1) {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self showloadingName:@"正在退出"];
//        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//        [[AccountLogic sharedManager] logicLogout:alarm token:token progress:^(NSProgress * _Nonnull progress) {
//        
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
//            //退出登录
//            [self loginOut];
//            [self hideHud];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [self hideHud];
//        }];
//        
//        
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    [alertController addAction:action2];
//    [alertController addAction:action1];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//    }else {
//        
//        SystemUpdateController *sysUpdata = [[SystemUpdateController alloc] init];
//        [self.navigationController pushViewController:sysUpdata animated:YES];
//    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self showloadingName:@"正在退出"];
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [[AccountLogic sharedManager] logicLogout:alarm token:token progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            //退出登录
            [self loginOut];
            [self hideHud];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideHud];
        }];
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//退出登录
- (void)loginOut {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
    [self switchpushForCurl];
    
    [[CUrlServer sharedManager] cUrlCleanup];
    [DBManager closeDB];
    
    //便于建立新的长链接
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:NOTfirst];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.view.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate stopNStimer];
    
    if (appDelegate.tabbar) {
        appDelegate.tabbar = nil;
    }
}
- (void)switchpushForCurl
{
    [[ChatLogic sharedManager] switchPushLogicWithPushType:@"0" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        NSLog(@"消息切换成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"消息切换失败 error:%@",error);
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
