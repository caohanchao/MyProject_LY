//
//  SearchViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SearchViewController.h"
#import "FriendsListModel.h"
#import "TeamsListModel.h"
#import "FindUserBaseModel.h"
#import "FindUserModel.h"
#import "UserDesInfoController.h"
#import "XMNChatController.h"
#import "UIImageView+CornerRadius.h"
#import "ChatMapViewController.h"
#import "ZEBSearchBar.h"
#import "UINavigationBar+ChangeColor.h"

static CGFloat viewOffset = 64;

#define SEARCHH 43
#define LeftMargin 0

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {

    UITableView *_tableView;
    
}

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) ZEBSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *alarmArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *myFriendsArray;
@property (nonatomic,strong) NSMutableArray *myComradesArray;

@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:BackToRootController object:nil];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar zeb_setBackgroundColor:zGroupTableViewBackgroundColor];
    [self.navigationController.navigationBar zeb_HairlineImageViewUnderSetHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar zeb_reset];
    [self.navigationController.navigationBar zeb_HairlineImageViewUnderSetHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)back {
    self.view.alpha = 0;
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (NSMutableArray *)myFriendsArray {
    if (_myFriendsArray == nil) {
        _myFriendsArray = [NSMutableArray array];
    }
    return _myFriendsArray;
}
- (NSMutableArray *)myComradesArray {
    if (_myComradesArray == nil) {
        _myComradesArray = [NSMutableArray array];
    }
    return _myComradesArray;
}
- (NSMutableArray *)allDataArray {

    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)nameArray {

    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (NSMutableArray *)alarmArray {

    if (_alarmArray == nil) {
        _alarmArray = [NSMutableArray array];
    }
    
    return _alarmArray;
}
- (NSMutableArray *)tempArray {

    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
- (NSMutableArray *)titleArray {

    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (void)setStr:(NSString *)str {

    _str = str;
    [self initall];
    
}
- (void)initall {
    [self getAllData];
    [self setupSearchBar];
    [self createTableView];
}
- (void)getAllData {

    switch (self.type) {
        case 1:
            
            self.allDataArray = [[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist];
            [self getSoureFRArray];
            break;
        case 2:
        
            self.allDataArray = [[[DBManager sharedManager] GrouplistSQ] selectGrouplists];
            [self getSoureGRArray];
            break;
        case 3:
            
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark 查询好友列表数据
- (void)httpGetInfo:(NSString *)textFild {
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:FindUserUrl,textFild,token];
    
    
    ZEBLog(@"%@",urlString);
    NSString *encodedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self showloadingName:@"正在搜索"];
    [HYBNetworking getWithUrl:encodedUrlString refreshCache:YES success:^(id response) {
        
        FindUserBaseModel *baseModel = [FindUserBaseModel getInfoWithData:response];
        //[self.dataArray addObjectsFromArray:baseModel.results];
        [self getSoureComradesArray:(NSMutableArray *)baseModel.results];
        [self hideHud];
       // [_tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}
/**
 *  将战友和好友分开
 */
- (void)getSoureComradesArray:(NSMutableArray *)array {

    
    if (array.count == 0) {
        _resultLabel.hidden = NO;
        return;
    }else {
        [self.effectView removeFromSuperview];
    }
    
    [self.tempArray removeAllObjects];
    [self.myComradesArray removeAllObjects];
    [self.myFriendsArray removeAllObjects];
    [self.titleArray removeAllObjects];
    
    for (FindUserModel *findUserModel in array) {
        if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:findUserModel.RE_alarmNum]) {
            [self.myFriendsArray addObject:findUserModel];
        }else {
            [self.myComradesArray addObject:findUserModel];
        }
    }
    if (self.myFriendsArray.count != 0) {
        [self.tempArray addObject:self.myFriendsArray];
        [self.titleArray addObject:@"好友"];
    }
    if (self.myComradesArray.count != 0) {
        [self.tempArray addObject:self.myComradesArray];
        [self.titleArray addObject:@"战友"];
    }
    [_tableView reloadData];
}
/**
 *  得到群组名数组
 */
- (void)getSoureGRArray {
    for (TeamsListModel *model in self.allDataArray) {
        [self.nameArray addObject:model.gname];
    }
    
}
/**
 *  得到好友的姓名和警号数组
 */
- (void)getSoureFRArray {

    for (FriendsListModel *friendsModel in self.allDataArray) {
        [self.nameArray addObject:friendsModel.name];
        [self.alarmArray addObject:friendsModel.useralarm];
        
        //判断是否出现数组出现异常的情况.如果出现取最小数量,保证两个数组数量一样
        if (self.nameArray.count == self.alarmArray.count) {
            continue;
        }
        else
        {
            if (self.nameArray.count > self.alarmArray.count) {
                [self.alarmArray addObject:friendsModel.alarm];
            }
            else{
                
            }
            
        }
    
    }
    
    
}
#pragma mark -
#pragma mark 创建搜索按钮
- (void)setupSearchBar{
    
    UIImage *bgImage = [LZXHelper buttonImageFromColor:[UIColor groupTableViewBackgroundColor]];
    self.searchBar = [[ZEBSearchBar alloc]init];
    self.searchBar.frame = CGRectMake(0, viewOffset, SCREEN_WIDTH, SEARCHH);
    
    [self.searchBar setBackgroundImage:bgImage];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = _str;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    self.searchBar.tintColor = [UIColor colorWithRed:0.22 green:0.38 blue:0.94 alpha:1.00];
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = self.searchBar;
    
    _resultLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(15) textColor:zGrayColor text:@"没有更多的搜索结果"];
    _resultLabel.frame = CGRectMake(0, 0, 200, 30);
    _resultLabel.center = CGPointMake(kScreen_Width/2, 79);
    _resultLabel.hidden = YES;
    [self.effectView addSubview:_resultLabel];
    
}
- (void)setupCancelButton{
    
    UIButton *cancelButton = [self.searchBar valueForKey:@"_cancelButton"];
    cancelButton.titleLabel.font = ZEBFont(16);
    [cancelButton setTitleColor:zGrayColor];
    // [cancelButton addTarget:self action:@selector(cancelButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)searchClickEvent {

    [self.view addSubview:self.effectView];
    _resultLabel.hidden = YES;
    self.searchBar.showsCancelButton = YES;
    [self setupCancelButton];
}
- (void)cancelButtonClickEvent{
    
    _resultLabel.hidden = YES;
    [self.effectView removeFromSuperview];
    self.searchBar.showsCancelButton = NO;
    [self cancel];
}

#pragma mark -
#pragma mark searchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self searchClickEvent];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelButtonClickEvent];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    switch (self.type) {
        case 1:
            [self textFileFRSearch:searchBar.text];
            break;
        case 2:
            [self textFileGRSearch:searchBar.text];
            break;
        case 3:
            [self httpGetInfo:searchBar.text];
            break;
        default:
            break;
    }
    
    [searchBar endEditing:YES];
}
#pragma mark -
#pragma mark 退出
- (void)cancel {

    [self.searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == 3) {
        return self.tempArray.count;
    }
    return 1;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 3) {
        return [(NSMutableArray *)self.tempArray[section] count];
    }
    return self.dataArray.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        UIImageView *imageview = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
        imageview.frame = CGRectMake(12, 6, 38, 38);
        imageview.tag = 10000;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageview];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(imageview)+12, 0, 200, 50)];
        titleLabel.font = ZEBFont(18);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 10001;
        [cell.contentView addSubview:titleLabel];
    }
    NSString *url;
    NSString *name;
    UIImageView *imageView = [cell.contentView viewWithTag:10000];
    UILabel *titleLabel = [cell.contentView viewWithTag:10001];
    if (self.type == 1) {
        
        FriendsListModel *model = self.dataArray[indexPath.row];
        url = model.headpic;
        name = model.name;
        
        //[imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [imageView imageGetCacheForAlarm:model.alarm forUrl:url];
        titleLabel.text = name;
        
        
    }else if (self.type == 2) {
        TeamsListModel *model = self.dataArray[indexPath.row];
        
        NSString *imageStr;
        switch ([model.type integerValue]) {
            case 0:
                // imageStr = @"group_zhencha";
                imageStr = @"G_zhencha";
                break;
            case 1:
                // imageStr = @"group_qunliao";
                imageStr = @"G_zudui";
                break;
            case 2:
                // imageStr = @"group_anbao";
                imageStr = @"G_pancha";
                break;
            case 3:
                //imageStr = @"group_xunkong";
                imageStr = @"G_xunkong";
                break;
            case 4:
                //  imageStr = @"group_sos";
                imageStr = @"G_zengyuan";
                break;
            case 5:
                imageStr = @"G_duikang";
                break;
                
            default:
                break;
        }
        
        imageView.image = [UIImage imageNamed:imageStr];
        
        titleLabel.text = model.gname;
        
    }else if (self.type == 3) {
    
        FindUserModel *model = self.tempArray[indexPath.section][indexPath.row];
        //[imageView sd_setImageWithURL:[NSURL URLWithString:model.RE_headpic] placeholderImage:nil];
        [imageView imageGetCacheForAlarm:model.RE_alarmNum forUrl:model.RE_headpic];
        titleLabel.text = model.RE_nickname;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (self.type == 3) {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    titleLabel.font = ZEBFont(15);
    
     titleLabel.text = self.titleArray[section];
    
    [headerView addSubview:titleLabel];
    return headerView;
        
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.type == 1) {
        
        FriendsListModel *model = self.dataArray[indexPath.row];
        
        UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
        userDes.alarm = model.alarm;
        userDes.cType = Search;
        if (self.cType == 1) {
            userDes.cgType = Chat;
        }else if (self.cType == 2) {
            userDes.cgType = Group;
        }
        [self.navigationController pushViewController:userDes animated:YES];
        
    }else if (self.type == 2) {
    
        TeamsListModel *model = self.dataArray[indexPath.row];
        [self.navigationController popToRootViewControllerAnimated:NO];
        if (self.cType == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BackToRootController object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"skipChatNotification" object:model];
        }else if (self.cType == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BackToRootController object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"skipGroupNotification" object:@[model,@(self.cType)]];
        }
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user setObject:model.gid forKey:@"chatId"];
//        [user setObject:@"G" forKey:@"chatType"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        if ([model.type isEqualToString:@"0"]) {
//            ChatMapViewController *chatMap = [[ChatMapViewController alloc] initWithChatType:XMNMessageChatGroup chatname:model.gname type:3];
//            chatMap.chatView = [[ChatView alloc] init];
//            [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.gid];
//            [self.navigationController pushViewController:chatMap animated:YES];
//        }else {
//            XMNChatController *chatC = [[XMNChatController alloc] initWithChatType:XMNMessageChatGroup];
//            chatC.chatterName = model.gname;
//            chatC.cType = Search;
//            [[[DBManager sharedManager] UserlistDAO] clearNewMsgCout:model.gid];
//            [self.navigationController pushViewController:chatC animated:YES];
//        }
        
    }else if (self.type == 3) {
    
        FindUserModel *model = self.tempArray[indexPath.section][indexPath.row];
        UserDesInfoController *userDes = [[UserDesInfoController alloc] init];
        userDes.RE_alarmNum = model.RE_alarmNum;
        userDes.cType = Search;
        if (self.cType == 1) {
            userDes.cgType = Chat;
        }else if (self.cType == 2) {
            userDes.cgType = Group;
        }
        [self.navigationController pushViewController:userDes animated:YES];
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (self.type == 1) {
        return 0.1;
    }else if (self.type == 2) {
        return 0.1;
    }else if (self.type == 3) {
        return 30;
    }
    return 0.1;
}

