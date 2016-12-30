                                                                   //
//  FriendsViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendsViewController.h"
#import "ContactTableViewCell.h"
#import "FriendsModel.h"
#import "ChineseString.h"
#import "FriendsListModel.h"
#import "DBManager.h"
#import "UIView+Layout.h"
#import "NSString+Property.h"

#define CellHeight 56
#define LeftMargin 12
#define TopMargin 9



@interface FriendsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UIButton *addButton;
@property(nonatomic,strong) UILabel *addFriendLab;

@end


@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewFriendNews) name:AddFriendNews object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeTag) name:RemoveTag object:nil];
    [self initall];
    
}

-(void)addNewFriendNews{

    self.addFriendLab.hidden=NO;
    
}

-(void)removeTag{

    self.addFriendLab.hidden=YES;
}

- (void)initall {
    [self initNottifation];
    [self createAddFr];
    [self createTableView];
    [self sortFriendList];
}
- (void)initNottifation {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:RefreshFriendsNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)friendListArray {

    if (_friendListArray == nil) {
        _friendListArray = [NSMutableArray array];
        
    }
    return _friendListArray;
}
- (NSMutableArray *)indexArray {
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
//当有新的改变刷新ui
- (void)refreshData:(NSNotification *)notification {

    [self.titleArray removeAllObjects];
    [self.indexArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self sortFriendList];
}
#pragma mark zdy

- (void)sortFriendList {
    NSArray *friendList = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist];
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
    
    [_tableView reloadData];
}

#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CellHeight, screenWidth(), screenHeight()-64-44-142) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.friendListArray.count;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSMutableArray *)[self.friendListArray objectAtIndex:section] count];
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.isContact = YES;
    cell.friendsLiModel = [self.friendListArray[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}
//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return self.indexArray;
    
}
//设置_tableView的章、节
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSArray *arr =[self.friendListArray[section] mutableCopy];
    
    label.text = [NSString stringWithFormat:@"   %@ (%ld人)",self.titleArray[section],arr.count];
    label.font = ZEBFont(14);
    label.textColor = [UIColor grayColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark -
#pragma mark 选择cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(friendsViewControllerPush:frModel:)]) {
        [_delegate friendsViewControllerPush:self frModel:[self.friendListArray[indexPath.section] objectAtIndex:indexPath.row]];
    }
    
}
#pragma mark -
#pragma mark 创建加好友按钮
- (void)createAddFr {

    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(0, 0, screenWidth(), CellHeight);
    self.addButton.backgroundColor = [UIColor whiteColor];
    [self.addButton addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin+5, TopMargin, 30, 22.5)];
    imageView.image = [UIImage imageNamed:@"book_newfriend"];
    
    imageView.centerY = self.addButton.centerY;
    [self.addButton addSubview:imageView];
 
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5+maxX(imageView)+12, minY(imageView), screenWidth() - 40, 40)];
    label.text = @"新的好友";
    label.font = ContactFont;
    label.centerY = self.addButton.centerY;
    [self.addButton addSubview:label];
    
    UILabel *addFriendLab=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-45, (CellHeight-8)/2, 8, 8)];
    addFriendLab.backgroundColor=[UIColor redColor];
    addFriendLab.layer.cornerRadius=addFriendLab.width/2;
    addFriendLab.layer.masksToBounds=YES;
    addFriendLab.hidden=YES;
    self.addFriendLab=addFriendLab;
    
    [self.addButton addSubview:addFriendLab];
    
    
}

#pragma mark -
#pragma mark 添加新的好友
- (void)addBtn:(UIButton *)addBtn {

    if (_delegate && [_delegate respondsToSelector:@selector(friendsViewControllerPushToNewFr:)]) {
        [_delegate friendsViewControllerPushToNewFr:self];
    }
    
}
#pragma mark -
#pragma mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSInteger currentPostion = scrollView.mj_offsetY;
    
    if (currentPostion > 20) {
        
        self.addButton.frame = CGRectMake(0, -64, screenWidth(), CellHeight);
//        _tableView.frame = CGRectMake(0, CellHeight, screenWidth(), screenHeight()-64-55-44);
//        [[NSNotificationCenter defaultCenter] postNotificationName:HideTopViewNotification object:nil];
        _tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-64-49);
        [[NSNotificationCenter defaultCenter] postNotificationName:HideTopViewNotification object:nil];
    }
    
    if (currentPostion < 0) {
        
        self.addButton.frame = CGRectMake(0, 0, screenWidth(), CellHeight);
        _tableView.frame = CGRectMake(0, CellHeight, screenWidth(), screenHeight()-64-44-142);
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTopViewHideNotification object:nil];
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
