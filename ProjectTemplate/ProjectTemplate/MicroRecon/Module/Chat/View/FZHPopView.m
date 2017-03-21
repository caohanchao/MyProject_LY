//
//  ChatGroupAtController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FZHPopView.h"
#import "GroupMemberModel.h"
#import "ChineseString.h"
#import "NSString+Property.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define AllMemberBtnH 55.5

@interface FZHPopView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *memberArray;
@property (nonatomic, strong)NSMutableArray *indexArray;
@end
@implementation FZHPopView

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}
- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
//    NSMutableArray *indexArray = [NSMutableArray array];
//    NSMutableArray *titleArray = [NSMutableArray array];
//    NSMutableArray *dataArray = [NSMutableArray array];
//    NSMutableArray *stringsToSort = [NSMutableArray array];
//    for (int i = 0; i<_dataSource.count; i++) {
//        GroupMemberModel *model = _dataSource[i];
//        if (model.ME_nickname != nil) {
//            model.ME_nickname.myId = model.ME_uid;
//            [stringsToSort addObject:model.ME_nickname];
//        }
//    }
//    
//    titleArray = [ChineseString IndexArray:stringsToSort];
//    [self.indexArray addObjectsFromArray:titleArray];
//    dataArray = [ChineseString LetterSortArray:stringsToSort];
//    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:titleArray.count];
//    for (int i = 0; i<dataArray.count; i++) {
//        NSArray *fArr = [dataArray objectAtIndex:i];
//        NSMutableArray *tmpFriendArr = [[NSMutableArray alloc] initWithCapacity:fArr.count];
//        for (int j = 0; j<fArr.count; j++) {
//            NSString *name = [fArr objectAtIndex:j];
//            for (int k = 0; k<_dataSource.count; k++) {
//                GroupMemberModel *userFriend = [_dataSource objectAtIndex:k];
//                if ([name.myId isEqualToString:userFriend.ME_uid]) {
//                    [tmpFriendArr addObject:userFriend];
//                }
//            }
//        }
//        [tmpArray addObject:tmpFriendArr];
//    }
//    self.memberArray = tmpArray;
//    [_tableView reloadData];
    
//    NSArray *friendList = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist];
//    NSMutableArray *stringsToSort = [[NSMutableArray alloc] init];
//    [self.friendListArray removeAllObjects];
//    for (int i = 0; i<friendList.count; i++) {
//        FriendsListModel *friend = [friendList objectAtIndex:i];
//        if (friend.name != nil) {
//            friend.name.myId = friend.alarm;
//            [stringsToSort addObject:friend.name];
//        }
//    }
//    self.titleArray = [ChineseString IndexArray:stringsToSort];
//    [self.indexArray addObjectsFromArray:self.titleArray];
//    self.dataArray = [ChineseString LetterSortArray:stringsToSort];
//    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:self.titleArray.count];
//    for (int i = 0; i<self.dataArray.count; i++) {
//        NSArray *fArr = [self.dataArray objectAtIndex:i];
//        NSMutableArray *tmpFriendArr = [[NSMutableArray alloc] initWithCapacity:fArr.count];
//        for (int j = 0; j<fArr.count; j++) {
//            NSString *name = [fArr objectAtIndex:j];
//            for (int k = 0; k<friendList.count; k++) {
//                FriendsListModel *userFriend = [friendList objectAtIndex:k];
//                if ([name.myId isEqualToString:userFriend.alarm]) {
//                    [tmpFriendArr addObject:userFriend];
//                }
//            }
//        }
//        [tmpArray addObject:tmpFriendArr];
//    }
//    self.friendListArray = tmpArray;
//    
//    [_tableView reloadData];
//}

    
}

//LetterSortArray
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        //初始化各种起始属性
        self.backgroundColor = [UIColor whiteColor];
        [self initAttribute];
        [self initTabelView];
        [self createAllMember];
    }
    return self;
}

- (void)initTabelView{
 
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, AllMemberBtnH, SCREEN_WIDTH, _contentShift) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = LineColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    [self.contentView addSubview:self.tableView];
}
#pragma mark -
#pragma mark 添加所有人
- (void)createAllMember {
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, screenWidth(), AllMemberBtnH);
    
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn addTarget:self action:@selector(atAll) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15+7.5, 30, 22.5)];
    imageView.image = [UIImage imageNamed:@"book_newfriend"];
    
    [addBtn addSubview:imageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(maxX(imageView)+10, 10, screenWidth() - 55, 55)];
    label.text = @"全体成员";
    label.font = [UIFont systemFontOfSize:15];
    [addBtn addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [addBtn addSubview:line];
}
- (void)atAll {

    if (_fzhPopViewDelegate && [_fzhPopViewDelegate respondsToSelector:@selector(atAllMember:)]) {
        [_fzhPopViewDelegate atAllMember:self];
    }
}
/**
 *  初始化起始属性
 */
- (void)initAttribute{
    
    self.buttonH = SCREEN_HEIGHT * (40.0/736.0);
    self.buttonMargin = 10;
    self.contentShift = SCREEN_HEIGHT-64*2-AllMemberBtnH;
    self.animationTime = 0.8;
    //self.backgroundColor = [UIColor colorWithWhite:0.838 alpha:0.700];
    
    [self initSubViews];
}
/**
 *  初始化子控件
 */
- (void)initSubViews{
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentShift);
    [self addSubview:self.contentView];
}
/**
 *  展示pop视图
 *
 *  @param array 需要显示button的title数组
 */
- (void)showThePopViewWithArray{
   
    CGRect rect = self.frame;
    rect.size.height = kScreenHeight - TopBarHeight;
    self.frame = rect;
    //1.执行动画
    [UIView animateWithDuration:self.animationTime animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -NavigationBarHeight);

    }];
    
}

- (void)dismissThePopView{
    
    CGRect rect = self.frame;
    rect.size.height = SCREEN_HEIGHT - TopBarHeight - SEARCHH;
    self.frame = rect;
    [UIView animateWithDuration:self.animationTime animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
    
}

#pragma mark - UITableViewDataSource
-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return self.memberArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
//    return [(NSMutableArray *)self.memberArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
        imageView.frame = CGRectMake(10, 10, 35, 35);
        imageView.tag = 1001;
        
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(maxX(imageView)+10, 10, 150, 35)];
        label.font = ZEBFont(15);
        label.textColor = [UIColor blackColor];
        label.tag = 1002;
        [cell.contentView addSubview:label];
    }
    GroupMemberModel *model = self.dataSource[indexPath.row];
//    GroupMemberModel *model =self.memberArray[indexPath.section][indexPath.row];
    
    UIImageView *imageView = [cell.contentView viewWithTag:1001];
    UILabel *label = [cell.contentView viewWithTag:1002];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:nil];
    label.text = model.ME_nickname;
    return cell;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    return self.indexArray;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupMemberModel *model = self.dataSource[indexPath.row];
    
    if (_fzhPopViewDelegate && [_fzhPopViewDelegate respondsToSelector:@selector(atOneMember:model:)]) {
        [_fzhPopViewDelegate atOneMember:self model:model];
    }
}
- (void)buttonClick:(UIButton *)button{
    
    if ([self.fzhPopViewDelegate respondsToSelector:@selector(getTheButtonTitleWithButton:)]) {
        [self.fzhPopViewDelegate getTheButtonTitleWithButton:button];
    }
}
- (void)reloadData {

    [self.tableView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_fzhPopViewDelegate && [_fzhPopViewDelegate respondsToSelector:@selector(fZHPopViewDidScroll:)]) {
        [_fzhPopViewDelegate fZHPopViewDidScroll:self];
    }
}
@end
