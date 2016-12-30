//
//  SeePathViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SeePathViewController.h"
#import "GetPathBaseModel.h"
#import "NSString+Property.h"
#import "SeePathTableViewCell.h"
#import "SeePathTableViewHeaderFooterView.h"
#import "SeePathNolineTableViewCell.h"
#import "SeePathFiristTableViewHeaderFooterView.h"

@interface SeePathViewController ()<UITableViewDelegate, UITableViewDataSource, SeePathTableViewHeaderFooterViewDelegate, SeePathFiristTableViewHeaderFooterViewDelegate> {
    UIButton *_commitBtn;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSMutableDictionary *showDic;//用来判断分组展开与收缩的

@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIView *bottomView; // 底部全选
@property (nonatomic, strong) UIImageView *bottomImageView;

@property (nonatomic, assign) BOOL chooseall;

@end

@implementation SeePathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.title = @"选择";
    [self initall];
}
- (void)initall {
    [self createTableView];
    [self httpsGetPath];
    [self createRightButton];
    [self createBottomView];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableDictionary *)showDic {
    if (!_showDic) {
        _showDic = [NSMutableDictionary dictionary];
    }
    return _showDic;
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [CHCUI createImageWithbackGroundImageV:@"mapchoose"];
        _bottomImageView.frame = CGRectMake(kScreenWidth-12-14, (40-14)/2, 14, 14);
    }
    return _bottomImageView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 40)];
        _bottomView.backgroundColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
        UILabel *titleLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zWhiteColor text:@"全选"];
        titleLabel.frame = CGRectMake(12, 0, 40, 40);
        [_bottomView addSubview:titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAll)];
        [_bottomView addGestureRecognizer:tap];
        
    }
    return _bottomView;
}
- (void)createBottomView {
    [self.bottomView addSubview:self.bottomImageView];
    [self.view addSubview:self.bottomView];
}
- (void)createRightButton {
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame = CGRectMake(0, 0, 40, 40);
    _commitBtn.titleLabel.font = ZEBFont(16);
   // _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitleColor:zWhiteColor];
    [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_commitBtn];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
    
}
- (void)setHaveSelectArray:(NSMutableArray *)haveSelectArray {
    _haveSelectArray = haveSelectArray;
    [self.selectArray addObjectsFromArray:_haveSelectArray];
}
- (void)commit {
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"pathlist"] = self.selectArray;
    [LYRouter openURL:@"ly://ChatMapViewControllerGetPathList" withUserInfo:parm completion:^(id result) {
        
    }];
    [LYRouter openURL:@"ly://MapViewControllerGetPathList" withUserInfo:parm completion:^(id result) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark 获取轨迹
- (void)httpsGetPath {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"gettrail";
    params[@"gid"] = self.gid;
    params[@"token"] = token;
    params[@"alarm"] = alarm;
    if (![self.workId isEqualToString:@""]) {
    params[@"task_id"] = self.workId;
    }
    [self showloadingName:@"正在加载..."];
    [[HttpsManager sharedManager] post:ChatMapGetPath parameters:params progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        GetPathBaseModel *baseModel = [GetPathBaseModel getInfoWithData:reponse];
        [self.dataArray addObjectsFromArray:baseModel.results];
        [self soureDataArray:self.dataArray];
        [self hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self hideHud];
        [self showHint:@"轨迹获取失败"];
       
    }];
}

- (void)soureDataArray:(NSArray *)arr {
    
    for (GetPathModel *model in arr) {
    
        model.select = [self isHavePath:model.route_id];
        NSString *alarm2 = model.alarm;
        if (![self isHaveAlarm:alarm2]) {
            alarm2.myId = model.name;
            alarm2.open = @"YES";
            [self.titleArray addObject:alarm2];
        }
    }
    for (int i = 0; i < self.titleArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < arr.count; j++) {
            GetPathModel *model = arr[j];
           
            if ([model.alarm isEqualToString:self.titleArray[i]]) {
                
                [array addObject:model];
            }
            if (j == self.titleArray.count-1) {
                [self.dict setObject:array forKey:self.titleArray[i]];
            }
        }
    }
    self.showDic = [self.dict mutableCopy];
    [self.tableView reloadData];
    //判断是否全选
    [self isChooseAll:arr];
}

