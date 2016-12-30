//
//  SystemRemindController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SystemRemindController.h"
#import "SystemRemindCell.h"
#import "XMNChatController.h"
#import "UserHomePageViewController.h"
#import "CircleOfBattleController.h"
@interface SystemRemindController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)NSInteger page;

@end





@implementation SystemRemindController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenWidth(), screenHeight()-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray){
        _dataArray = [[[DBManager sharedManager] MessageDAO] selectSystemMessageByPage:_page];
        _dataArray = [[_dataArray reverseObjectEnumerator] allObjects];
    }
    return _dataArray;

}


- (void)scrollToBottom:(BOOL)animated {
    // 1.获取最后一行
    if (self.dataArray.count == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.dataArray.count - 1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)scrollToSection:(BOOL)animated section:(NSUInteger)section{
    // 1.获取最后一行
    if (self.dataArray.count == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:(self.dataArray.count - section) + 1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.title = @"系统提醒";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataArray:) name:UpdateSystemRemindNotification object:nil];
    
    [self createTableView];
    
    [self footRefresh];
    
    [self scrollToBottom:YES];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - FootRefresh
- (void)footRefresh {

//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}

- (void)refreshAction{
    
    _page ++;
    NSInteger count = self.dataArray.count+1;
    
    NSArray *array = [[[DBManager sharedManager] MessageDAO] selectSystemMessageByPage:_page];
    array = [[array reverseObjectEnumerator] allObjects];
    if (array.count == 0) {
        [self.tableView.mj_header endRefreshing];
    }else {
        [self.dataArray addObjectsFromArray:array];
        
        NSArray *results = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ICometModel *model1 = obj1;
            ICometModel *model2 = obj2;
            NSComparisonResult result = [model1.beginTime compare:model2.beginTime];
            return result == NSOrderedDescending;
        }];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:results];
        
        
    
        [self.tableView reloadData];
        
        
        if (count > 3) {
            [self scrollToSection:NO section:count];
        }
        [self scrollToSection:NO section:count];
        
        [self.tableView.mj_header endRefreshing];

    }

}



#pragma mark - CreateUI / ReloadData
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    [self.view addSubview:self.tableView];
}

//- (void)updateDataArray:(NSNotification *)notification {
//    
//    //    [self.dataArray removeAllObjects];
//    _page = 0;
//    ICometModel *model = notification.object;
//    [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.rid];
//    self.dataArray = [[[DBManager sharedManager] MessageDAO] selectSystemMessageByPage:_page];
//    
//    self.dataArray = [[self.dataArray reverseObjectEnumerator] allObjects];
////    [self.tableView.mj_footer resetNoMoreData];
//    [self.tableView.mj_header refreshingAction];
//    [self.tableView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cellidentifier";
    SystemRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[SystemRemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //草稿箱上传
//    cell.draftsUploadClick = ^(WorkAllTempModel *model){
//        
//        [weakself httpUploadDrafts:model];
//    };
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ICometModel *model =self.dataArray[indexPath.section];
    //上线提醒
    if ([model.mtype isEqualToString:@"O"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"S" forKey:@"chatType"];
        [[NSUserDefaults standardUserDefaults] setObject:model.data forKey:@"chatId"];
        XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatSingle];
        chatC.chatterName = model.sname;
        chatC.cType = ChatList;
        [[[DBManager sharedManager] UserlistDAO] clearAtAlarmMsg:model.data];
        [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.data];
        [self.navigationController pushViewController:chatC animated:YES];
        
    }//战友圈提醒
    else if ([model.mtype isEqualToString:@"P"]) {
//        UserHomePageViewController *uvc = [[UserHomePageViewController alloc] init];
//        uvc.userIDStr = model.data;
//        [self.navigationController pushViewController:uvc animated:YES];
        CircleOfBattleController *cvc =[[CircleOfBattleController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section  {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144;
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
