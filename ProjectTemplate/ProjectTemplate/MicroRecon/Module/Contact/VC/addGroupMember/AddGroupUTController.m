//
//  AddGroupUTController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AddGroupUTController.h"
#import "UtOneTableViewCell.h"
#import "UserAllTableViewCell.h"
#import "AddGroupUTNextController.h"


//去掉警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"

@interface AddGroupUTController ()<UITableViewDataSource, UITableViewDelegate>



@property (nonatomic, strong) NSMutableArray *haveselectArray;
@end

@implementation AddGroupUTController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitUTArray:) name:CommitUTSelArrayNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delRefreshUI:) name:DeleteUTNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchRefreshUI:) name:SearchAddUTNotification object:nil];
    
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)delRefreshUI:(NSNotification *)notfication {
    
    NSMutableArray *array =[NSMutableArray arrayWithArray:self.haveselectArray];
    self.selArray = array;
    [self.haveselectArray removeAllObjects];
    [self sortDateArray:self.departArray];
}
- (void)addSearchRefreshUI:(NSNotification *)notfication {
    
    self.selArray = notfication.object;
    [self.haveselectArray removeAllObjects];
    [self sortDateArray:self.departArray];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)haveselectArray {
    
    if (_haveselectArray == nil) {
        _haveselectArray = [NSMutableArray array];
    }
    return _haveselectArray;
}

- (void)sortDateArray:(NSMutableArray *)arrays {
    
    [self.tempArray removeAllObjects];
    NSString *dateString1;
    
    for (UnitListModel * model in arrays) {
        
        NSString *dateString2 = model.DE_sjnumber;
        if (![dateString2 isEqualToString:dateString1]) {
            dateString1 = dateString2;
            [self.sjnumberArray addObject:dateString2];
        }
    }
    for (int i = 0; i < self.sjnumberArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < arrays.count; j++) {
            UnitListModel *model = arrays[j];
            NSString *dateString2 = model.DE_sjnumber;
            if ([dateString2 isEqualToString:self.sjnumberArray[i]]) {
                [array addObject:model];
                
            }
            if (j == self.sjnumberArray.count-1) {
                [self.dic setObject:array forKey:self.sjnumberArray[i]];
            }
            
        }
    }

    
    [self.tempArray addObjectsFromArray:[self.dic objectForKey:@"1"]];
    /**
     *  将人员插入数据原
     */
    [self getUserForOne];

}

- (void)getUserForOne {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.userArray];
    for (UserAllModel *model in temp) {
        for (GroupMemberModel *model1 in self.groupSettingSelArray) {
            if ([model.RE_alarmNum isEqualToString:model1.ME_uid]) {
                [self.userArray removeObject:model];
            }
        }
    }
    
    for (UserAllModel *model in self.userArray) {
        
        NSString *isSelect = @"NO";
        for (UserAllModel *selModel in self.selArray) {
            if ([model.RE_alarmNum isEqualToString:selModel.RE_alarmNum]) {
                isSelect = @"YES";
                [self.haveselectArray addObject:model];
            }
        }
        model.isSelect = isSelect;
        
        if ([model.RE_department isEqualToString:@"1"]) {
            [self.tempArray insertObject:model atIndex:0];
        }
       
    }
    [self.dataArray addObjectsFromArray:self.tempArray];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), kScreen_Height-64-142) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
   
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
        
        UnitListModel *model1 = self.dataArray[indexPath.row];
        
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *userArr = [NSMutableArray array];
        
        for (UnitListModel *model2 in self.allArray) {
            if ([model1.DE_number isEqualToString:model2.DE_sjnumber]) {
                [arr addObject:model2];
            }
        }
        for (UserAllModel *mode3 in self.userArray) {
            if ([mode3.RE_department isEqualToString:model1.DE_number]) {
                [userArr addObject:mode3];
            }
        }
        
        
        if (_addGroupDelegate && [_addGroupDelegate respondsToSelector:@selector(addGroupUTController:title:arr:allUser:allDepart:nextUser:)]) {
            [_addGroupDelegate addGroupUTController:self title:model1.DE_name arr:arr allUser:self.userArray allDepart:self.departArray nextUser:userArr];
        }
        
        
    }else if ([self.dataArray[indexPath.row] isKindOfClass:[UserAllModel class]]){
        
        UserAllModel *allModel = self.dataArray[indexPath.row];
        
        UserAllTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([allModel.isSelect isEqualToString:@"YES"]) {
            
            cell.isSelect = NO;
        
            allModel.isSelect = @"NO";
            
            for (int i = 0; i < self.haveselectArray.count; i++) {
                
                UserAllModel *model = self.haveselectArray[i];
                if ([model.RE_alarmNum isEqualToString:allModel.RE_alarmNum]) {
                    [self.haveselectArray removeObject:model];
                }
            }
            
        }else {
            
            cell.isSelect = YES;
            allModel.isSelect = @"YES";
            [self.haveselectArray addObject:self.dataArray[indexPath.row]];
        }
        [cell selectedCell];
        
        if (_addGroupDelegate && [_addGroupDelegate respondsToSelector:@selector(addGroupUTController:selArray:)]) {
            [_addGroupDelegate addGroupUTController:self selArray:self.haveselectArray];
        }
       
    }
    
}
- (void)commitUTArray:(NSNotification *)notification {

    
    NSMutableArray *selArray = [NSMutableArray array];
    NSInteger count = self.userArray.count;
    for (int i = 0; i < count; i++) {
        UserAllModel *userModel = self.userArray[i];
        
        if ([userModel.isSelect isEqualToString:@"YES"]) {
            [selArray addObject:userModel];
        }
    }
    if (_addGroupDelegate && [_addGroupDelegate respondsToSelector:@selector(addGroupUTController:selArray:)]) {
        [_addGroupDelegate addGroupUTController:self selArray:selArray];
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
#pragma clang diagnostic pop
@end
