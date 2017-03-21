//
//  AddGroupMemberController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AddGroupMemberController.h"
#import "AddGroupTMController.h"
#import "AddGroupsFRController.h"
#import "AddGroupUTController.h"
#import "AddGroupUTNextController.h"
#import "FriendsListModel.h"
#import "GroupMemberModel.h"
#import "UserAllModel.h"
#import "AddMemberSearchResultController.h"
#import "UIButton+EnlargeEdge.h"


#define LeftMargin 8
#define TopMargin 8
#define AddTextLeftMargin 5
#define PlTextField @"搜索"

@interface AddGroupMemberController ()<AddGroupUTControllerDelegate,AddGroupTMControllerDelegate,AddGroupsFRControllerDelegate,UITextFieldDelegate,AddMemberSearchResultControllerDelegate>{
    
    UIView *_bottomView;
    UIView *_topView;
    UIScrollView *_scrollerView;
    UITextField *_addTextField;
    UIView *_textFieldBgView;
    AddGroupsFRController *_friendsViewController;
    AddGroupTMController *_teamViewController;
    AddGroupUTController *_unitViewController;
    AddMemberSearchResultController *_searchResultController;
    UIButton *_commitBtn;
    UIView *_selAllView;
    
   
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *alarmArray;
@property (nonatomic, strong) NSMutableArray *allUTDataArray;
@property (nonatomic, strong) NSMutableArray *nameUTArray;
@property (nonatomic, strong) NSMutableArray *alarmUTArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) NSInteger textCount;
@property (nonatomic, assign) UITYPE type;

@end

@implementation AddGroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与人员";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initall];
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)allDataArray {

    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
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
- (NSMutableArray *)allUTDataArray {
    
    if (_allUTDataArray == nil) {
        _allUTDataArray = [NSMutableArray array];
    }
    return _allUTDataArray;
}
- (NSMutableArray *)nameUTArray {
    
    if (_nameUTArray == nil) {
        _nameUTArray = [NSMutableArray array];
    }
    return _nameUTArray;
}
- (NSMutableArray *)alarmUTArray {
    if (_alarmUTArray == nil) {
        _alarmUTArray = [NSMutableArray array];
    }
    return _alarmUTArray;
}
- (NSMutableArray *)resultArray {

    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (void)initall {

   [self createRightButton];
    [self createAddBtn];
    [self createFRbtn];
    
    [self initController];
    [self getSoureFRArray];
    [self getSoureUTArray];
    [self createSelectAll];
   
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
 
    [[NSNotificationCenter defaultCenter] postNotificationName:CommitUTSelArrayNotification object:nil];
    
    
    [self updataBtnTitle];
   
    
     [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
        
   
    
    
}
- (NSMutableArray *)TempTMArray {
    if (_TempTMArray == nil) {
        _TempTMArray = [NSMutableArray array];
    }
    return _TempTMArray;
}
- (NSMutableArray *)selectTempFRArray {

    if (_selectTempFRArray == nil) {
        _selectTempFRArray = [NSMutableArray array];
    }
    return _selectTempFRArray;
}
- (NSMutableArray *)selectTempTMArray {
    
    if (_selectTempTMArray == nil) {
        _selectTempTMArray = [NSMutableArray array];
    }
    return _selectTempTMArray;
}
- (NSMutableArray *)selectTempUTArray {
    
    if (_selectTempUTArray == nil) {
        _selectTempUTArray = [NSMutableArray array];
    }
    return _selectTempUTArray;
}
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)createRightButton {

    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame = CGRectMake(0, 0,75, 40);
    
    _commitBtn.titleLabel.font = ZEBFont(16);
    [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    if (_fromeWhere == FromeGroupDes) {
        _commitBtn.userInteractionEnabled = NO;
        [_commitBtn setTitleColor:[UIColor lightTextColor]];
    }
    [_commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commit:)];
//    self.navigationItem.rightBarButtonItem = rightBar
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_commitBtn];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:10];
}
#pragma mark -
#pragma mark 更新_commitBtn title
- (void)updataBtnTitle {
    NSInteger count = self.selectTempFRArray.count + self.selectTempTMArray.count + self.selectTempUTArray.count;
    
    if (_fromeWhere == FromeGroupDes) {
        if (count == self.gMCount) {
            _commitBtn.userInteractionEnabled = NO;
            [_commitBtn setTitleColor:[UIColor lightTextColor]];
            
            [_commitBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",count] forState:UIControlStateNormal];
        }else {
            _commitBtn.userInteractionEnabled = YES;
            [_commitBtn setTitleColor:[UIColor whiteColor]];
            
            [_commitBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",count] forState:UIControlStateNormal];
        }
    }else {
        if (count == 0) {
            [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        }else {
            [_commitBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",count] forState:UIControlStateNormal];
        }
    }
    [self setScrollviewFrame:count];
}
#pragma mark -
#pragma mark 更新scrollerview 的frame
- (void)setScrollviewFrame:(NSInteger)count {

    CGRect rect1 = _scrollerView.frame;
    CGRect rect2 = _addTextField.frame;
    if (count*height(_scrollerView.frame) > kScreen_Width-100) {
        
        rect1.size.width = kScreen_Width-100;
        
        
        rect2.origin.x = kScreen_Width-100+5;
        rect2.size.width = 100;
        
    }else {
    
        
        rect1.size.width = count*height(_scrollerView.frame);
        
        rect2.size.width = kScreen_Width - count*height(_scrollerView.frame);
        rect2.origin.x = count*height(_scrollerView.frame)+5;
    }
    [_scrollerView setFrame:rect1];
    [_addTextField setFrame:rect2];
    
}
#pragma mark -
#pragma mark 提交信息
- (void)commit:(UIButton *)btn {

    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(addGroupMemberController:selectFRArray:selectTMArray:selectUTArray:selectTempFRArray:selectTempTMArray:selectTempUTArray:selGid:)]) {
        [_delegate addGroupMemberController:self selectFRArray:self.selectFRArray selectTMArray:self.selectTMArray selectUTArray:self.selectUTArray selectTempFRArray:self.selectTempFRArray selectTempTMArray:self.selectTempTMArray selectTempUTArray:self.selectTempUTArray selGid:self.selGid];
    }
    
}
- (void)createSelectAll {
    
    _selAllView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44, kScreen_Width, 44)];
    _selAllView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_selAllView];
    
    UIButton *selAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selAllBtn.frame = CGRectMake(20, 10, 50, 24);
    [selAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selAllBtn.titleLabel.font = ZEBFont(15);
    [selAllBtn addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    [_selAllView addSubview:selAllBtn];
    
}

#pragma mark -
#pragma mark 全选
- (void)selectAll {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddAllFRNotification object:nil];
    
}

