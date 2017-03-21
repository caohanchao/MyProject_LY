//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CreateGroupController.h"
#import "AddGroupMemberController.h"
#import "FriendsListModel.h"
#import "GroupMemberModel.h"
#import "UserAllModel.h"
#import "XMNChatController.h"

#define groupNamePlaceholder @" 组队名称"
#define LeftMargin 0

@interface CreateGroupController ()<AddGroupMemberControllerDelegate,UITextFieldDelegate> {


    UITextField *_groupNameField;
    UIScrollView *_scrollerView;
    //UIBarButtonItem *_rightBar;
    UIButton *_commitBtn;
}

@end

@implementation CreateGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"创建群组";
    [self initall];
}
- (void)initall {

    [self createRightButton];
    [self createGroupNameView];
    [self createChooseMember];
    

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
- (void)createRightButton {
    
   _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame = CGRectMake(0, 0, 40, 40);
    _commitBtn.titleLabel.font = ZEBFont(16);
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitleColor:[UIColor lightTextColor]];
    [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_commitBtn];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
//    _rightBar=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commit:)];
//    self.navigationItem.rightBarButtonItem=_rightBar;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *arr = [self selGroupMember];
    if (arr.count != 0) {
        _commitBtn.userInteractionEnabled = YES;
        [_commitBtn setTitleColor:[UIColor whiteColor]];
    }else {
        _commitBtn.userInteractionEnabled = NO;
        [_commitBtn setTitleColor:[UIColor lightTextColor]];
    }
}

//- (void)


#pragma mark -
#pragma mark 创建群组
- (void)commit:(UIButton *)btn {

    [self.view endEditing:YES];
    _groupNameField.text = [_groupNameField.text trimWhitespaceAndNewline];
    if ([[LZXHelper isNullToString:_groupNameField.text] isEqualToString:@""]) {
        [self showHint:@"请输入组队名称"];
        return;
    }
    if ([LZXHelper isNullToString:_groupNameField.text].length > 14) {
        [self showHint:@"组队名称不能超过14字"];
        return;
    }
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"groupcreate";
    params[@"alarm"] = alarm;
    params[@"token"] = token;
    params[@"gname"] = _groupNameField.text;
    params[@"participant"] = [LZXHelper objArrayToJSON:[self selGroupMember]];
   
    NSInteger usercount = [self selGroupMember].count;
    if (usercount == 0) {
        usercount = 1;
    }else {
        usercount = usercount+1;
    }
    [self showloadingName:@"正在提交"];
    [HYBNetworking postWithUrl:CreateGroupUrl refreshCache:YES params:params success:^(id response) {
        ZEBLog(@"------%@",response);
        [self hideHud];
        if ([response[@"resultcode"] isEqualToString:@"0"]){
            [[[DBManager sharedManager] GrouplistSQ] insertGrouplistGroupSuccess:response[@"response"][@"gid"] gname:response[@"response"][@"gname"] gadmin:response[@"response"][@"gadmin"] gcreatetime:response[@"response"][@"gcreatetime"] gtype:@"1" gusercount:[NSString stringWithFormat:@"%ld",usercount]];

            [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
            
            
            TeamsListModel *model =[[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:response[@"response"][@"gid"]];
            
            [self performSelector:@selector(postNotifaction:) withObject:model afterDelay:1.0f];
        }
        else if ([response[@"resultcode"] isEqualToString:@"1020"]) {
            [self showHint:@"群名已存在"];
        }else {
            
            [self showHint:@"创建失败"];
            
        }
        

    } fail:^(NSError *error) {
        
        [self showHint:@"创建失败"];
        
    }];
}

- (void)postNotifaction:(TeamsListModel *)model
{
    [self hideHud];
    [self showHint:@"组队成功"];
    [self.navigationController popViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PushGroupChatNotification object:@[model,@(self.comeType)]];
}

/*
 #import "FriendsListModel.h"
 #import "GroupMemberModel.h"
 #import "UserAllModel.h"
 */
- (NSArray *)selGroupMember {

    NSMutableArray *selMemberAlarmArray = [NSMutableArray array];
    for (FriendsListModel *FRModel in self.selectTempFRArray) {
        [selMemberAlarmArray addObject:FRModel.alarm];
    }
    for (GroupMemberModel *TMModel in self.selectTempTMArray) {
        [selMemberAlarmArray addObject:TMModel.ME_uid];
    }
    for (UserAllModel *UTModel in self.selectTempUTArray) {
        [selMemberAlarmArray addObject:UTModel.RE_alarmNum];
    }
    return selMemberAlarmArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)createGroupNameView {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, LeftMargin+64+20, kScreen_Width-2*LeftMargin, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    [self.view addSubview:bgView];
    _groupNameField = [[UITextField alloc] initWithFrame:CGRectMake(LeftMargin+5, LeftMargin+64+20, kScreen_Width-2*(LeftMargin+5), 50)];
    _groupNameField.placeholder = groupNamePlaceholder;
    _groupNameField.backgroundColor = [UIColor whiteColor];
    _groupNameField.returnKeyType=UIReturnKeyDone;
    _groupNameField.delegate=self;
    _groupNameField.tintColor = [UIColor redColor];
    [_groupNameField becomeFirstResponder];
    _groupNameField.font =[UIFont systemFontOfSize:15];
    [_groupNameField setValue:zBlueColor forKeyPath:@"_placeholderLabel.textColor"];


    [self.view addSubview:_groupNameField];
    
}
- (void)createChooseMember {

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, maxY(_groupNameField)+20, kScreen_Width, 50);
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [addBtn addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addBtn];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    lab.text = @"参与人员";
    lab.font = ZEBFont(15);
    [addBtn addSubview:lab];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightarrow"]];
    
    imageView.frame = CGRectMake(kScreen_Width - 50, 10, 30, 30);
    [addBtn addSubview:imageView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(addBtn), kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];

    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,maxY(line), kScreen_Width,62)];
    _scrollerView.backgroundColor = [UIColor whiteColor];
}
/*
 #import "FriendsListModel.h"
 #import "GroupMemberModel.h"
 #import "UserAllModel.h"
 */
