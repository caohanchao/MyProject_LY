//
//  DuplicateViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "DuplicateViewController.h"

#define TopMargin 13

@interface DuplicateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView* duplicateTableView;
@property(nonatomic, strong) NSArray* titleArray;
@property(nonatomic, strong) NSArray* dateArray;
@property(nonatomic, assign) CGFloat  dateWidth;

@property(nonatomic, strong)NSMutableArray* selectIndexArray;

@end

@implementation DuplicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"重复";
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    
    _selectIndexArray = [NSMutableArray arrayWithCapacity:0];
    if (self.IndexArray.count>0) {
        [_selectIndexArray addObjectsFromArray:self.IndexArray];
    }
    
    [self.view addSubview:self.duplicateTableView];
    
    _dateWidth = [LZXHelper textWidthFromTextString:@"每周日" height:12 fontSize:14];
  //  _dateArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
}

- (UITableView*)duplicateTableView
{
    if (!_duplicateTableView) {
        _duplicateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, screenWidth(), screenHeight()-40) style:UITableViewStyleGrouped];
        _duplicateTableView.showsVerticalScrollIndicator = NO;
        _duplicateTableView.delegate = self;
        _duplicateTableView.dataSource = self;
        _duplicateTableView.separatorColor = CHCHexColor(@"EBEAF1");
    }
    return _duplicateTableView;
}

//标题
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@[@"每周日",@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六"]];
    }
    return _titleArray;
}

#pragma mark -------- UITABLEVIEWDELEGATE/UITABLEVIEWDATASOURCE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"duplicate";
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, TopMargin, _dateWidth, 12)];
    dateLabel.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.section][indexPath.row]];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = CHCHexColor(@"303030");
    [cell.contentView addSubview:dateLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.tintColor = [UIColor redColor];
    
    for (__strong NSString * str in _selectIndexArray) {
//        if ([str isEqualToString:@"7"]) {
//            str = @"0";
//        }
        
        if ([str isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * selsetStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    if (indexPath.row == 0) {
//        selsetStr = @"7";
//    }
    if ([_selectIndexArray containsObject:selsetStr]) {
        [_selectIndexArray removeObject:selsetStr];
    }
    else
    {
        [_selectIndexArray addObject:selsetStr];
    }
    [self.duplicateTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)viewDidLayoutSubviews
{
    if ([self.duplicateTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.duplicateTableView setSeparatorInset:UIEdgeInsetsMake(0,18,0,0)];
    }
    
    if ([self.duplicateTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.duplicateTableView setLayoutMargins:UIEdgeInsetsMake(0,18,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 18, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 18, 0, 0)];
    }
}

-(BOOL)navigationShouldPopOnBackButton
{
    
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //数组排序：
    NSArray *resultArray = [_selectIndexArray sortedArrayUsingComparator:finderSort];
    NSLog(@"第一种排序结果：%@",resultArray);
    
    if (resultArray.count>0) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:resultArray,@"selectRow", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateWeekStr" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return YES;
    }
    else
    {
        if ([self.rollCallType isEqualToString:@"edit"]) {
            [self showHint:@"至少选择一天"];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [super viewWillDisappear:animated];
    
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
