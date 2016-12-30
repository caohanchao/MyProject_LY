//
//  SystemUpdateController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SystemUpdateController.h"
#import "SysUpdataTableViewCell.h"
#import "JsPatchModel.h"

@interface SystemUpdateController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SystemUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统更新";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initall];
}
- (void)initall {
    [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] systemUpdataSQ] selectSystemUpdatalist]];
    [self createTableView];
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    
    SysUpdataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SysUpdataTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    JsPatchModel *model = self.dataArray[indexPath.row];
    cell.version = model.jsDetailedInf;
    cell.time = model.time;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
#pragma mark -
#pragma mark 删除某个cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JsPatchModel *model = self.dataArray[indexPath.row];
    [[[DBManager sharedManager] systemUpdataSQ] deleteSystemUpdata:model.appVersion jsVersion:model.jsVersion];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
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