- (void)addImage:(NSArray *)FRImageArray TMImageArray:(NSArray *)TMImageArray UTImageArray:(NSArray *)UTImageArray{
    
    NSInteger count1 = FRImageArray.count;
    NSInteger count2 = TMImageArray.count;
    NSInteger count3 = UTImageArray.count;
    for (int i = 0; i < count1; i++) {
        FriendsListModel *model = FRImageArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, height(_scrollerView.frame), height(_scrollerView.frame))];
        imageView.layer.cornerRadius=5.0;
        imageView.layer.masksToBounds=YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:nil];
        
        imageView.frame = CGRectMake(i*(height(_scrollerView.frame)),5, 40, 40);
        
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
        
        GroupMemberModel *model = TMImageArray[j];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, height(_scrollerView.frame), height(_scrollerView.frame))];
        imageView.layer.cornerRadius=5.0;
        imageView.layer.masksToBounds=YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:nil];
        
        imageView.frame = CGRectMake(count1*(height(_scrollerView.frame)) + j*(height(_scrollerView.frame)), 5, 40, 40);
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(minX(imageView), maxY(imageView), width(imageView.frame), 15);
        
        nameLabel.text = model.ME_nickname;
        nameLabel.font = ZEBFont(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        [_scrollerView addSubview:nameLabel];
        
        [_scrollerView addSubview:imageView];
    }
    for (int k = 0; k < count3; k++) {
        
        UserAllModel *model = UTImageArray[k];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, height(_scrollerView.frame), height(_scrollerView.frame))];
        imageView.layer.cornerRadius=5.0;
        imageView.layer.masksToBounds=YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.RE_headpic] placeholderImage:nil];
        
        imageView.frame = CGRectMake((count1 + count2)*(height(_scrollerView.frame)) + k*(height(_scrollerView.frame)),5, 40, 40);
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(minX(imageView),maxY(imageView), width(imageView.frame), 15);
        
        nameLabel.text = model.RE_name;
        nameLabel.font = ZEBFont(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        [_scrollerView addSubview:nameLabel];
        [_scrollerView addSubview:imageView];
    }
    _scrollerView.contentSize = CGSizeMake((count3+count2+count1)*height(_scrollerView.frame), _scrollerView.frame.size.height);
    
    NSInteger count = count3+count2+count1;
    if (count != 0) {
        [self.view addSubview:_scrollerView];
    }else {
        [_scrollerView removeFromSuperview];
    }
}
- (void)addImage:(NSArray *)imageArray {

    NSInteger count = imageArray.count;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, height(_scrollerView.frame), height(_scrollerView.frame))];
        imageView.image = imageArray[i];
        imageView.backgroundColor = [UIColor redColor];
        imageView.frame = CGRectMake(5+i*(height(_scrollerView.frame)+5), 0, height(_scrollerView.frame), height(_scrollerView.frame));
        [_scrollerView addSubview:imageView];
    }
    _scrollerView.contentSize = CGSizeMake(count*height(_scrollerView.frame)+5, _scrollerView.frame.size.height);
    
}
- (void)addMember:(UIButton *)btn {
    [_groupNameField resignFirstResponder];
    AddGroupMemberController *add = [[AddGroupMemberController alloc] init];
    add.delegate = self;
    
//    if (self.selectFRArray.count==0) {
//        [self showHint:@"您暂时还没有添加好友，无法添加人员"];
//        return;
//    }
    add.selectFRArray = self.selectFRArray;
    add.selectTMArray = self.selectTMArray;
    add.selectUTArray = self.selectUTArray;
    
    [add.selectTempFRArray addObjectsFromArray:self.selectTempFRArray];
    [add.selectTempTMArray addObjectsFromArray:self.selectTempTMArray];
    [add.selectTempUTArray addObjectsFromArray:self.selectTempUTArray];
    
    add.selGid = self.selGid;
    add.fromeWhere = FromeCreateGroup;
    [self.navigationController pushViewController:add animated:YES];

}
- (void)addGroupMemberController:(AddGroupMemberController *)con selectFRArray:(NSMutableArray *)FRArray selectTMArray:(NSMutableArray *)TMArray selectUTArray:(NSMutableArray *)UTArray selectTempFRArray:(NSMutableArray *)tempFRArray selectTempTMArray:(NSMutableArray *)tempTMArray selectTempUTArray:(NSMutableArray *)tempUTArray selGid:(NSString *)selGid {

    for (UIView *view in [_scrollerView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.selectFRArray = FRArray;
    self.selectTMArray = TMArray;
    self.selectUTArray = UTArray;
    
    [self.selectTempFRArray removeAllObjects];
    [self.selectTempTMArray removeAllObjects];
    [self.selectTempUTArray removeAllObjects];
    
    [self.selectTempFRArray addObjectsFromArray:tempFRArray];
    [self.selectTempTMArray addObjectsFromArray:tempTMArray];
    [self.selectTempUTArray addObjectsFromArray:tempUTArray];
    
    self.selGid = selGid;
    [self addImage:tempFRArray TMImageArray:tempTMArray UTImageArray:tempUTArray];
    
}
#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *string1 = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (string1.length > TITLE_MAXLENGTH){
        [self showloadingError:@"字数不能大于14!"];
        return NO;
    }
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
    return YES;
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