- (BOOL)isHaveAlarm:(NSString *)al {
    
    BOOL ret = NO;
    for (NSString *alarm in self.titleArray) {
        if ([al isEqualToString:alarm]) {
            ret = YES;
            break;
        }
    }
    return ret;
}
- (BOOL)isHavePath:(NSString *)pathId {
    
    BOOL ret = NO;
    for (GetPathModel *model in self.haveSelectArray) {
        if ([model.route_id isEqualToString:pathId]) {
            ret = YES;
            break;
        }
    }
    return ret;
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleArray.count;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSMutableArray *)[self.showDic objectForKey:self.titleArray[section]] count];
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    static NSString *identifier1 = @"identifier1";
    
    NSInteger count = [(NSMutableArray *)[self.showDic objectForKey:self.titleArray[indexPath.section]] count];
    if (indexPath.row == count-1) {
        SeePathNolineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[SeePathNolineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
        }
        NSMutableArray *arr = [self.showDic objectForKey:self.titleArray[indexPath.section]];
        GetPathModel *model = arr[indexPath.row];
        cell.index = indexPath.row;
        cell.model = model;
        return cell;
    }
    
    SeePathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SeePathTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSMutableArray *arr = [self.showDic objectForKey:self.titleArray[indexPath.section]];
    GetPathModel *model = arr[indexPath.row];
    cell.index = indexPath.row;
    cell.model = model;
    return cell;
}
//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        SeePathFiristTableViewHeaderFooterView *header = [SeePathFiristTableViewHeaderFooterView headerViewWithTableView:tableView];
        header.alarm = self.titleArray[section];
        header.deleagte = self;
        header.idnex = section;
        return header;
    }else {
        SeePathTableViewHeaderFooterView *header = [SeePathTableViewHeaderFooterView headerViewWithTableView:tableView];
        header.alarm = self.titleArray[section];
        header.deleagte = self;
        header.idnex = section;
        return header;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50.5+16;
    }
    return 50.5;
}
- (void)seePathTableViewHeaderFooterView:(SeePathTableViewHeaderFooterView *)view index:(NSInteger)idnex{
    
    NSString *key = self.titleArray[idnex];
   
    if ([view.alarm.open boolValue]) {
        view.alarm.open = @"NO";
        [self.showDic removeObjectForKey:key];
    }else {
        view.alarm.open = @"YES";
        [self.showDic setObject:self.dict[key] forKey:key];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:idnex] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)seePathFiristTableViewHeaderFooterView:(SeePathFiristTableViewHeaderFooterView *)view index:(NSInteger)idnex {
    NSString *key = self.titleArray[idnex];
    
    if ([view.alarm.open boolValue]) {
        view.alarm.open = @"NO";
        [self.showDic removeObjectForKey:key];
    }else {
        view.alarm.open = @"YES";
        [self.showDic setObject:self.dict[key] forKey:key];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:idnex] withRowAnimation:UITableViewRowAnimationFade];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SeePathTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *arr = [self.showDic objectForKey:self.titleArray[indexPath.section]];
    GetPathModel *model = arr[indexPath.row];
    if (model.select) {
        [self.selectArray removeObject:model];
        model.select = NO;
    }else {
        [self.selectArray addObject:model];
        model.select = YES;
    }
    //每次判断是否全选
    [self isChooseAll:self.dataArray];
//    if (self.selectArray.count > 0) {
//        _commitBtn.userInteractionEnabled = YES;
//        [_commitBtn setTitleColor:[UIColor whiteColor]];
//    }else {
//        _commitBtn.userInteractionEnabled = NO;
//        [_commitBtn setTitleColor:[UIColor lightTextColor]];
//    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -
#pragma mark 全选
- (void)chooseAll {
    
    if (self.chooseall) {
        self.chooseall = NO;
        self.bottomImageView.image = [UIImage imageNamed:@"mapchoose"];
        [self chooseAllSoureDataArray:self.dataArray ret:NO];
        [self.selectArray removeAllObjects];
    }else {
        self.chooseall = YES;
        self.bottomImageView.image = [UIImage imageNamed:@"mapchoose_se"];
        [self chooseAllSoureDataArray:self.dataArray ret:YES];
        [self.selectArray removeAllObjects];
        [self.selectArray addObjectsFromArray:self.dataArray];
    }
}
- (void)chooseAllSoureDataArray:(NSArray *)arr ret:(BOOL)ret {
    
    [self.titleArray removeAllObjects];
    for (GetPathModel *model in arr) {
        
        model.select = ret;
        NSString *alarm2 = model.alarm;
        if (![self isHaveAlarm:alarm2]) {
            alarm2.myId = model.name;
            alarm2.open = @"YES";
            [self.titleArray addObject:alarm2];
        }
    }
    for (int i = 0; i < self.titleArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < arr.count; j++) {
            GetPathModel *model = arr[j];
            
            if ([model.alarm isEqualToString:self.titleArray[i]]) {
                
                [array addObject:model];
            }
            if (j == self.titleArray.count-1) {
                [self.dict setObject:array forKey:self.titleArray[i]];
            }
        }
    }
    self.showDic = [self.dict mutableCopy];
    [self.tableView reloadData];
}
//判断是否进入全选状态
- (void)isChooseAll:(NSArray *)arr {
    
    BOOL ret = YES;
    for (GetPathModel *model in arr) {
        if (!model.select) {
            ret = NO;
            break;
        }
    }
    if (!ret) {
        
        self.bottomImageView.image = [UIImage imageNamed:@"mapchoose"];
    }else {
        self.chooseall = YES;
        self.bottomImageView.image = [UIImage imageNamed:@"mapchoose_se"];
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
