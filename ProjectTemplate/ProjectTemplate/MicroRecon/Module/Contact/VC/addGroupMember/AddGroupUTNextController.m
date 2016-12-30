//
//  AddGroupUTNextController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AddGroupUTNextController.h"
#import "UtOneTableViewCell.h"
#import "UserAllTableViewCell.h"


@interface AddGroupUTNextController ()

@end

@implementation AddGroupUTNextController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delRefreshUI:) name:DeleteUTNotification object:nil];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)delRefreshUI:(NSNotification *)notfication {
    
    [_tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.isContact = NO;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    return cell;
    
}
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
        
        AddGroupUTNextController *next = [[AddGroupUTNextController alloc] init];
        
        next.userArray = self.userArray;
        next.departArray = self.departArray;
        next.nextUserArr = self.nextUserArray;
        next.titleStr = model.DE_name;
        next.arr = self.nextArray;
        
        [self.navigationController pushViewController:next animated:YES];
        
        
    }else if ([self.dataArray[indexPath.row] isKindOfClass:[UserAllModel class]]){
        
        
        UserAllModel *allModel = self.dataArray[indexPath.row];
        
        UserAllTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([allModel.isSelect isEqualToString:@"YES"]) {
            
            allModel.isSelect = @"NO";
            cell.isSelect = NO;
        }else {
            
            allModel.isSelect = @"YES";
            cell.isSelect = YES;
        }
        [cell selectedCell];
        
    }
    
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
