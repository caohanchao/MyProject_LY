//
//  RollCallDetailsViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "RollCallDetailsViewController.h"
#import "CallTheRollFirstHeaderView.h"
#import "CallTheRollFirstTableViewCell.h"
#import "CallTheRollSecondHeaderView.h"
#import "CallTheRollSecondTableViewCell.h"
#import "RollCallDetailsViewController.h"
#import "CallTheRollDeatilBaseModel.h"
#import "RollCallSendUserListViewController.h"
#import "CollCallPickerView.h"
#import "EditRollCallViewController.h"
#import "GetreportuserbydayBaseModel.h"


@interface RollCallDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, CollCallPickerViewDelegate, EditRollCallDelegate> {

    UIButton *_editButton;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *firstSectionImageDataSource;
@property (nonatomic, strong) NSMutableArray *firstSectionTitleDataSource;
@property (nonatomic, strong) NSMutableArray *firstSectionContentDataSource;

@property (nonatomic, strong) CallTheRollDeatilModel *deatilModel;
//日历选择日期
@property(nonatomic,strong) CollCallPickerView *cuiPickerView;

@property (nonatomic, assign) BOOL notreported; // 未报道

@property (nonatomic, strong)  NSMutableArray *havereportedArray; // 已报道
@property (nonatomic, strong)  NSMutableArray *notreportedArray; // 未报道
@property (nonatomic, strong)  NSMutableArray *reportedArray; //第二分区数据源

@property (nonatomic, copy) NSString *selectDate; // 选择的日期


@end

@implementation RollCallDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"点名详情";
    [self initall];
}
- (void)initall {
    [self initNav];
    [self initFirstSectionDataSource];
    [self getReportDetailHttps];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cuiPickerView];
    
}
- (NSMutableArray *)havereportedArray {
    if (!_havereportedArray) {
        _havereportedArray = [NSMutableArray array];
    }
    return _havereportedArray;
}
- (NSMutableArray *)notreportedArray {
    if (!_notreportedArray) {
        _notreportedArray = [NSMutableArray array];
    }
    return _notreportedArray;
}
- (NSMutableArray *)reportedArray {
    if (!_reportedArray) {
        _reportedArray = [NSMutableArray array];
    }
    return _reportedArray;
}
- (void)initNav {
 
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(0, 0, 40, 40);
    _editButton.titleLabel.font = ZEBFont(16);
    [_editButton setTitleColor:zWhiteColor];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    _editButton.hidden = YES;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
}
- (void)edit {
    EditRollCallViewController * editRollCallVC = [[EditRollCallViewController alloc]init];
    editRollCallVC.deatilModel = self.deatilModel;
    editRollCallVC.delegate = self;
    [self.navigationController pushViewController:editRollCallVC animated:YES];
}
//日期选择
- (CollCallPickerView *)cuiPickerView {
    if (!_cuiPickerView) {
        _cuiPickerView = [CollCallPickerView new];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.delegate = self;
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _cuiPickerView;
}
#pragma mark -
#pragma mark http
- (void)getReportDetailHttps {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"action"] = @"rallcallinfo";
    parm[@"alarm"] = alarm;
    parm[@"token"] = token;
    parm[@"rallcallid"] = self.rallcallid;

    [self showloadingName:@"正在加载..."];
    [HYBNetworking postWithUrl:getReportDetailUrl refreshCache:YES params:parm success:^(id response) {
        CallTheRollDeatilBaseModel *baseModel = [CallTheRollDeatilBaseModel getInfoWithData:response];
        self.deatilModel = baseModel.deatilModel;
        // 整理数据
        [self getSoureData];
        [self hideHud];
    } fail:^(NSError *error) {
        [self hideHud];
    }];
}
- (void)getreportuserbydayHttps {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
//    NSString *urlString = @"http://112.74.129.54:13201/MicroRecon/1.2/getreportuserbyday?osType=ios&action=getreportuserbyday&alarm=0022&token=608f30b3229eb5324083425a70f52c15&rallcallid=yUrqaeANbzQyqu2Uy7Q7&day=2016-12-01";
//    
    NSString *urlString = [NSString stringWithFormat:getreportuserbydayUrl,alarm,token,self.rallcallid,self.selectDate];

    [self showloadingName:@"正在加载..."];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        [self hideHud];
        GetreportuserbydayBaseModel *baseModel = [GetreportuserbydayBaseModel getInfoWithData:response];
        if (baseModel.results.count > 0) {
            [self getSoureSecondData:baseModel.results];
            [self.reportedArray removeAllObjects];
            if (self.notreported) {
                [self.reportedArray addObjectsFromArray:self.notreportedArray];
            }else {
                [self.reportedArray addObjectsFromArray:self.havereportedArray];
            }
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }else {
            [self showHint:@"此天没有任何数据"];
        }
    } fail:^(NSError *error) {
        [self hideHud];
    }];
}
#pragma mark -
#pragma mark 数据格式化
- (void)getSoureData {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    [self.firstSectionContentDataSource removeAllObjects];
    NSArray *contentArr = @[[LZXHelper isNullToString:[self.deatilModel.start_time rollCallDetailTimeChangeHHmm]],[LZXHelper isNullToString:[self.deatilModel.end_time rollCallDetailTimeChangeHHmm]],[self getsendUserName],[self getselectWeek]];
    self.firstSectionContentDataSource = [NSMutableArray arrayWithArray:contentArr];
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) { // 0重复
        self.rollType = RepeatRoll;
        if ([self.deatilModel.publish_alarm isEqualToString:alarm] && ![self.deatilModel.sign_state isEqualToString:@"0"]) {// 点名的状态(0,1,2,3:点名中,待点名,已完成,已关闭)
            _editButton.hidden = NO;
        }
        
    }else if ([self.deatilModel.isrepeat isEqualToString:@"1"]) { // 1单次
        self.rollType = SingleRoll;
        
        if ([self.deatilModel.publish_alarm isEqualToString:alarm] && [self.deatilModel.sign_state isEqualToString:@"1"]) { // 点名的状态(0,1,2,3:点名中,待点名,已完成,已关闭)
            _editButton.hidden = NO;
        }
    }
    [self getSoureSecondData:self.deatilModel.userlist];
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark 返回发送给谁的字符串
- (NSString *)getsendUserName {
    
    NSMutableArray *nameArr = [NSMutableArray array];
    for (CallTheRollUserListModel *uModel in self.deatilModel.userlist) {
        [nameArr addObject:uModel.report_name];
    }
    return [nameArr componentsJoinedByString:@"，"];
}
#pragma mark -
#pragma mark 返回选中周几的字符串
- (NSString *)getselectWeek {
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *weekstring = self.deatilModel.week;
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
        for (int i = 0; i < weekstring.length; i++) {
            NSString *str = [NSString stringWithFormat:@"%c",[weekstring characterAtIndex:i]];
            if ([str isEqualToString:@"1"]) {
                switch (i) {
                    case 0:
                        [string  appendString:@"周日"];
                        break;
                    case 1: {
                        if (string.length == 0) {
                            [string appendString:@"周一"];
                        }else {
                            [string appendString:@"，周一"];
                        }
                    }
                        break;
                    case 2:
                        if (string.length == 0) {
                            [string appendString:@"周二"];
                        }else {
                            [string appendString:@"，周二"];
                        }
                        break;
                    case 3:
                        if (string.length == 0) {
                            [string appendString:@"周三"];
                        }else {
                            [string appendString:@"，周三"];
                        }
                        break;
                    case 4:
                        if (string.length == 0) {
                            [string appendString:@"周四"];
                        }else {
                            [string appendString:@"，周四"];
                        }
                        break;
                    case 5:
                        if (string.length == 0) {
                            [string appendString:@"周五"];
                        }else {
                            [string appendString:@"，周五"];
                        }
                        break;
                    case 6:
                        if (string.length == 0) {
                            [string appendString:@"周六"];
                        }else {
                            [string appendString:@"，周六"];
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    return string;
}
#pragma mark -
#pragma mark 获取报道人 和未报道人
- (void)getSoureSecondData:(NSMutableArray *)arr {
    
    [self.havereportedArray removeAllObjects];
    [self.notreportedArray removeAllObjects];
    [self.reportedArray removeAllObjects];
    for (CallTheRollUserListModel *uModel in arr) {
        if ([uModel.self_state isEqualToString:@"0"]) { // 未报道
            [self.notreportedArray addObject:uModel];
        }else if ([uModel.self_state isEqualToString:@"1"]) { // 已报道
            [self.havereportedArray addObject:uModel];
        }
    }
    [self.reportedArray addObjectsFromArray:self.havereportedArray];
}
- (void)initFirstSectionDataSource {
    NSArray *imageArr = @[@"icon_start-time",@"icon_effective-time",@"icon_at",@"icon_repeat"];
    NSArray *titleArr = @[@"开始时间",@"结束时间",@"发送给谁",@"重复"];
    
    self.firstSectionImageDataSource = [NSMutableArray arrayWithArray:imageArr];
    self.firstSectionTitleDataSource = [NSMutableArray arrayWithArray:titleArr];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-TopBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = zWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.rollType == SingleRoll) {
            return 3;
        }
        return 4;
    }

    return self.reportedArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indextifier1 = @"indextifier1";
    static NSString *indextifier2 = @"indextifier2";
    
    if (indexPath.section == 0) {
        CallTheRollFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier1];
        if (cell == nil) {
            cell = [[CallTheRollFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier1];
        }
        if (indexPath.row != 2) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        cell.index = indexPath.row;
        cell.image = self.firstSectionImageDataSource[indexPath.row];
        cell.title = self.firstSectionTitleDataSource[indexPath.row];
        cell.content = self.firstSectionContentDataSource[indexPath.row];
        return cell;
    }else if (indexPath.section == 1) {
    
    CallTheRollSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier2];
    if (cell == nil) {
        cell = [[CallTheRollSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier2];
    }
    cell.notreported = self.notreported;
    cell.userListModel = self.reportedArray[indexPath.row];
    return cell;
    }
    return [[UITableViewCell alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.5;
    }
    return 70.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 110.5;
    }else if (section == 1) {
        return 51.5;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CallTheRollFirstHeaderView *headView = [CallTheRollFirstHeaderView headerViewWithTableView:tableView];
        headView.deatilModel = self.deatilModel;
        return headView;
    }else if (section == 1) {
        
        CallTheRollSecondHeaderView *headView = [CallTheRollSecondHeaderView headerViewWithTableView:tableView block:^(NSInteger type) {
            WeakSelf
            switch (type) {
                case 0:{
                    if (weakSelf.notreported) {
                        weakSelf.notreported = NO;
                        [weakSelf.reportedArray removeAllObjects];
                        [weakSelf.reportedArray addObjectsFromArray:weakSelf.havereportedArray];
                        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                        [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
                    break;
                case 1:{
                    if (!weakSelf.notreported) {
                        weakSelf.notreported = YES;
                        [weakSelf.reportedArray removeAllObjects];
                        [weakSelf.reportedArray addObjectsFromArray:weakSelf.notreportedArray];
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                        [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
                    break;
                default:
                    break;
            }
        } dateBlock:^(CallTheRollSecondHeaderView *headView) {
            self.cuiPickerView.curDate = [self getCurrentTime];
            [self.cuiPickerView showInView:self.view];
        }];
        headView.notreportedCount = self.notreportedArray.count;
        headView.havereportedCount = self.havereportedArray.count;
        headView.notreported = self.notreported;
        if (self.rollType == SingleRoll) {
            headView.showDateBtn = NO;
        }else if (self.rollType == RepeatRoll) {
            headView.showDateBtn = YES;
        }
        return headView;
    }
    return [UIView new];
}
//获取当前时间
- (NSDate *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        RollCallSendUserListViewController *sendUserListViewController = [[RollCallSendUserListViewController alloc] init];
        sendUserListViewController.dataArray = [self.deatilModel.userlist mutableCopy];
        [self.navigationController pushViewController:sendUserListViewController animated:YES];
    }
    
}

#pragma mark -
#pragma mark CollCallPickerView delegate
-(void)didFinishPickView:(NSString*)date {
    self.selectDate = date;
    [self getreportuserbydayHttps];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self cuiPickerHide];
    }
}
//日期选择消失
- (void)cuiPickerHide
{
    if (!self.cuiPickerView) {
        return;
    }else {
        [self.cuiPickerView hiddenPickerView];
    }
}

#pragma mark -
#pragma mark EditRollCallDelegate
- (void)finishEditRollCall:(EditRollCallViewController *)finishEdit {
    [self getReportDetailHttps];
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
