//
//  ApplicationViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ApplicationViewController.h"
#import "CircleOfBattleController.h"
#import "ScanViewController.h"
#import "XMNChatController.h"
#import "DCURLRouter.h"
#import "VehicleDetectionSearchViewController.h"
#import "VehicleDetectionViewController.h"
#import "ShakeViewController.h"
#import "CallTheRollHomeViewController.h"

@interface ApplicationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *imageArray;
@property(nonatomic,strong) UILabel * redLabel;

@end


static NSString * _tempNumStr;

@implementation ApplicationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden =NO;
    }
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"应用";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipChat:) name: @"skipApplicationNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redLabelHidden) name:CircleNewPostNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redLabelDisMiss) name:DismissPostNotification object:nil];
    
}

- (void)dealloc {
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)redLabelHidden
{
   self.redLabel.hidden=NO;
}

- (void)redLabelDisMiss
{
    self.redLabel.hidden=YES;
}

// 初始化tableview列表
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreen_Width,kScreen_Height-40) style:UITableViewStyleGrouped];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

//懒加载标题数组
- (NSArray *)titleArray
{
    if (!_titleArray) {
//        _titleArray = @[@[@"战友圈"],@[@"点名",@"签到"],@[@"摇一摇",@"扫一扫"],@[@"车侦",@"悬赏",@"数据统计"]];

//        _titleArray = @[@[@"战友圈"],@[@"摇一摇",@"扫一扫"],@[@"车侦"]];
        _titleArray = @[@[@"战友圈"],@[@"点名"],@[@"摇一摇",@"扫一扫"],@[@"车侦"]];

    }
    return _titleArray;
}

//懒加载icon数组
- (NSArray *)imageArray
{
    if (!_imageArray) {
//        _imageArray = @[@[@"application_zhanyou"],@[@"",@""],@[@"",@"application_saoyisao"],@[@"application_chezhen",@"application_xuanshang",@"application_shuju"]];

//        _imageArray = @[@[@"application_zhanyou"],@[@"shake",@"application_saoyisao"],@[@"application_chezhen"]];
        _imageArray = @[@[@"application_zhanyou"],@[@"rolllcal"],@[@"shake",@"application_saoyisao"],@[@"application_chezhen"]];

    }
    return _imageArray;
}


- (void)skipChat:(NSNotification*)notification {
    
    NSInteger type = [[notification.object lastObject] integerValue];
    // if (type == 3) {
    self.tabBarController.selectedIndex = 0;
    self.navigationController.navigationBar.hidden = NO;
    // }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:[notification.object firstObject]];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:self userInfo:notification.object];
//    UserInfoModel *userInfoModel = notification.object;
//    XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatSingle];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setObject:@"S" forKey:@"chatType"];
//    chatC.chatterName = userInfoModel.name;
//    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:userInfoModel.alarm];
//    chatC.chatterThumb = userInfoModel.headpic;
//    chatC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatC animated:YES];
}

#pragma mark -
#pragma mark tableview代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreen_Height/568.f) * 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //备注:屏蔽
    return [(NSArray *)self.titleArray[section] count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //备注:屏蔽
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.section][indexPath.row]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.section][indexPath.row]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0)
    {
        UILabel *redLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-45, ((kScreen_Height/568.f) * 45-8)/2, 8, 8)];
        redLabel.backgroundColor=[UIColor redColor];
        redLabel.layer.cornerRadius=redLabel.width/2;
        redLabel.layer.masksToBounds=YES;
        redLabel.hidden=YES;
        self.redLabel=redLabel;
        [cell.contentView addSubview:redLabel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (kScreen_Height/568.f) * 15;
    }
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            CircleOfBattleController *circleCtl = [[CircleOfBattleController alloc] init];
            circleCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:circleCtl animated:YES];
        }
            break;
        //备注:屏蔽
        case 1:
        {
//            [self pushVehicleDetectionSearchVC];
            CallTheRollHomeViewController *hvc = [[CallTheRollHomeViewController alloc] init];
            hvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hvc animated:YES];
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                
                ShakeViewController *shake = [[ShakeViewController alloc] init];
                shake.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shake animated:YES];
                
            }else if (indexPath.row == 1) {
                [self scan];
            }
            //   [self scan];
        }
            break;
        case 3:
        {
            VehicleDetectionSearchViewController *ve = [[VehicleDetectionSearchViewController alloc] init];
            ve.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ve animated:YES];
        }
        
           // [self showHint:@"该功能开发中"];
            break;
        case 4:
        {
//            CallTheRollHomeViewController *hvc = [[CallTheRollHomeViewController alloc] init];
//            [self.navigationController pushViewController:hvc animated:YES];
            
        }

            break;
        default:
            break;
    }
}

- (void)scan {
    ScanViewController *scanView = [[ScanViewController alloc] init];
    scanView.pageType = 3;
    scanView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanView animated:YES];
}

- (void)pushVehicleDetectionSearchVC {
    
    VehicleDetectionSearchViewController *svc =[[VehicleDetectionSearchViewController alloc] init];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
