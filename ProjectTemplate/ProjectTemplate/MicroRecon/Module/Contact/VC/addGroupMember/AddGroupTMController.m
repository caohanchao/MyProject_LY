//
//  AddGroupTMController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AddGroupTMController.h"
#import "TeamTableViewCell.h"
#import "GroupMemberBaseModel.h"
#import "GroupMemberModel.h"
#import "TeamsModel.h"
#import "TeamsListModel.h"


//去掉警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"

@interface AddGroupTMController ()<UITableViewDelegate, UITableViewDataSource> {
    
    
    TeamTableViewCell *_lastCell;
    NSIndexPath *_lastIndexPath;
    
}


@property (nonatomic, strong)  NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *haveselectArray;
@property (nonatomic, copy) NSString *row;
@end

@implementation AddGroupTMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.row = @"";
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delRefreshUI:) name:DeleteTMNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)delRefreshUI:(NSNotification *)notfication {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)selectArray {

    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
    
}
- (NSMutableArray *)haveselectArray {
    
    if (_haveselectArray == nil) {
        _haveselectArray = [NSMutableArray array];
    }
    return _haveselectArray;
}
- (void)initall {
    
    //[self httpGetInfo];
    [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] GrouplistSQ] selectGrouplists]];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.dataArray];
    
    for (TeamsListModel *Model in temp) {
        if ([Model.gid isEqualToString:self.groupSettingselGidstr]) {
            [self.dataArray removeObject:Model];
        }
    }
    [self soureSelectCell];
    [self createTableView];
    
}
//#pragma mark -
//#pragma mark 请求群组列表数据
//- (void)httpGetInfo {
//    
//    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSString *urlString = [NSString stringWithFormat:TeamList_URL,alarm,token];
//    
//    
//    ZEBLog(@"%@",urlString);
//    
//    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
//        
//        
//        TeamsModel *model = [TeamsModel getInfoWithData:(NSDictionary *)response];
//        
//        
//        
//        [self.dataArray addObjectsFromArray:model.results];
//        
//        [self soureSelectCell];
//        
//    } fail:^(NSError *error) {
//        
//    }];
//    
//}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-64-142) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor= LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
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
//判断哪些cell被选中
- (void)soureSelectCell {
    
    NSInteger count1 = self.dataArray.count;
    [self.selectArray removeAllObjects];
    for (int i = 0; i <count1; i++) {
       
        TeamsListModel *allModel = self.dataArray[i];
        
        NSString *isSelect = @"NO";
            
            if ([allModel.gid isEqualToString:self.selGidstr]) {
                isSelect = @"YES";
                self.row = [NSString stringWithFormat:@"%d",i];
            }
        
        [self.selectArray addObject:isSelect];
    }
    
    [_tableView reloadData];
}
#pragma mark -
#pragma mark 请求群好友列表数据
- (void)httpGetGroupMemberInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:FriendsLise_URL,alarm,@"3",self.selGidstr,token];
    
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        
        GroupMemberBaseModel *baseModel = [GroupMemberBaseModel getInfoWithData:response];
        
        [self.haveselectArray removeAllObjects];
        if (self.groupSettingSelArray.count != 0) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.groupSettingSelArray];
            for (GroupMemberModel *model1 in baseModel.results) {
                for (GroupMemberModel *model2 in self.groupSettingSelArray) {
                    if ([model1.ME_uid isEqualToString:model2.ME_uid]) {
                        [tempArray removeObject:model2];
                    }
                }
            }
            [self.haveselectArray addObjectsFromArray:tempArray];
            
        }
        [self.haveselectArray addObjectsFromArray:baseModel.results];
        [self commitArray];
        
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)commitArray {
    if (_addGroupTMDelegate && [_addGroupTMDelegate respondsToSelector:@selector(addGroupTMController:selArray:selGidstr:)]) {
        [_addGroupTMDelegate addGroupTMController:self selArray:self.haveselectArray selGidstr:self.selGidstr];
    }
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TeamTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.isSelect = [self.selectArray[indexPath.row] boolValue];
    cell.isContact = NO;
    cell.teamListModel = self.dataArray[indexPath.row];
    
    return cell;
}
#pragma mark -
#pragma mark 选择cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TeamsListModel *model = self.dataArray[indexPath.row];
    self.selGidstr = model.gid;

    if (![self.row isEqualToString:@""]) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[self.row integerValue] inSection:0];
        _lastCell = [tableView cellForRowAtIndexPath:index];
        self.row = @"";
    }
    if (_lastCell != nil) {
        if (_lastCell.isSelect) {
            
            [self.selectArray replaceObjectAtIndex:_lastIndexPath.row withObject:@"NO"];
            
                for (TeamsListModel *listModel in self.selGidArray) {
                    if ([listModel.gid isEqualToString:model.gid]) {
                        [self.selGidArray removeObject:listModel];
                    }
                }
            
            _lastCell.isSelect = NO;
            [_lastCell selectedCell];
        }else {
        
        }
        
    }
    
    TeamTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _lastCell = cell;
    _lastIndexPath = indexPath;
    if (cell.isSelect) {
        
        [self.selectArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        if (self.selGidArray.count != 0) {
            for (TeamsListModel *listModel in self.selGidArray) {
                if ([listModel.gid isEqualToString:model.gid]) {
                    [self.selGidArray removeObject:listModel];
                }
            }
        }
        
        cell.isSelect = NO;
    }else {
        
        [self.selectArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        [self.selGidArray addObject:model];
        cell.isSelect = YES;
    }
    [cell selectedCell];
    [self httpGetGroupMemberInfo];
}

#pragma mark -
#pragma mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
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
