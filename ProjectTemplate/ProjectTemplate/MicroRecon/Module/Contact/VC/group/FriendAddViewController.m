//
//  FriendAddViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendAddViewController.h"
#import "Masonry.h"
#import "FriendLogic.h"

@interface FriendAddViewController()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *hintLbl;
@property (nonatomic, strong) UITextField *messageField;

@end

@implementation FriendAddViewController

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendFriendRequest)];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"朋友验证";
    
    [self.view addSubview:self.hintLbl];
    [self.view addSubview:self.messageField];
    [self makeConstraints];
}

- (void)sendFriendRequest {
    ZEBLog(@"sendFriendRequest --> FriendAlarm is %@ ,message is %@",self.friendAlarm, self.messageField.text);
    [self showloadingName:@"正在发送"];
    [[FriendLogic sharedManager] logicAddFriend:self.friendAlarm message:self.messageField.text progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:[error description]];
        ZEBLog(@"%@",[error description]);
    }];
}

#pragma mark - Masonry

- (void)makeConstraints {
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80.f);
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [self.messageField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLbl.mas_bottom).offset(10.f);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(@48);
  
    }];
}

#pragma mark - Getter

- (UILabel *)hintLbl {
    if (!_hintLbl) {
        _hintLbl = [[UILabel alloc] init];
        _hintLbl.text = @"你需要发送验证申请，等对方通过";
        _hintLbl.textColor = [UIColor grayColor];
        _hintLbl.font = [UIFont systemFontOfSize:14.f];
    }
    
    return _hintLbl;
}

- (UITextField *)messageField {
    if (!_messageField) {
        _messageField = [[UITextField alloc] init];
        _messageField.placeholder = @"验证消息";
        _messageField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _messageField.keyboardType = UIKeyboardTypeDefault;
        _messageField.returnKeyType = UIReturnKeyDone;
        _messageField.backgroundColor = [UIColor whiteColor];
        _messageField.borderStyle =  UITextBorderStyleNone;
        _messageField.delegate = self;
        CGRect frame = _messageField.frame;
        frame.size.width = 10.f;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        _messageField.leftViewMode = UITextFieldViewModeAlways;
        _messageField.leftView = leftview;
        [_messageField becomeFirstResponder];
    }
    
    return _messageField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendFriendRequest];
    return YES;
}

@end
