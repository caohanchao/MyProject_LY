//
//  UserHonourViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/11.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserHonourViewController.h"
#import "HomePageListBaseModel.h"
#import "HomePageListModel.h"
#import "HonourTableViewCell.h"

@interface UserHonourViewController ()

@property(nonatomic, strong) HomePageListBaseModel * infoModel;

@end

@implementation UserHonourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  [self getResultsData];
}



- (void)getResultsData
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"armslist";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"value"] = self.userIDStr;
    paramDict[@"key"] = @"praise";
    paramDict[@"mode"] = @"1";
    
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
       //  _infoModel = [HomePageListBaseModel getInfoWithData:response];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {;
    }];
}

//#pragma mark - Private
//- (void)resetContentInset {
//    [self.tableView layoutIfNeeded];
//    
//    if (self.tableView.contentSize.height < kScreenHeight + 136) {  // 136 = 200
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight+156-self.tableView.contentSize.height, 0);
//    } else {
//        self.tableView.contentInset = UIEdgeInsetsZero;
//    }
//}

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
