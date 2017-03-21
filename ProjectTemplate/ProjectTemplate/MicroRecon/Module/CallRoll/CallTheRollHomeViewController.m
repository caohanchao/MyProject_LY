//
//  CallTheRollHomeViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollHomeViewController.h"
#import "CallTheRollHomeTableViewCell.h"
#import "CreateCollCallViewController.h"
#import "RollCallDetailsViewController.h"
#import "CallTheRollRequest.h"
#import "CallTheRollBaseModel.h"
#import "CallTheRollDetailModel.h"
#import "XMLocationManager.h"
@interface CallTheRollHomeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,copy)NSMutableArray *dataArray;

@property (nonatomic,copy)NSArray *pageArray;

@property (nonatomic,copy)NSMutableArray *headBarItems; //装头部的容器

@property (nonatomic,copy)NSArray *headBarItemsTitle;

@property (nonatomic,strong)UISegmentedControl *segmentControl;

@property (nonatomic,strong)UIImageView *headBar;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)NSInteger headItemsSelect;

@property (nonatomic,strong)NSMutableDictionary *dataDict;

@property (nonatomic,strong)CallTheRollDetailModel *detailModel;

@end

@implementation CallTheRollHomeViewController

- (CallTheRollDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [CallTheRollDetailModel new];
    }
    return _detailModel;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (NSArray *)headBarItemsTitle {
    if (!_headBarItemsTitle) {
        _headBarItemsTitle = @[@"点名进行",@"点名结束"];
    }
    return _headBarItemsTitle;
}

- (NSMutableArray *)headBarItems {
    if (!_headBarItems) {
        _headBarItems = [NSMutableArray array];
    }
    return _headBarItems;
}

- (NSArray *)pageArray {
    if (!_pageArray ) {
        _pageArray = @[@"我的接收",@"我的创建"];
    }
    return _pageArray;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (UIImageView *)headBar {
    if (!_headBar) {
        _headBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_tionbar"]];
        _headBar.userInteractionEnabled = YES;
        for (int i = 0; i<self.headBarItemsTitle.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.headBarItemsTitle[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:zGrayColor];
            if (i == 0) {
                [btn setTitleColor:zBlueColor];
            }
            btn.titleLabel.font  = ZEBFont(14);
            btn.frame = CGRectMake(i*(screenWidth()/2), _headBar.frame.origin.y, screenWidth()/2, height(_headBar.frame));
            
            [self.headBarItems addObject:btn];
            
            [_headBar addSubview:btn];
        }
        
    }
    return _headBar;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:self.pageArray];
        [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:zBlueColor} forState:UIControlStateSelected];
        _segmentControl.selectedSegmentIndex = 0;
        _createType = ISReceiveType;
        [_segmentControl addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.tintColor = zWhiteColor;
    }
    return _segmentControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData:@"1"]; //默认接收
    
    [self initAll];
    
    
    // Do any additional setup after loading the view.
}

- (void)requestData:(NSString *)type {
    
    [self showloadingName:@"正在请求数据"];
    [CallTheRollRequest getCallTheRollList:type success:^(id  _Nullable reponse) {
        [self hideHud];
        CallTheRollBaseModel *baseModel = reponse;
        self.detailModel = baseModel.results;
        
        [self setDataArrayWithCallRollType:@"0"];
        
        [self.tableView reloadData];
        
        NSLog(@"%@",self.dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"请求服务器失败"];
    }];
}

- (void)setDataArrayWithCallRollType:(NSString *)type {
    if ([type isEqualToString:@"0"]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:self.detailModel.rallcalling];
        [self.dataArray addObject:self.detailModel.rallcalled];
    }
    else if([type isEqualToString:@"1"]){
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:self.detailModel.rallcallfinish];
        [self.dataArray addObject:self.detailModel.rallcallend];
    }
}

- (void)setCreateType:(CreateTaskOfCallTheRallType)createType {
    _createType = createType;
    [self setHeadBarItemSelectDefalt];
}



- (void)initAll {
    
    [self addNav];
   
    [self addHeadBar];
}

- (void)addNav {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.titleView = self.segmentControl;
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"roll_found"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)] WithSpace:5];
}

- (void)addHeadBar {
    [self.view addSubview:self.headBar];
    [self.headBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBar.mas_bottom).offset(4);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - Action

- (void)segmentValueChange:(UISegmentedControl *)control {
    NSInteger index = control.selectedSegmentIndex;
    if (index == 0) {
        self.createType = ISReceiveType;
        
    }else {
        self.createType = ISCreateType;
    }
}

- (void)rightClick {


    CreateCollCallViewController * collcallVC = [[CreateCollCallViewController alloc]init];
    collcallVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collcallVC animated:YES];
    
}

- (void)btnClick:(UIButton *)btn {
    for (UIButton *item in self.headBarItems) {
        if (btn == item) {
            [item setTitleColor:zBlueColor];
            if (item == [self.headBarItems firstObject]) {
                self.headItemsSelect = 0;
                [self reloadCallingTheRall];
            }else{
                self.headItemsSelect = 1;
                [self reloadEndCallTheRoll];
            }
        }else if (btn != item){
            [item setTitleColor:zGrayColor];
        }
    }
}

#pragma mark - reload
- (void)reloadCallingTheRall {
    [self setDataArrayWithCallRollType:[NSString stringWithFormat:@"%ld",self.headItemsSelect]];
    [self.tableView reloadData];
}

