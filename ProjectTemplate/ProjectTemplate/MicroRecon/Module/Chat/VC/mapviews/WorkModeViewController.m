//
//  WorkModeViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkModeViewController.h"

@interface WorkModeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSArray *titleArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation WorkModeViewController
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"走线",@"走访",@"追踪"];
    }
    return  _titleArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), screenHeight()-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作模式";
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTableView];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.separatorColor = CHCHexColor(@"eeeeee");
//    [tableView setSeparatorInset:UIEdgeInsetsMake(0, -30, 0, 0)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, screenWidth(), 0.5)];
        line.backgroundColor = CHCHexColor(@"eeeeee");
        [cell.contentView addSubview:line];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = ZEBFont(14);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case RoutingWorkMode:
        {
            self.WorkModeBlock(RoutingWorkMode,self.titleArray[indexPath.row]);
        }
            break;
        case VisitingWorkMode:
        {
            self.WorkModeBlock(VisitingWorkMode,self.titleArray[indexPath.row]);
        }
            break;
        case TrackWorkMode:
        {
            self.WorkModeBlock(TrackWorkMode,self.titleArray[indexPath.row]);
        }
            break;
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
