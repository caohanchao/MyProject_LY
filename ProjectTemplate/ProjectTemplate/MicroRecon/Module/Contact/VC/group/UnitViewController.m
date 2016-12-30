//
//  UnitViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitViewController.h"
#import "UIView+Common.h"
#import "UnitTableViewCell.h"
#import "UnitListModel.h"
#import "UnitListModel.h"
#import "UnitMermberModel.h"
#import "UtOneTableViewCell.h"
#import "UtHeaderView.h"
#import "UnitRsultModel.h"
#import "UserAllModel.h"
#import "UserAllTableViewCell.h"
#import "UserDesInfoController.h"

@interface UnitViewController ()<UITableViewDataSource, UITableViewDelegate, UtHeaderViewDelegate>




@end

@implementation UnitViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:RefreshDepaetmentsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyData) name:@"reloadMyDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpGetInfo) name:@"httpGetInfoNotification" object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"clickUnitFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)reloadMyData {

    [_tableView reloadData];
}
- (NSMutableArray *)departArray {

    if (_departArray == nil) {
        _departArray = [NSMutableArray array];
    }
    return _departArray;
}
- (NSMutableDictionary *)dic {

    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}
-(NSMutableArray *)allArray {
    if (_allArray == nil) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}
- (NSMutableArray *)sjnumberArray {
    
    if (_sjnumberArray == nil) {
        _sjnumberArray = [NSMutableArray array];
    }
    return _sjnumberArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)userArray {
    if (_userArray == nil) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (NSMutableArray *)tempArray {

    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
- (void)initall {
    [self createTableView];
    [self dbGetInfo];
    [self httpGetInfo];
}
- (void)refreshUI:(NSNotification *)notification {
    
    [self.userArray removeAllObjects];
    [self.userArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlist]];
    [self sortDateArray:[[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlists]];
}
#pragma mark -
#pragma mark 从数据库获取
- (void)dbGetInfo {
    
    [self.allArray addObjectsFromArray:[[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlists]];
    [self.departArray addObjectsFromArray:[[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlists]];
    [self.userArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlist]];
    [self sortDateArray:[[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlists]];
    
    
}
#pragma mark 请求组织成员列表数据
- (void)httpGetInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:UnitList_URL,alarm,token];
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        UnitRsultModel *model = [UnitRsultModel getInfoWithData:response[@"response"]];

        for (UnitListModel *listModel in model.departall) {
            [[[DBManager sharedManager] DepartmentlistSQ] insertDepartmentlist:listModel];
        }
        
        if (model.userall.count > [[[DBManager sharedManager] personnelInformationSQ] getDepartmentCountsFromDB]) {
            //事务插入
            [[[DBManager sharedManager] personnelInformationSQ] transactionInsertPersonnelInformationOfUserAllModel:model.userall];
            
            [self.userArray removeAllObjects];
            [self.userArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlist]];
            [self sortDateArray:[[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlists]];
           
        }
        if (_delegate && [_delegate respondsToSelector:@selector(changeTitleView)]) {
            [_delegate changeTitleView];
        }
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)sortDateArray:(NSMutableArray *)arrays {
    
    
    NSString *dateString1;
    [self.sjnumberArray removeAllObjects];
    [self.tempArray removeAllObjects];
    
    
    for (UnitListModel * model in arrays) {
        
        NSString *dateString2 = model.DE_sjnumber;
        if (![dateString2 isEqualToString:dateString1]) {
            dateString1 = dateString2;
            [self.sjnumberArray addObject:dateString2];
        }
    }
    for (int i = 0; i < self.sjnumberArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < arrays.count; j++) {
            UnitListModel *model = arrays[j];
            NSString *dateString2 = model.DE_sjnumber;
            if ([dateString2 isEqualToString:self.sjnumberArray[i]]) {
                [array addObject:model];
                
            }
            if (j == self.sjnumberArray.count-1) {
                [self.dic setObject:array forKey:self.sjnumberArray[i]];
            }
        
        }
    }
    NSLog(@"%@",_dic);
    
    [self.tempArray addObjectsFromArray:[self.dic objectForKey:@"1"]];
    /**
     *  将人员插入数据原
     */
    [self getUserForOne];
    [_tableView reloadData];
}
- (void)getUserForOne {

    for (UserAllModel *model in self.userArray) {
        if ([model.RE_department isEqualToString:@"1"]) {
            [self.tempArray insertObject:model atIndex:0];
        }
    }
    [self.dataArray addObjectsFromArray:self.tempArray];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), kScreen_Height-64-44-142) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor whiteColor];
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
    
    if ([self.dataArray[indexPath.row] isKindOfClass:[UnitListModel class]]) {
        
        UtOneTableViewCell *cell = [UtOneTableViewCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UnitListModel *model = self.dataArray[indexPath.row];
        cell.friendData = model;
        return cell;
        
    }else if ([self.dataArray[indexPath.row] isKindOfClass:[UserAllModel class]]){
    
        UserAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UserAllTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.isContact = YES;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1. 创建头部控件
    UtHeaderView *header = [UtHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    
    //2. 给header设置数据（传模型）
    header.titleStr = @"武汉市公安局";
    
    //    NSLog(@"%p  - %ld",header, (long)section);
    
    return header;
}
#pragma mark -
#pragma mark 选择cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([self.dataArray[indexPath.row] isKindOfClass:[UnitListModel class]]) {
        UnitListModel *model1 = self.dataArray[indexPath.row];
        
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *userArr = [NSMutableArray array];
        
        for (UnitListModel *model2 in self.allArray) {
            if ([model1.DE_number isEqualToString:model2.DE_sjnumber]) {
                [arr addObject:model2];
            }
        }
        for (UserAllModel *mode3 in self.userArray) {
            if ([mode3.RE_department isEqualToString:model1.DE_number]) {
                [userArr addObject:mode3];
            }
        }
//        if (arr.count == 0 && userArr.count == 0) {
//            return;
//        }
        if (_delegate && [_delegate respondsToSelector:@selector(unitViewControllerPush:title:arr:allUser:allDepart:nextUser:)]) {
            [_delegate unitViewControllerPush:self title:model1.DE_name arr:arr allUser:self.userArray allDepart:self.departArray nextUser:userArr];
        }
        
        
    }else if ([self.dataArray[indexPath.row] isKindOfClass:[UserAllModel class]]){
        
        UserAllModel *userModel = self.dataArray[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(unitViewControllerPushUserInfo:userAllModel:)]) {
            [_delegate unitViewControllerPushUserInfo:self userAllModel:userModel];
        }
    }

    
}
#pragma mark - JGHeaderView代理方法
- (void)headerViewDidClickedNameView:(UtHeaderView *)headerView isOpen:(BOOL)isOpen{
    
    if (isOpen) {
        [self.dataArray removeAllObjects];
    }else {
        [self.dataArray addObjectsFromArray:self.tempArray];
    }
    [_tableView reloadData];
}
#pragma mark -
#pragma mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentPostion = scrollView.mj_offsetY;
    
    if (currentPostion > 20) {
        _tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-64-49);
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
