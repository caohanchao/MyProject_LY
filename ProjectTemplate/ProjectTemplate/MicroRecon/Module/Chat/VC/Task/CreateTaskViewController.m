//
//  CreateTaskViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "FriendsListModel.h"
#import "GroupMemberModel.h"
#import "UserAllModel.h"
#import "AddGroupMemberController.h"
#import "TaskIntroduceViewController.h"
#import "NSString+Emoji.h"

#define groupNamePlaceholder @"请输入任务名称"
#define LeftMargin 0

@interface CreateTaskViewController ()<AddGroupMemberControllerDelegate> {
    UIScrollView *_scrollerView;
    UIButton *_commitBtn;
}


@property (nonatomic, weak) UITextField *taskNameField;
@property (nonatomic, strong) UILabel *taskDesLabel;

@end

@implementation CreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"发布任务";
    [self initall];
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

- (void)initall {
    [self createRightButton];
    [self createUI];
}
- (void)createUI {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = zWhiteColor;
    
    
    UILabel *line1 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:zWhiteColor text:@""];
    
    UILabel *taskNameLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zBlackColor text:@"任务名称："];
    
    UILabel *line2 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:zWhiteColor text:@""];
    
    self.taskNameField = self.textField;
    self.taskNameField.placeholder = groupNamePlaceholder;
    self.taskNameField.backgroundColor = [UIColor whiteColor];
    self.taskNameField.returnKeyType=UIReturnKeyDone;
    //self.taskNameField.delegate=self;
    self.taskNameField.tintColor = [UIColor redColor];
    [self.taskNameField becomeFirstResponder];
    self.taskNameField.font =[UIFont systemFontOfSize:14];
    [self.taskNameField setValue:zLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    
    UILabel *taskDes = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zBlackColor text:@"任务介绍："];
    
    self.taskDesLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zBlackColor text:@""];
    self.taskDesLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *taskDesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskDesTap)];
    [self.taskDesLabel addGestureRecognizer:taskDesTap];
    
    UIImageView *taskImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    
    UILabel *line3 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:zWhiteColor text:@""];
    
    
    UILabel *line4 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:zWhiteColor text:@""];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = zWhiteColor;
    
    
    UILabel *joinMembersLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zBlackColor text:@"参与人员"];
    joinMembersLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *joinMembersTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinMembersTap)];
    [joinMembersLabel addGestureRecognizer:joinMembersTap];
    
     UIImageView *joinMembersImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    
    UILabel *line5 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:zWhiteColor text:@""];
    _scrollerView = [[UIScrollView alloc] init];
    //_scrollerView.backgroundColor = [UIColor whiteColor];
    
    
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [self.view addSubview:line1];
    [self.view addSubview:taskNameLabel];
    [self.view addSubview:self.taskNameField];
    [self.view addSubview:line2];
    [self.view addSubview:taskDes];
    [self.view addSubview:self.taskDesLabel];
    [self.view addSubview:taskImg];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    [self.view addSubview:joinMembersLabel];
    [self.view addSubview:joinMembersImg];
    [self.view addSubview:line5];
    [self.view addSubview:_scrollerView];
    
    CGFloat leftM = 14;
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(TopBarHeight+16);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 44.5*2+1.5));
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(16);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 44.5+1));
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 0.5));
    }];
    [taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(leftM);
        make.height.equalTo(@44.5);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [self.taskNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(taskNameLabel.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-leftM);
        make.height.equalTo(@44.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskNameLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 0.5));
    }];
    [taskDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(leftM);
        make.height.equalTo(@44.5);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [self.taskDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom);
        make.left.equalTo(taskDes.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-leftM-30);
        make.height.equalTo(@44.5);

    }];
    [taskImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-leftM);
        make.centerY.equalTo(self.taskDesLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskDes.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 0.5));
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(16);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 0.5));
    }];
    [joinMembersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line4.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-leftM-30);
        make.height.equalTo(@44.5);
    }];
    [joinMembersImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-leftM);
        make.centerY.equalTo(joinMembersLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinMembersLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 0.5));
    }];
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line5.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(width(self.view.frame), 62));
    }];
    
    
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
- (void)createRightButton {
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame = CGRectMake(0, 0, 40, 40);
    _commitBtn.titleLabel.font = ZEBFont(16);
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitleColor:[UIColor lightTextColor]];
    [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_commitBtn];

    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
    
    
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
        _scrollerView.backgroundColor = [UIColor whiteColor];
    }else {
        _scrollerView.backgroundColor = [UIColor clearColor];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
#pragma mark -
#pragma mark AddGroupMemberControllerDelegate
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

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *string1 = [NSString stringWithFormat:@"%@%@", textField.text, string];
//    if (string1.length > TITLE_MAXLENGTH){
//        [self showloadingError:@"字数不能大于14!"];
//        return NO;
//    }
//    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"])
//    {
//        [self showloadingError:@"输入格式有误!"];
//        return NO;
//    }
//    if ([NSString stringContainsEmoji:string])
//    {
//        [self showloadingError:@"输入格式有误!"];
//        return NO;
//    }
//    return YES;
//}

#pragma mark -
#pragma mark 任务介绍
- (void)taskDesTap {
    TaskIntroduceViewController *task = [[TaskIntroduceViewController alloc] init];
    task.text = self.taskDesLabel.text;
    task.block = ^(TaskIntroduceViewController *controller, NSString *intro){
        self.taskDesLabel.text = intro;
    };
    [self.navigationController pushViewController:task animated:YES];
}
#pragma mark -
#pragma mark 参与人员
- (void)joinMembersTap {
    [_taskNameField resignFirstResponder];
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
#pragma mark -
#pragma mark 提交任务
- (void)commit {
    
    [self.view endEditing:YES];
    
    self.taskNameField.text = [self.taskNameField.text trimWhitespaceAndNewline];
    if ([[LZXHelper isNullToString:self.taskNameField.text] isEqualToString:@""]) {
        [self showHint:@"请输入任务名称"];
        return;
    }
    if ([LZXHelper isNullToString:self.taskNameField.text].length > 14) {
        [self showHint:@"组队名称不能超过14字"];
        return;
    }
    [self httpCreateTask];
}
- (void)httpCreateTask {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"action"] = @"createsuspect";
    param[@"alarm"] = alarm;
    param[@"token"] = token;

    param[@"grname"] = self.taskNameField.text;//群名称
    param[@"suspectname"] = self.taskNameField.text;//任务名称
    param[@"participant"] = [LZXHelper objArrayToJSON:[self selGroupMember]];//参与人员
    param[@"type"] = @"0";//任务类型
    param[@"suspectdec"] = self.taskDesLabel.text;//任务介绍
    NSInteger usercount = [self selGroupMember].count;
    if (usercount == 0) {
        usercount = 1;
    }else {
        usercount = usercount+1;
    }
    if (![NSString containEmoji:self.taskNameField.text]) {
        [self showloadingName:@"正在提交"];
        [[HttpsManager sharedManager] post:PublishTaskURL parameters:param progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                                 options:NSJSONReadingMutableContainers error:nil];
            
            [self hideHud];
            if ([dict[@"resultcode"] isEqualToString:@"1020"]) {
                [self showHint:@"任务名已存在"];
            }
            else if ([dict[@"resultcode"] isEqualToString:@"0"]) {
                [[[DBManager sharedManager] GrouplistSQ] insertGrouplistGroupSuccess:dict[@"response"][@"gid"] gname:dict[@"response"][@"gname"] gadmin:dict[@"response"][@"gadmin"] gcreatetime:dict[@"response"][@"gcreatetime"] gtype:@"0" gusercount:[NSString stringWithFormat:@"%ld",usercount]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
                
                TeamsListModel *model =[[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:dict[@"response"][@"gid"]];
                
                [self performSelector:@selector(postNotifaction:) withObject:model afterDelay:1.0f];
            }else {
                
                [self showHint:@"发起任务失败"];
            
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self hideHud];
            [self showHint:@"发起任务失败"];
        }];
    }
    else
    {
        [self showHint:@"请重新输入任务名称"];
    }


}

- (void)postNotifaction:(TeamsListModel *)model
{
    [self hideHud];
    [self showHint:@"发起任务成功"];
    [self.navigationController popViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PushTaskGroupChatNotification object:@[model,@(self.type)]];
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