- (void)reloadEndCallTheRoll {
    [self setDataArrayWithCallRollType:[NSString stringWithFormat:@"%ld",self.headItemsSelect]];
    [self.tableView reloadData];
}




#pragma mark - private

- (void)setHeadBarItemSelectDefalt{
    for (UIButton *item in self.headBarItems) {
        if (item == [self.headBarItems firstObject]) {
            [item setTitleColor:zBlueColor];
            self.headItemsSelect = 0;
            [self.dataArray removeAllObjects];
//            [self.tableView reloadData];
            [self requestData:[NSString stringWithFormat:@"%ld",self.createType]];
        }else{
            [item setTitleColor:zGrayColor];
        }
    }
}

#pragma mark - 请求每个分区的数量
- (NSInteger )reuqestCountCallRoll:(NSInteger )section {
    NSInteger count = 0;
    
    if (self.dataArray.count > 0) {
        if (!self.dataArray[section]) {
            count = 0;
        } else{
            NSArray *arr = self.dataArray[section];
            count = arr.count;
        }
    }
    return count;
}

#pragma mark - 请求每个cell的类型
- (CallTheRallType )requestCallRollTypeWithIndexPath:(NSIndexPath *)indexPath{
    CallTheRallType type;
    if (self.dataArray.count > 0) {
        if (self.headItemsSelect == 0) {
            if (indexPath.row == 0) {
                type = CallingTheRall;
            }else if (indexPath.row == 1) {
                type = WillCallTheRall;
            }
        }else if (self.headItemsSelect == 1){
            if (indexPath.row == 0) {
                type = CalledTheRall;
            }else if (indexPath.row == 1) {
                type = CloseTheTaskOfCallTheRall;
            }
        }
    }
    return type;
}

#pragma mark -UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self reuqestCountCallRoll:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indextifier = @"indextifier";
    
    if (self.dataArray.count > 0) {
        CallTheRollHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
        if (cell == nil) {
            cell = [[CallTheRollHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
            
        }
//        cell.isReceiveOrCreateMode = self.createType;
    /*
        callback内回调cell上的按钮点击
     */
        WeakSelf;
        [cell configWithModel:self.dataArray[indexPath.section][indexPath.row] withCallRollType:[self requestCallRollTypeWithIndexPath:indexPath] withReceiveOrCreateMode:self.createType withCallBack:^(id object, BOOL isSwitchOn, NSString *reportId) {
            
            if ([object isKindOfClass:[UIButton class]]) {
                [weakSelf reportCallTheRallWithID:reportId];
            } else if ([object isKindOfClass:[UISwitch class]]) {
                [weakSelf reportActiveCallTheRallWithID:reportId withIsON:isSwitchOn];
            }
            
        }];
        
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 30;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), height)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    NSArray *array1 = @[@"点名中",@"待点名"];
    NSArray *array2 = @[@"已完成",@"已关闭"];
//    NSInteger count = 0;
//    
//    if (self.dataArray.count > 0) {
//        if (!self.dataArray[section]) {
//            count = 0;
//        } else{
//            NSArray *arr = self.dataArray[section];
//            count = arr.count;
//        }
//    }
    
    if (self.headItemsSelect == 0) {
        [label setText:[NSString stringWithFormat:@"%@(%ld)",array1[section],[self reuqestCountCallRoll:section]]];
    }else {
        [label setText:[NSString stringWithFormat:@"%@(%ld)",array2[section],[self reuqestCountCallRoll:section]]];
    }
    label.frame = CGRectMake(12, (height-11)/2, 100, 11);
    label.font = ZEBFont(11);
    label.textColor = zGrayColor;
    [view addSubview:label];
    

//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(12,CGRectGetMaxY(view.bounds)-1 , screenWidth()-12, 1)];
//    line.backgroundColor = LineColor;
//    [view addSubview:line];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CallTheRollListDetailModel * model = self.dataArray[indexPath.section][indexPath.row];
    RollCallDetailsViewController *rvc = [[RollCallDetailsViewController alloc] init];
    rvc.rallcallid = model.rallcallid;
    [self.navigationController pushViewController:rvc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//回调请求数据
- (void)reportCallTheRallWithID:(NSString *)reportId {
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    info[@"rallcallid"] = reportId;
    info[@"latitude"] = delegate.latitude;
    info[@"longitude"] = delegate.longitude;
    
    [[XMLocationManager shareManager] reverseGeocodeWithCoordinate2D:(CLLocationCoordinate2D){[delegate.latitude doubleValue],[delegate.longitude doubleValue]} success:^(NSArray *pois) {
        if (pois && pois.count > 0) {
            CLPlacemark *position = pois[0];
            info[@"position"] = position.addressDictionary[@"FormattedAddressLines"];
            [CallTheRollRequest GetReport:info success:^(id  _Nullable reponse) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                                     options:NSJSONReadingMutableContainers error:nil];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        
    } failure:^{
        [self showHint:@"获取定位失败"];
    }];
    
    
    
//    [CallTheRollRequest GetReport:info success:^(id  _Nullable reponse) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}

- (void)reportActiveCallTheRallWithID:(NSString *)reportId withIsON:(BOOL)isON {
    
    NSString * activeState = [NSString stringWithFormat:@"%d",isON];
    [CallTheRollRequest GetReportActive:activeState withReportId:reportId success:^(id  _Nullable reponse) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                             options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"resultcode"] isEqualToString:@"0"]) {
            [self requestData:[NSString stringWithFormat:@"%ld",self.createType]];
            [self showHint:@"请求成功"];
        }
        else {
            [self showHint:@"请求失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