- (void)initController {
    
    _friendsViewController = [[AddGroupsFRController alloc] init];
    _friendsViewController.selArray = self.selectFRArray;
    _friendsViewController.groupSettingSelArray = self.TempTMArray;
    _friendsViewController.addGroupsFRDelegate = self;
    [_bottomView addSubview:_friendsViewController.view];
    
    _teamViewController = [[AddGroupTMController alloc] init];
    _teamViewController.addGroupTMDelegate = self;
    _teamViewController.selGidstr = self.selGid;
    _teamViewController.groupSettingSelArray = self.TempTMArray;
    _teamViewController.selArray = self.selectTMArray;
    _teamViewController.groupSettingselGidstr = self.selGid;
    
    _unitViewController = [[AddGroupUTController alloc] init];
    _unitViewController.selArray = self.selectUTArray;
    _unitViewController.addGroupDelegate = self;
    _unitViewController.groupSettingSelArray = self.TempTMArray;
    
    _searchResultController =[[AddMemberSearchResultController alloc] init];
    _searchResultController.delegate = self;
    _searchResultController.dataArray = self.resultArray;
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark -
#pragma mark 创建添加按钮
- (void)createAddBtn {
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), TopMargin*4+30+80)];
    _topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_topView];
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY(_topView), screenWidth(), screenHeight()-(maxY(_topView))-44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];

    
    
    _textFieldBgView = [[UIView alloc] initWithFrame:CGRectMake(0, AddTextLeftMargin, kScreen_Width, 50)];
    _textFieldBgView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_textFieldBgView];
    
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, AddTextLeftMargin, 0, 50)];
    
    [_topView addSubview:_scrollerView];
    
    
    _addTextField = [[UITextField alloc] init];
    _addTextField.frame = CGRectMake(AddTextLeftMargin, AddTextLeftMargin, kScreen_Width-2*AddTextLeftMargin, 50);
    _addTextField.placeholder = PlTextField;
    _addTextField.delegate = self;
    _addTextField.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_addTextField];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.type == TEAM) {
        
        return NO;
    }
    [self.resultArray removeAllObjects];
    [_searchResultController reloadTableView];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    ZEBLog(@"全部文字textField.text--%@,  刚加的的文字--%@, 他的位置--%@", textField.text,  string,NSStringFromRange(range) );
    
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    if ([NSString containEmoji:string])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }

    if (self.type == FRIEND) {
        [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        
    }else if (self.type == TEAM) {
        
        return NO;
    }else if (self.type == UNIT) {
        [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }

    
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField

{
    
    ZEBLog(@"textfield text %@",textField.text);
    if (self.type == FRIEND) {
        
        [self textFileFRSearch:textField.text];
        
    }else if (self.type == TEAM) {
        
      
    }else if (self.type == UNIT) {
        
        [self textFileUTSearch:textField.text];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    _selAllView.hidden = YES;
    if (self.type == FRIEND) {
        
        [_friendsViewController.view removeFromSuperview];
        [_bottomView addSubview:_searchResultController.view];
        
    }else if (self.type == TEAM) {
        
    }else if (self.type == UNIT) {
        
        [_unitViewController.view removeFromSuperview];
        [_bottomView addSubview:_searchResultController.view];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if ([textField.text isEqualToString:@""]) {
        _selAllView.hidden = NO;
        [self.view endEditing:YES];
        if (self.type == FRIEND) {
            
            [_searchResultController.view removeFromSuperview];
            [_bottomView addSubview:_friendsViewController.view];
            
            
        }else if (self.type == TEAM) {
            
        }else if (self.type == UNIT) {
            
            [_searchResultController.view removeFromSuperview];
            [_bottomView addSubview:_unitViewController.view];
            
        }
 
    }

}
/*
 #import "FriendsListModel.h"
 #import "GroupMemberModel.h"
 #import "UserAllModel.h"
 */
- (void)addImage:(NSArray *)FRImageArray TMImageArray:(NSArray *)TMImageArray UTImageArray:(NSArray *)UTImageArray{
    
    for (UIView *view in [_scrollerView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger count1 = FRImageArray.count;
    NSInteger count2 = TMImageArray.count;
    NSInteger count3 = UTImageArray.count;
    for (int i = 0; i < count1; i++) {
        FriendsListModel *model = FRImageArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
        imageView.frame = CGRectMake(0, 0, height(_scrollerView.frame), height(_scrollerView.frame));
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:nil];
        
        imageView.frame = CGRectMake(i*(height(_scrollerView.frame)), 0, 35, 35);
        imageView.tag = 5000+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteFR:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(minX(imageView), maxY(imageView), width(imageView.frame), 15);
        
        nameLabel.text = model.name;
        nameLabel.font = ZEBFont(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        [_scrollerView addSubview:nameLabel];
        
        [_scrollerView addSubview:imageView];
    }
    
    
    for (int j = 0; j < count2; j++) {
        
        GroupMemberModel *model1 = TMImageArray[j];
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
        imageView.frame = CGRectMake(0, 0, height(_scrollerView.frame), height(_scrollerView.frame));
        [imageView sd_setImageWithURL:[NSURL URLWithString:model1.headpic] placeholderImage:nil];
        
        imageView.frame = CGRectMake(count1*(height(_scrollerView.frame)) + j*(height(_scrollerView.frame)), 0, 35, 35);
        imageView.tag = 50000+j;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTM:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(imageView), maxY(imageView), width(imageView.frame), 15)];
        nameLabel.text = model1.ME_nickname;
        nameLabel.font = ZEBFont(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollerView addSubview:nameLabel];
        
        [_scrollerView addSubview:imageView];
    }
    
    
    for (int k = 0; k < count3; k++) {
        
        UserAllModel *model = UTImageArray[k];
        UIImageView *imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
        imageView.frame = CGRectMake(0, 0, height(_scrollerView.frame), height(_scrollerView.frame));
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.RE_headpic] placeholderImage:nil];
        
        imageView.frame = CGRectMake((count1 + count2)*(height(_scrollerView.frame)) + k*(height(_scrollerView.frame)), 0, 35, 35);
        imageView.tag = 500000+k;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteUT:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(imageView), maxY(imageView), width(imageView.frame), 15)];
        nameLabel.text = model.RE_name;
        nameLabel.font = ZEBFont(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollerView addSubview:nameLabel];
        
        [_scrollerView addSubview:imageView];
    }
    _scrollerView.contentSize = CGSizeMake((count3+count2+count1)*height(_scrollerView.frame), _scrollerView.frame.size.height);
    
    
}

