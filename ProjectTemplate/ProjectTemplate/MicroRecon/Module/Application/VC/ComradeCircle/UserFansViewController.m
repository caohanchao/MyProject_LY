//
//  UserFansViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/11.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserFansViewController.h"
#import "HomePageListBaseModel.h"
#import "HomePageListModel.h"
#import "HonourTableViewCell.h"
#import "UserHomePageViewController.h"
#import "PostInfoModel.h"

float _fansLastContentOffset;

@interface UserFansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) HomePageListBaseModel * infoModel;
@property(nonatomic, strong) NSArray * modelArray;

@property(nonatomic, strong) UITableView * fansTableView;

@end

@implementation UserFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    
    self.navigationItem.title = @"粉丝";
    
    [self getResultsData];
    
    [self.view addSubview:self.fansTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updaModelArray) name:UserFansNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    _fansLastContentOffset = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if (!(_fansLastContentOffset < scrollView.contentOffset.y))
//    {
//        NSLog(@"向下滚动");
//        [[NSNotificationCenter defaultCenter] postNotificationName:HomeTitleViewNotification object:nil];
//    }
//}

- (void)updaModelArray
{
//    _modelArray = [[[DBManager sharedManager]userFansSQ]selectUserFansWithUserAlarm:self.userIDStr];
//    [self.tableView reloadData];
    [self getResultsData];
}

- (UITableView*)fansTableView
{
    if (!_fansTableView) {
        _fansTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()) style:UITableViewStylePlain];
        _fansTableView.delegate = self;
        _fansTableView.dataSource = self;
        _fansTableView.separatorColor = LineColor;
        _fansTableView.showsVerticalScrollIndicator = NO;
        _fansTableView.showsHorizontalScrollIndicator = NO;
        _fansTableView.tableFooterView = [[UIView alloc]init];
        _fansTableView.backgroundColor = CHCHexColor(@"ffffff");
    }
    return _fansTableView;
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
    paramDict[@"key"] = @"fans";
    paramDict[@"mode"] = @"1";
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
       _infoModel = [HomePageListBaseModel getInfoWithData:response];
        
        [[[DBManager sharedManager]userFansSQ]deleteUserFansWithPostid:self.userIDStr];
        [[[DBManager sharedManager]userFansSQ]transactionInsertHomePageListModel:_infoModel.results withUserAlarm:self.userIDStr];
        _modelArray = [[[DBManager sharedManager]userFansSQ]selectUserFansWithUserAlarm:self.userIDStr];
        //_modelArray = _infoModel.results;
        [self.fansTableView reloadData];
        
      //  [self resetContentInset];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _modelArray = [[[DBManager sharedManager]userFansSQ]selectUserFansWithUserAlarm:self.userIDStr];
         [self.fansTableView reloadData];
    }];
}

#pragma mark - Private
//- (void)resetContentInset {
//    [self.tableView layoutIfNeeded];
//    
//    if (self.tableView.contentSize.height < kScreenHeight + 136) {  // 136 = 200
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight+156-self.tableView.contentSize.height, 0);
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
