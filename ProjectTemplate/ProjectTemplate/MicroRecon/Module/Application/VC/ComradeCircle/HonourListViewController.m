//
//  HonourListViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "HonourListViewController.h"
#import "HonourTableViewCell.h"
#import "UserHomePageViewController.h"
#import "PostInfoModel.h"

#define LeftMargin 12

@interface HonourListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * topTableView;

@end

@implementation HonourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.title = @"荣誉";
    
    [self createAllUI];
}

-(void)createAllUI
{
    _topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [LZXHelper getScreenSize].width, [LZXHelper getScreenSize].height) style:UITableViewStylePlain];
    _topTableView.showsVerticalScrollIndicator = NO;
    _topTableView.showsHorizontalScrollIndicator = NO;
    _topTableView.delegate = self;
    _topTableView.dataSource = self;
    _topTableView.separatorColor = LineColor;
    _topTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_topTableView];
    
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


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.honourArray.count>0)
    {
        return self.honourArray.count;
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
    
    if (self.honourArray.count>0) {
        
        cell.model = self.honourArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostInfoModel * model ;
    if (self.honourArray.count>0) {
        model = self.honourArray[indexPath.row];
    }
    
    UserHomePageViewController * userHomePageVC = [[UserHomePageViewController alloc]init];
    userHomePageVC.userIDStr = model.alarm;
    [self.navigationController pushViewController:userHomePageVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