#pragma mark -
#pragma mark 创建搜索下面三个按钮
- (void)createFRbtn {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 2*TopMargin+40, screenWidth(), 80+5)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:bgView];
    
//    CGFloat width = (screenWidth()-2)/3;
    
//    for (int i = 0 ; i < 2; i++) {
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*width, TopMargin, 1, 80-TopMargin*2)];
//        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [bgView addSubview:line];
//    }
    CGFloat left = 45;
    CGFloat btnMargin = 35;
    CGFloat wid = (screenWidth() - 90 - btnMargin*2 - 45)/2;
    CGFloat heightBtn = btnMargin;
    CGFloat widthBtn = btnMargin;
    
    
//    CGFloat btnMargin = (screenWidth()-2)/9;
//    CGFloat heightBtn = btnMargin;
//    CGFloat widthBtn = btnMargin;
    
    NSArray *titleAry = @[@"好友",@"组队",@"单位"];
   // NSArray *imageAry = @[@"contact_friend_icon",@"contact_team_icon",@"contact_organization_icon"];
     NSArray *imageAry = @[@"C_haoyou",@"C_zudui",@"C_danwei"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(btnMargin + i*(btnMargin*2+1+widthBtn), TopMargin, widthBtn, heightBtn);
        
        if (i == 0) {
            btn.frame = CGRectMake(left+i*(widthBtn+wid) , TopMargin, widthBtn, heightBtn);
        }else if (i == 1){
            btn.frame = CGRectMake(left+i*(widthBtn+wid+5) , TopMargin, widthBtn, heightBtn);
        }else if (i == 2){
            btn.frame = CGRectMake(left+i*(widthBtn+wid+5), TopMargin, widthBtn, heightBtn);
        }

        
        [btn setBackgroundImage:[UIImage imageNamed:imageAry[i]] forState:UIControlStateNormal];
        btn.tag = 1000+i;
        [btn setEnlargeEdgeWithTop:30 right:50 bottom:30 left:50];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(minX(btn), maxY(btn), widthBtn, 80 - 2*TopMargin - heightBtn+5)];
        if(i == 1)
        {
            title.frame = CGRectMake(minX(btn), maxY(btn), widthBtn, 80 - 2*TopMargin - heightBtn+5);
        }
        title.text = titleAry[i];
        title.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            title.textColor = zBlueColor;
        }else {
            title.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
        }
        title.font = [UIFont systemFontOfSize:14];
        title.tag = 10000+i;
        [bgView addSubview:title];
    }
    
    
}
#pragma mark -
#pragma mark 搜索下面三个按钮点击事件
- (void)btnClick:(UIButton *)btn {
    
    [self.view endEditing:YES];
    [self.resultArray removeAllObjects];
    NSInteger btnTag = btn.tag-1000;
    UILabel *lab1 = [self.view viewWithTag:10000];
    UILabel *lab2 = [self.view viewWithTag:10001];
    UILabel *lab3 = [self.view viewWithTag:10002];
    switch (btnTag) {
        case 0:
            
            lab1.textColor = zBlueColor;
            lab2.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            lab3.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
            _selAllView.hidden = NO;
            [self clickFriends:btnTag];
            break;
        case 1:
           
            lab1.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];;
            lab2.textColor = zBlueColor;
            lab3.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];;
            _selAllView.hidden = YES;
            [self clickTeam:btnTag];
            break;
        case 2:
           
            lab1.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];;
            lab2.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];;
            lab3.textColor = zBlueColor;
            _selAllView.hidden = YES;
            [self clickUnit:btnTag];
            break;
        default:
            break;
    }
    
}
#pragma mark -
#pragma mark 点击好友
- (void)clickFriends:(NSInteger)inter {
    
    self.type = FRIEND;
    [_bottomView addSubview:_friendsViewController.view];
    [_teamViewController.view removeFromSuperview];
    [_unitViewController.view removeFromSuperview];
    
}
#pragma mark -
#pragma mark 点击组队
- (void)clickTeam:(NSInteger)inter {
    
    self.type = TEAM;
    [_bottomView addSubview:_teamViewController.view];
    [_friendsViewController.view removeFromSuperview];
    [_unitViewController.view removeFromSuperview];
    
}
#pragma mark -
#pragma mark 点击单位
- (void)clickUnit:(NSInteger)inter {
    
    self.type = UNIT;
    [_bottomView addSubview:_unitViewController.view];
    [_teamViewController.view removeFromSuperview];
    [_friendsViewController.view removeFromSuperview];
    
}
#pragma mark -
#pragma mark  单位跳转界面
- (void)addGroupUTController:(AddGroupUTController *)con title:(NSString *)title arr:(NSMutableArray *)arr allUser:(NSMutableArray *)allUser allDepart:(NSMutableArray *)allDepart nextUser:(NSMutableArray *)nextUser {

    AddGroupUTNextController *next = [[AddGroupUTNextController alloc] init];
   
    next.userArray = allUser;
    next.departArray = allDepart;
    next.nextUserArr = nextUser;
    next.titleStr = title;
    next.arr = arr;
    
    [self.navigationController pushViewController:next animated:YES];
}
//点击图片删除
- (void)deleteFR:(UITapGestureRecognizer *)recognizer {
    
    NSInteger tag = [[recognizer view] tag]-5000;
    
    FriendsListModel *model = self.selectTempFRArray[tag];
    [self.selectFRArray removeObject:model];
    [self.selectTempFRArray removeObjectAtIndex:tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteFRNotification object:nil];
    //更新确定按钮数字
    [self updataBtnTitle];
    [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
    
}
- (void)deleteTM:(UITapGestureRecognizer *)recognizer {
    
    NSInteger tag = [[recognizer view] tag]-50000;
    
    GroupMemberModel *model = self.selectTempTMArray[tag];
    [self.selectTMArray removeObject:model];
    [self.selectTempTMArray removeObjectAtIndex:tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteTMNotification object:nil];
    //更新确定按钮数字
    [self updataBtnTitle];
    [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
    
    
}
- (void)deleteUT:(UITapGestureRecognizer *)recognizer {
    
    NSInteger tag = [[recognizer view] tag]-500000;
    
    UserAllModel *model = self.selectTempUTArray[tag];
    [self.selectUTArray removeObject:model];
    [self.selectTempUTArray removeObjectAtIndex:tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteUTNotification object:nil];
    //更新确定按钮数字
    [self updataBtnTitle];
    [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
    
    
}
#pragma mark -
#pragma mark 好友选中返回数组
- (void)addGroupsFRController:(AddGroupsFRController *)con selArray:(NSMutableArray *)ary {

    self.selectFRArray = ary;
    [self.selectTempFRArray removeAllObjects];
    [self.selectTempFRArray addObjectsFromArray:ary];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.selectTempFRArray];
   
    //过滤相同的人
    for (int i = 0; i < tempArray.count; i++) {
        FriendsListModel *fModel = tempArray[i];
        for (GroupMemberModel *gModel in self.selectTempTMArray) {
            
            if ([fModel.alarm isEqualToString:gModel.ME_uid]) {
                [self.selectTempFRArray removeObject:fModel];
                ZEBLog(@"删除");
             
                break;
            }
        }
    }
    
    for (int i = 0; i < tempArray.count; i++) {
        FriendsListModel *fModel = tempArray[i];
        
        for (UserAllModel *uModel in self.selectTempUTArray) {
            
            if ([fModel.alarm isEqualToString:uModel.RE_alarmNum]) {
                [self.selectTempFRArray removeObject:fModel];
                 ZEBLog(@"删除");
            
                break;
            }
        }
    }
    
    //更新确定按钮数字
    [self updataBtnTitle];
    [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
    
    
}
#pragma mark -
#pragma mark 组队选中返回数组
- (void)addGroupTMController:(AddGroupTMController *)con selArray:(NSMutableArray *)ary selGidstr:(NSString *)selGidstr{

    self.selectTMArray = ary;
    [self.selectTempTMArray removeAllObjects];
    [self.selectTempTMArray addObjectsFromArray:ary];
    
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.selectTempTMArray];
    //过滤相同的人
    for (int i = 0; i < tempArray.count; i++) {
        GroupMemberModel *gModel = tempArray[i];
        
        for (FriendsListModel *fModel in self.selectTempFRArray) {
            
            if ([gModel.ME_uid isEqualToString:fModel.alarm]) {
                [self.selectTempTMArray removeObject:gModel];
                
                 ZEBLog(@"删除:%@",gModel.ME_nickname);
                break;
            }
        }
    }
    
    for (int i = 0; i < tempArray.count; i++) {
        GroupMemberModel *gModel = tempArray[i];
        
        for (UserAllModel *uModel in self.selectTempUTArray) {
            
            if ([gModel.ME_uid isEqualToString:uModel.RE_alarmNum]) {
                [self.selectTempTMArray removeObject:gModel];
              
                
                 ZEBLog(@"删除");
                break;
                
            }
        }
    }

    
    self.selGid = selGidstr;
    //更新确定按钮数字
    [self updataBtnTitle];
    [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
}
#pragma mark -
#pragma mark 组织选中返回数组
- (void)addGroupUTController:(AddGroupUTController *)con selArray:(NSMutableArray *)ary {

    self.selectUTArray = ary;
    [self.selectTempUTArray removeAllObjects];
    [self.selectTempUTArray addObjectsFromArray:ary];
    
   NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.selectTempUTArray];
    //过滤相同的人
    for (int i = 0; i < tempArray.count; i++) {
        UserAllModel *uModel = tempArray[i];
        
        for (FriendsListModel *fModel in self.selectTempFRArray) {
            
            if ([uModel.RE_alarmNum isEqualToString:fModel.alarm]) {
                [self.selectTempUTArray removeObject:uModel];
          
                 ZEBLog(@"删除");
                break;
            }
        }
    }
    
    for (int i = 0; i < tempArray.count; i++) {
        UserAllModel *uModel = tempArray[i];
        
        for (GroupMemberModel *gModel in self.selectTempTMArray) {
            
            if ([uModel.RE_alarmNum isEqualToString:gModel.ME_uid]) {
                [self.selectTempUTArray removeObject:uModel];
              
                 ZEBLog(@"删除");
                break;
            }
        }
    }
    //更新确定按钮数字
    [self updataBtnTitle];
    [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];

}

#pragma mark -
#pragma mark 搜索
/**
 *  得到好友的姓名和警号数组
 */
- (void)getSoureFRArray {
    
    [self.allDataArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.alarmArray removeAllObjects];
    [self.allDataArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist]];
    for (FriendsListModel *friendsModel in self.allDataArray) {
        [self.nameArray addObject:friendsModel.name];
        [self.alarmArray addObject:friendsModel.alarm];
    }
    
}
/**
 *  得到好友的姓名和警号数组
 */
- (void)getSoureUTArray {
    
    [self.allUTDataArray removeAllObjects];
    [self.nameUTArray removeAllObjects];
    [self.alarmUTArray removeAllObjects];
    [self.allUTDataArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlist]];
    for (UserAllModel *userModel in self.allUTDataArray) {
        [self.nameUTArray addObject:userModel.RE_name];
        [self.alarmUTArray addObject:userModel.RE_alarmNum];
    }
    
}
#pragma mark -
#pragma mark 好友搜索
-(void)textFileFRSearch:(NSString *)TextField{
    
    
    if (TextField == nil || [TextField isEqualToString:@""]) {
        
        
       [_searchResultController reloadTableView];
        
    }
    //    // 完成具体的搜索功能
    //    // 1.清空搜索结果数组
    [self.resultArray removeAllObjects];
    
    int k = 0;
    
    //2。通过循环数据，找出与搜索关键字匹配的内容，把匹配的内容添加到数组中
    
    for (NSString *str in self.nameArray) {
        
        NSString *ste = [NSString stringWithFormat:@"%@",str];
        
        NSRange range = [ste rangeOfString:TextField];
        NSRange rangAlarm = [self.alarmArray[k] rangeOfString:TextField];
        
        if (range.length) {
            
            [self.resultArray addObject:self.allDataArray[k]];
        }else {
            
            if (rangAlarm.length) {
                [self.resultArray addObject:self.allDataArray[k]];
            }
        }
        
        k++;
        
    }
    [_searchResultController reloadTableView];
}
#pragma mark -
#pragma mark 单位搜索
-(void)textFileUTSearch:(NSString *)TextField{
    
    
    if (TextField == nil || [TextField isEqualToString:@""]) {
        
        
        [_searchResultController reloadTableView];
        
    }
    //    // 完成具体的搜索功能
    //    // 1.清空搜索结果数组
    [self.resultArray removeAllObjects];
    
    int k = 0;
    
    //2。通过循环数据，找出与搜索关键字匹配的内容，把匹配的内容添加到数组中
    
    for (NSString *str in self.nameUTArray) {
        
        NSString *ste = [NSString stringWithFormat:@"%@",str];
        
        NSRange range = [ste rangeOfString:TextField];
        NSRange rangAlarm = [self.alarmUTArray[k] rangeOfString:TextField];
        
        if (range.length) {
            
            [self.resultArray addObject:self.allUTDataArray[k]];
        }else {
            
            if (rangAlarm.length) {
                [self.resultArray addObject:self.allUTDataArray[k]];
            }
        }
        
        k++;
        
    }
    [_searchResultController reloadTableView];
}