#pragma mark -
#pragma mark 组队搜索
- (void)textFileGRSearch:(NSString *)TextField {
    if (TextField == nil || [TextField isEqualToString:@""]) {
        
        
        [_tableView reloadData];
        
    }
    //    // 完成具体的搜索功能
    //    // 1.清空搜索结果数组
    [self.dataArray removeAllObjects];
    
    int k = 0;
    
    //2。通过循环数据，找出与搜索关键字匹配的内容，把匹配的内容添加到数组中
    
    for (NSString *str in self.nameArray) {
        
        NSString *ste = [NSString stringWithFormat:@"%@",str];
        
        NSRange range = [ste rangeOfString:TextField];
        
        
        if (range.length) {
            
            [self.dataArray addObject:self.allDataArray[k]];
        
        }
        
        k++;
        
    }
    if (self.dataArray.count == 0) {
        _resultLabel.hidden = NO;
        return;
    }else {
        [self.effectView removeFromSuperview];
    }
    
    [_tableView reloadData];
    
}
#pragma mark -
#pragma mark 好友搜索
-(void)textFileFRSearch:(NSString *)TextField{
    
    
    if (TextField == nil || [TextField isEqualToString:@""]) {
        
        
        [_tableView reloadData];
        
    }
    //    // 完成具体的搜索功能
    //    // 1.清空搜索结果数组
    [self.dataArray removeAllObjects];
    
    int k = 0;
    
    //2。通过循环数据，找出与搜索关键字匹配的内容，把匹配的内容添加到数组中
    
    
    
    for (NSString *str in self.nameArray) {
        
        NSString *ste = [NSString stringWithFormat:@"%@",str];
        
        NSRange range = [ste rangeOfString:TextField];
        NSRange rangAlarm = [self.alarmArray[k] rangeOfString:TextField];
        
        if (range.length) {
            
            [self.dataArray addObject:self.allDataArray[k]];
        }else {
        
            if (rangAlarm.length) {
                [self.dataArray addObject:self.allDataArray[k]];
            }
        }
        
        k++;
        
    }
    if (self.dataArray.count == 0) {
        _resultLabel.hidden = NO;
        return;
    }else {
        [self.effectView removeFromSuperview];
    }
    
    [_tableView reloadData];
    
    
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        /**  毛玻璃特效类型
         *   UIBlurEffectStyleExtraLight,
         *   UIBlurEffectStyleLight,
         *   UIBlurEffectStyleDark
         */
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //开启事件响应
        _effectView.userInteractionEnabled = YES;
        //添加到要有毛玻璃特效的控件中
        _effectView.frame = CGRectMake(0, TopBarHeight-5, kScreenWidth, kScreenHeight-TopBarHeight+5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClickEvent)];
        [_effectView addGestureRecognizer:tap];
        
    }
    return _effectView;
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
