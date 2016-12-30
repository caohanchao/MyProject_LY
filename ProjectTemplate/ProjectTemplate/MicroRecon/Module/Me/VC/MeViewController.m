//
//  MeViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MeViewController.h"
#import "MeCell.h"
#import "UserInfoViewController.h"
#import "SettingsViewController.h"
#import "show2wCodeImage.h"
#import "UserInfoModel.h"
#import "AboutLieYingController.h"
#import "UIView+Extension.h"
#import "XMLocationManager.h"

@interface MeViewController ()<UITableViewDataSource, UITableViewDelegate,MeCellDelegate>


@end

@implementation MeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setNavigationBar {
    self.navigationItem.title = @"我";
}

#pragma mark - tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [LZXHelper getScreenSize].width, [LZXHelper getScreenSize].height - 44) style:UITableViewStyleGrouped];
//        _tableView.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16;
}

CGFloat ScaleHeight(CGFloat height) {
    return ([UIScreen mainScreen].bounds.size.height/568.f) * height;
}


NSArray * MeTableTitles() {
    //备注:屏蔽
    return @[@[@""],
             @[@"声音",@"振动"],
             @[@"位置共享"],
             @[@"关于猎鹰",@"系统设置"]];
//    return @[@[@""],
//             @[@"声音",@"振动"],
//             @[@"位置共享"],
//             @[@"系统设置"]];
};

NSArray * MeTableImgs() {
    //备注:屏蔽
    return @[@[@""],
             @[@"me_sound",@"me_shake"],
             @[@"me_location"],
             @[@"me_about",@"me_settings"]];
//    return @[@[@""],
//             @[@"me_sound",@"me_shake"],
//             @[@"me_location"],
//             @[@"me_settings"]];
};

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden =NO;
    }
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
    }
    [self.tableView reloadData];
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = LineColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MeDefaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
//    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
}


#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * rows = MeTableTitles()[section];
    return rows.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MeTableTitles().count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ScaleHeight(78);
    } else {
        return ScaleHeight(45);
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeDefaultCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //add a switch
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.tag = 2000+indexPath.row;
        switchview.enabled=YES;
        
        UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
        
        switch (indexPath.row) {
            case 0:
            {
                
                switchview.on = [model.soundSet boolValue];
//                switchview.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSound"];

            }
                break;
            case 1:
            {

                switchview.on = [model.vibrateSet boolValue];
//                switchview.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isVibrate"];
    
            }
                break;
                
//            case 2:
//            {
//                switchview.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
//                
//            }
                break;
                
            default:
                break;
        }
        
        switchview.onTintColor = zBlueColor;
        [switchview addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;
        return cell;
    }else if (indexPath.section == 2){
        
        //位置共享
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeDefaultCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //add a switch
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.tag = 2000+indexPath.section;
        switchview.enabled=YES;
        
        UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
        switchview.on = [model.locationSet boolValue];
        
//        switchview.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"];
        
        switchview.onTintColor = zBlueColor;
        [switchview addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;
        return cell;
        
    }else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeDefaultCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    

}


#pragma mark - Selector

- (void)updateSwitch:(UISwitch *)switchView {
    
//    NSLog(@"updateSwitch");
    switch (switchView.tag) {
        case 2000:
        {
            [[[DBManager sharedManager] userDetailSQ] updateUserDetailSoundSet:[NSString stringWithFormat:@"%d",switchView.on]];
        }
            
            break;
        case 2001:
        {
            [[[DBManager sharedManager] userDetailSQ] updateUserDetailVibrateSet:[NSString stringWithFormat:@"%d",switchView.on]];
        }
            
            break;
        case 2002:
        {
            [[[DBManager sharedManager] userDetailSQ] updateUserDetailLocationSet:[NSString stringWithFormat:@"%d",switchView.on]];

            if(switchView.on == YES)
            {
                XMLocationManager *manager = [XMLocationManager shareManager];
                [manager requestAuthorization:^{
                    
                    switchView.on = NO;
                }];
                
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    switch (indexPath.section) {
        case 0:
        {
            MeCell * meCell = (MeCell *)cell;
            UserInfoModel *uModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
            meCell.avaterImgView.contentMode=UIViewContentModeScaleAspectFill;
            //[meCell.avaterImgView sd_setImageWithURL:[NSURL URLWithString:uModel.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"]];
            [meCell.avaterImgView imageGetCacheForAlarm:uModel.alarm forUrl:uModel.headpic];
            meCell.nameLabel.text = uModel.name;
            meCell.nameLabel.font = [UIFont systemFontOfSize:14];
            
            meCell.wechatIDLabel.text = [NSString stringWithFormat:@"警号：%@",[[NSUserDefaults standardUserDefaults] objectForKey:UIUseralarm]];
            meCell.wechatIDLabel.textColor = CHCHexColor(@"808080");
            meCell.wechatIDLabel.font = [UIFont systemFontOfSize:12];
        }
            break;
        case 1:
        {
            
            cell.textLabel.text = MeTableTitles()[indexPath.section][indexPath.row];
            cell.imageView.image = [UIImage imageNamed:MeTableImgs()[indexPath.section][indexPath.row]];
        }
            break;
        case 2:
        {
            cell.textLabel.text = MeTableTitles()[indexPath.section][indexPath.row];
            
            cell.imageView.image = [UIImage imageNamed:MeTableImgs()[indexPath.section][indexPath.row]];

        }
            break;
            case 3:
        {
            cell.textLabel.text = MeTableTitles()[indexPath.section][indexPath.row];
            
            cell.imageView.image = [UIImage imageNamed:MeTableImgs()[indexPath.section][indexPath.row]];
            //备注:屏蔽
//            if (indexPath.row==0) {
//                UILabel *label=[[UILabel alloc]init];
//                label.frame=CGRectMake(self.view.width-130,17,100,20);
//                NSString *versionStr=[NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//                label.text=versionStr;
//                label.font = ZEBFont(15);
//                label.textAlignment=NSTextAlignmentRight;
//                label.textColor=[UIColor lightGrayColor];
//                [cell addSubview:label];
//                
//            }
        }
           break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UserInfoViewController *userController = [[UserInfoViewController alloc] init];
        userController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userController animated:YES];
    } else if (indexPath.section == 3) {
        //备注:屏蔽
        if (indexPath.row==0) {
            AboutLieYingController *aboutLieYing=[[AboutLieYingController alloc]init];
            aboutLieYing.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:aboutLieYing animated:YES];
           
        }
        if (indexPath.row==1) {
            SettingsViewController *settingsController = [[SettingsViewController alloc] init];
            settingsController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingsController animated:YES];
        }
        
//        if (indexPath.row==0) {
//            SettingsViewController *settingsController = [[SettingsViewController alloc] init];
//            settingsController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:settingsController animated:YES];
//        }
       
    }
}
- (void)showTCode:(MeCell *)cell {

    [show2wCodeImage addPellTableViewSelectWithWindowFrame:CGRectZero selectData:nil MasonayY:0 action:^(NSInteger index) {
        
    } animated:YES selectdidFlag:1];
}
@end