//选中结果
- (void)addMemberSearchResultController:(AddMemberSearchResultController *)con model:(id)model {

    
    _selAllView.hidden = NO;
    [self.view endEditing:YES];
    _addTextField.text = @"";
    if (self.type == FRIEND) {
        
        [_searchResultController.view removeFromSuperview];
        [_bottomView addSubview:_friendsViewController.view];
        
      
            
            BOOL ret = NO;
            FriendsListModel *fModel = model;
            
            for (FriendsListModel *tempFModel in self.selectTempFRArray) {
                if ([tempFModel.alarm isEqualToString:fModel.name]) {
                    ret = YES;
                }
            }
            for (GroupMemberModel *tempGModel in self.selectTempTMArray) {
                if ([tempGModel.ME_uid isEqualToString:fModel.alarm]) {
                    ret = YES;
                }
            }
            for (UserAllModel *tempUModel in self.selectTempUTArray) {
                if ([tempUModel.RE_alarmNum isEqualToString:fModel.alarm]) {
                    ret = YES;
                }
            }
            
            if (!ret) {
                
            
                [self.selectTempFRArray addObject:fModel];
                //刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:SearchAddFRNotification object:self.selectTempFRArray];
                //更新确定按钮数字
                [self updataBtnTitle];
                [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
                

            }
            
        
        
    }else if (self.type == TEAM) {
        
    }else if (self.type == UNIT) {
        
        [_searchResultController.view removeFromSuperview];
        [_bottomView addSubview:_unitViewController.view];
        
        
        BOOL ret = NO;
        UserAllModel *uModel = model;
        
        for (FriendsListModel *tempFModel in self.selectTempFRArray) {
            if ([tempFModel.alarm isEqualToString:uModel.RE_alarmNum]) {
                ret = YES;
            }
        }
        for (GroupMemberModel *tempGModel in self.selectTempTMArray) {
            if ([tempGModel.ME_uid isEqualToString:uModel.RE_alarmNum]) {
                ret = YES;
            }
        }
        for (UserAllModel *tempUModel in self.selectTempUTArray) {
            if ([tempUModel.RE_alarmNum isEqualToString:uModel.RE_alarmNum]) {
                ret = YES;
            }
        }
        
        if (!ret) {
            
            
            [self.selectTempUTArray addObject:uModel];
            //刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:SearchAddUTNotification object:self.selectTempUTArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeleteUTNotification object:nil];
            //更新确定按钮数字
            [self updataBtnTitle];
            [self addImage:self.selectTempFRArray TMImageArray:self.selectTempTMArray UTImageArray:self.selectTempUTArray];
            
            
        }
        

        
    }
    
}
- (void)scrollViewDidScroll:(AddMemberSearchResultController *)con {
    [self.view endEditing:YES];
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
