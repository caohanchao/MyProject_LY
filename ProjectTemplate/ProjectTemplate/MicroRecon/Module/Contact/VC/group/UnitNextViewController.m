//
//  UnitNextViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitNextViewController.h"

#import "UtOneTableViewCell.h"
//#import "UtHeaderView.h"
#import "UserAllModel.h"
#import "UserAllTableViewCell.h"
#import "UserDesInfoController.h"
#import "UserInfoViewController.h"

@interface UnitNextViewController ()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation UnitNextViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNextData) name:@"reloadNextDataNotification" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableDictionary *)dic {

    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}
- (NSMutableArray *)nextUserArray {

    if (_nextUserArray == nil) {
        _nextUserArray = [NSMutableArray array];
    }
    return _nextUserArray;
}
- (NSMutableArray *)nextArray {
    if (_nextArray == nil) {
        _nextArray = [NSMutableArray array];
    }
    return _nextArray;
}
- (NSMutableArray *)tempArray {

    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.title = titleStr;
}
- (void)setArr:(NSMutableArray *)arr {

    _arr = arr;
   
    [self.dataArray addObjectsFromArray:self.nextUserArr];
    [self.dataArray addObjectsFromArray:_arr];
   
    [_tableView reloadData];
}
- (void)initall {
 
    [self createTableView];
}
/**
 *  得到下一级表头数据，用于传下一级
 */
- (void)sortDateArray:(UnitListModel *)model {
    
    //UnitListModel *model = self.arr[0];
    NSString *deStr = model.DE_number;
    [self.nextArray removeAllObjects];
    [self.nextUserArray removeAllObjects];
    for (UnitListModel *listModel in self.departArray) {
        if ([listModel.DE_sjnumber isEqualToString:deStr]) {
            [self.nextArray addObject:listModel];
        }
    }
    for (UserAllModel *userModel in self.userArray) {
        if ([userModel.RE_department isEqualToString:deStr]) {
            [self.nextUserArray addObject:userModel];
        }
    }
}
/**
 *  得到本级下的用户，添加到数据原
 */
//- (void)getUserForOne {
//    
//    UnitListModel *model = self.arr[0];
//    NSString *deStr = model.DE_number;
//    for (UnitListModel *listModel in self.departArray) {
//        if ([listModel.DE_sjnumber isEqualToString:deStr]) {
//            [self.tempArray addObject:listModel];
//        }
//    }
//    
//    for (UserAllModel *model in self.userArray) {
//        if ([model.RE_department isEqualToString:deStr]) {
//            [self.tempArray insertObject:model atIndex:0];
//        }
//    }
//    [self.dataArray addObjectsFromArray:self.tempArray];
//}
- (void)reloadNextData {
    [_tableView reloadData];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), height(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor= LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if (self.arr.count == 0) {
//        return 1;
//    }
  //  return self.arr.count;
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
//    if (self.arr.count == 0) {
//        return 0.1;
//    }
//    return 56;
    return 0.1;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    if (self.arr.count == 0) {
//        return [[UIView alloc] init];
//    }
//    //1. 创建头部控件
//    UtHeaderView *header = [UtHeaderView headerViewWithTableView:tableView];
//    header.delegate = self;
//    UnitListModel *model = self.arr[section];
//    //2. 给header设置数据（传模型）
//    header.titleStr = model.DE_name;
//    
//    //    NSLog(@"%p  - %ld",header, (long)section);
//    
//    return header;
//}
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
    
    if ([self.dataArray[indexPath.row] isKindOfClass:[UnitListModel class]]) {
        
        UnitListModel *model = self.dataArray[indexPath.row];
        if (self.arr.count != 0) {
            [self sortDateArray:model];
        }
        
//        if (self.nextArray.count == 0 && self.nextUserArray.count == 0) {
//            return;
//        }
        
        UnitNextViewController *next = [[UnitNextViewController alloc] init];
        next.hidesBottomBarWhenPushed = YES;
        next.userArray = self.userArray;
        next.departArray = self.departArray;
        next.nextUserArr = self.nextUserArray;
        next.titleStr = model.DE_name;
        next.arr = self.nextArray;
        
        [self.navigationController pushViewController:next animated:YES];
        
    }else if ([self.dataArray[indexPath.row] isKindOfClass:[UserAllModel class]]){
        
        UserAllModel *userModel = self.dataArray[indexPath.row];
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        if ([userModel.RE_alarmNum isEqualToString:alarm]) {
            UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
            [self.navigationController pushViewController:userInfoController animated:YES];
        }else {
        
        UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
        userDes.RE_alarmNum = userModel.RE_alarmNum;
        userDes.cType = GroupController;
        [self.navigationController pushViewController:userDes animated:YES];
        }
    }

}
#pragma mark - JGHeaderView代理方法
//- (void)headerViewDidClickedNameView:(UtHeaderView *)headerView isOpen:(BOOL)isOpen{
//    
//    if (isOpen) {
//        [self.dataArray removeAllObjects];
//    }else {
//        [self.dataArray addObjectsFromArray:self.tempArray];
//    }
//    [_tableView reloadData];
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
