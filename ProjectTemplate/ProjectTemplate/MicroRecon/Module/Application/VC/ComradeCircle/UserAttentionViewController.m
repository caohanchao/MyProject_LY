//
//  UserAttentionViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/11.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserAttentionViewController.h"
#import "HomePageListBaseModel.h"
#import "HomePageListModel.h"
#import "HonourTableViewCell.h"
#import "UserHomePageViewController.h"
#import "PostInfoModel.h"

float _attenLastContentOffset;

@interface UserAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) HomePageListBaseModel * infoModel;
@property(nonatomic, strong) NSArray * modelArray;
@property(nonatomic, strong) UITableView * attenTableView;

@end

@implementation UserAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"关注";
    
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    
    [self getResultsData];
    
    [self.view addSubview:self.attenTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updaModelArray) name:UserFollowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    _attenLastContentOffset = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if (!(_attenLastContentOffset < scrollView.contentOffset.y))
//    {
//        NSLog(@"向下滚动");
//         [[NSNotificationCenter defaultCenter] postNotificationName:HomeTitleViewNotification object:nil];
//    }
//}

- (void)updaModelArray
{
//    _modelArray = [[[DBManager sharedManager]userFollowSQ]selectUserFollowWithUserAlarm:self.userIDStr];
//    [self.tableView reloadData];
    [self getResultsData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_modelArray.count>0) {
        return _modelArray.count;
    }
    else
    {
        return 0;
    }
}

- (UITableView*)attenTableView
{
    if (!_attenTableView) {
        _attenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()) style:UITableViewStylePlain];
        _attenTableView.delegate = self;
        _attenTableView.dataSource = self;
        _attenTableView.separatorColor = LineColor;
        _attenTableView.showsVerticalScrollIndicator = NO;
        _attenTableView.showsHorizontalScrollIndicator = NO;
        _attenTableView.tableFooterView = [[UIView alloc]init];
        _attenTableView.backgroundColor = CHCHexColor(@"ffffff");
    }
    return _attenTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HonourTableViewCell";
    HonourTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HonourTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    if (_modelArray.count>0) {
       cell.model = _modelArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 48+27/2, 0, 0  )];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 48+27/2, 0, 0  )];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostInfoModel * model = _modelArray[indexPath.row];
    
    if ([self.selectIDStr isEqualToString:model.alarm]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UserHomePageViewController * userHomePageVC = [[UserHomePageViewController alloc]init];
        userHomePageVC.userIDStr = model.alarm;
        userHomePageVC.selectIDStr = model.alarm;
        [self.navigationController pushViewController:userHomePageVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    paramDict[@"key"] = @"focus";
    paramDict[@"mode"] = @"1";
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        _infoModel = [HomePageListBaseModel getInfoWithData:response];
        
        [[[DBManager sharedManager]userFollowSQ]deleteUserFollowWithPostid:self.userIDStr];
        
        [[[DBManager sharedManager]userFollowSQ]transactionInsertHomePageListModel:_infoModel.results withUserAlarm:self.userIDStr];
        _modelArray = [[[DBManager sharedManager]userFollowSQ]selectUserFollowWithUserAlarm:self.userIDStr];
        
       // _modelArray = _infoModel.results;
        [self.attenTableView reloadData];
        
//        [self resetContentInset];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         _modelArray = [[[DBManager sharedManager]userFollowSQ]selectUserFollowWithUserAlarm:self.userIDStr];
        [self.attenTableView reloadData];
        
//        [self resetContentInset];
    }];
}

#pragma mark - Private
//- (void)resetContentInset {
//    [self.attenTableView layoutIfNeeded];
//    
//    if (self.attenTableView.contentSize.height < kScreenHeight + 136) {  // 136 = 200
//        self.attenTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight+156-self.tableView.contentSize.height, 0);
//    } else {
//        self.tableView.contentInset = UIEdgeInsetsZero;
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
