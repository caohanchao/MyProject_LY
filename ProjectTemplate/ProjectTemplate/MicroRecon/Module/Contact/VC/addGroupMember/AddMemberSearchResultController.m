//
//  AddMemberSearchResultController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AddMemberSearchResultController.h"
#import "UserAllModel.h"
#import "FriendsListModel.h"

@interface AddMemberSearchResultController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation AddMemberSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initall];
}
- (void)initall {
    
    [self createTableView];
    
}

#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-64-44-142) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
//刷新列表
- (void)reloadTableView {

    [_tableView reloadData];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:5.f rectCornerType:UIRectCornerAllCorners];
        imageView.frame = CGRectMake(10, 10, 35, 35);
        imageView.tag = 1001;
        
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(maxX(imageView), 10, 150, 35)];
        label.font = ZEBFont(15);
        label.textColor = [UIColor blackColor];
        label.tag = 1002;
        [cell.contentView addSubview:label];
    }
   
    
    UIImageView *imageView = [cell.contentView viewWithTag:1001];
    UILabel *label = [cell.contentView viewWithTag:1002];
    
    if (self.dataArray.count != 0) {
        if ([self.dataArray[indexPath.row] isKindOfClass:[FriendsListModel class]]) {
            
            
            FriendsListModel *model = self.dataArray[indexPath.row];
            
            label.text = model.name;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:nil];
            
            
        }else if ([self.dataArray[indexPath.row] isKindOfClass:[UserAllModel class]]) {
            
            
            UserAllModel *model = self.dataArray[indexPath.row];
            
            label.text = model.RE_name;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.RE_headpic] placeholderImage:nil];
        }
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id model = self.dataArray[indexPath.row];
    if (model) {
        if (_delegate && [_delegate respondsToSelector:@selector(addMemberSearchResultController:model:)]) {
            [_delegate addMemberSearchResultController:self model:model];
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:self];
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
