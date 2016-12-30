//
//  ChangeUserInfoPhoneController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChangeUserInfoPhoneController.h"

@interface ChangeUserInfoPhoneController ()<UITextFieldDelegate> {

    UITextField *_textField;
}

@end

@implementation ChangeUserInfoPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"电话号码";
    [self initall];
}
- (void)initall {
    [self createRightBarBtn];
    
}
- (void)createRightBarBtn {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = ZEBFont(16);
    [button addTarget:self action:@selector(rightBtnG) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
    
}
//提交
- (void)rightBtnG {

    [self.view endEditing:YES];
    if ([_textField.text isEqualToString:@""]) {
        [self showHint:@"请输入手机号"];
        return;
    }
    if ([_textField.text isEqualToString:self.phoneNum]) {
        [self showHint:@"未修改"];
        return;
    }
    if (![LZXHelper isMobileNumber:_textField.text]) {
        [self showHint:@"您输入的号码格式不正确"];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeUserInfoPhoneController:phoneNum:)]) {
        [_delegate changeUserInfoPhoneController:self phoneNum:_textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)createUI {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+20, kScreen_Width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width-20, 40)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.tintColor = [UIColor redColor];
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_textField];
}
- (void)setPhoneNum:(NSString *)phoneNum {

    _phoneNum = phoneNum;
    [self createUI];
    _textField.text = _phoneNum;
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
