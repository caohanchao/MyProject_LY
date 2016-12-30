//
//  AddGroupsFRController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AddGroupsFRController.h"
#import "ContactTableViewCell.h"
#import "ChineseString.h"
#import "FriendsListModel.h"
#import "NSString+Property.h"

//去掉警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"

@interface AddGroupsFRController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, copy) NSString *isSelect;
@property (nonatomic, strong) NSMutableArray *haveselectArray;
@end

@implementation AddGroupsFRController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSelect = @"NO";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delRefreshUI:) name:DeleteFRNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAllModel:) name:AddAllFRNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAddRefreshUI:) name:SearchAddFRNotification object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addAllModel:(NSNotification *)notfication {

    
    [self.haveselectArray removeAllObjects];
    [self.haveselectArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist]];
    
    if (_addGroupsFRDelegate && [_addGroupsFRDelegate respondsToSelector:@selector(addGroupsFRController:selArray:)]) {
        [_addGroupsFRDelegate addGroupsFRController:self selArray:self.haveselectArray];
    }
    NSMutableArray *array =[NSMutableArray arrayWithArray:self.haveselectArray];
    self.selArray = array;
    [self.haveselectArray removeAllObjects];
    [self soureSelectCell];
    
}
- (void)delRefreshUI:(NSNotification *)notfication {

    NSMutableArray *array =[NSMutableArray arrayWithArray:self.haveselectArray];
    self.selArray = array;
    [self.haveselectArray removeAllObjects];
    [self soureSelectCell];
}
- (void)searchAddRefreshUI:(NSNotification *)notfication {

    
    self.selArray = notfication.object;
    [self.haveselectArray removeAllObjects];
    [self soureSelectCell];
}
#pragma mark -
#pragma mark 创建加好友按钮
- (void)createAddFr {
    
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
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-64-44-142) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor= LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    [_tableView visibleCells];
}
- (void)sortFriendList {
    
    NSMutableArray *tempFriendList = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist];
    NSMutableArray *friendList = [NSMutableArray array];
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:tempFriendList];
    for (FriendsListModel *friend in tempFriendList) {
        for (GroupMemberModel *model1 in self.groupSettingSelArray) {
            if ([friend.alarm isEqualToString:model1.ME_uid]) {
                [temp removeObject:friend];
            }
        }
    }
    [friendList addObjectsFromArray:temp];
    NSMutableArray *stringsToSort = [[NSMutableArray alloc] init];
    
    [self.friendListArray removeAllObjects];
    for (int i = 0; i<friendList.count; i++) {
        FriendsListModel *friend = [friendList objectAtIndex:i];
        if (friend.name != nil) {
            friend.name.myId = friend.alarm;
         [stringsToSort addObject:friend.name];
        }
    }
    self.titleArray = [ChineseString IndexArray:stringsToSort];
    [self.indexArray addObjectsFromArray:self.titleArray];
    
    self.dataArray = [ChineseString LetterSortArray:stringsToSort];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:self.titleArray.count];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSArray *fArr = [self.dataArray objectAtIndex:i];
        NSMutableArray *tmpFriendArr = [[NSMutableArray alloc] initWithCapacity:fArr.count];
        for (int j = 0; j<fArr.count; j++) {
            NSString *name = [fArr objectAtIndex:j];
            for (int k = 0; k<friendList.count; k++) {
                FriendsListModel *userFriend = [friendList objectAtIndex:k];
                if ([name.myId isEqualToString:userFriend.alarm]) {
                    [tmpFriendArr addObject:userFriend];
                }
            }
        }
        [tmpArray addObject:tmpFriendArr];
    }
    self.friendListArray = tmpArray;
    
    [self soureSelectCell];
}
//判断哪些cell被选中
- (void)soureSelectCell {

    NSInteger count1 = self.friendListArray.count;
    NSInteger count2 = self.selArray.count;
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < count1; i++) {
        
        NSMutableArray *array2 = [NSMutableArray array];
        NSMutableArray *tempArray = self.friendListArray[i];
        
        NSInteger count3 = tempArray.count;
        for (int k = 0; k < count3; k++) {
          NSString *isSelect = @"NO";
           FriendsListModel *frAllModel = tempArray[k];
            
            for (int j = 0; j < count2; j++) {
                FriendsListModel *frSelModel = self.selArray[j];
                
                if ([frAllModel.alarm isEqualToString:frSelModel.alarm]) {
                    isSelect = @"YES";
                    [self.haveselectArray addObject:frSelModel];
                }
            }
          [array2 addObject:isSelect];
        }
        [array1 addObject:array2];
    }
    self.selectArray = array1;
    
    [_tableView reloadData];
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.isSelect = [[self.selectArray[indexPath.section] objectAtIndex:indexPath.row] boolValue];
    
    cell.isContact = NO;
    cell.friendsLiModel = [self.friendListArray[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark -
#pragma mark 选择cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if ([self.isSelect isEqualToString:@"YES"]) {
//        self.isSelect = @"NO";
//    }else {
//        self.isSelect = @"YES";
 //   }
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.isSelect,isMemberSelect, nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:SelectCellFRNotification object:dic];
    
    ContactTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.isSelect) {
        
        cell.isSelect = NO;
        [self.selectArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        FriendsListModel *model = [self.friendListArray[indexPath.section] objectAtIndex:indexPath.row];
        for (FriendsListModel *tempModel in self.haveselectArray) {
            if ([model.alarm isEqualToString:tempModel.alarm]) {
                [self.haveselectArray removeObject:tempModel];
                break;
            }
        }
    }else {
        [self.selectArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        cell.isSelect = YES;
        [self.haveselectArray addObject:[self.friendListArray[indexPath.section] objectAtIndex:indexPath.row]];
        
    }
    [cell selectedCell];
    
    if (_addGroupsFRDelegate && [_addGroupsFRDelegate respondsToSelector:@selector(addGroupsFRController:selArray:)]) {
        [_addGroupsFRDelegate addGroupsFRController:self selArray:self.haveselectArray];
    }
}
#pragma mark -
#pragma mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
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
#pragma clang diagnostic pop
@end
