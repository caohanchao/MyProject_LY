//
//  RegisterViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//


#define font() [UIFont systemFontOfSize:14]
#define textFontColor CHCHexColor(@"a6a6a6")


#import "RegisterViewController.h"
#import "MyTextField.h"
#import "NextRegisterViewController.h"
#import "RegisteredViewController.h"
#import "AccountLogic.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)MyTextField *phoneNumField;
@property (nonatomic,strong)MyTextField *testNumField;
@property (nonatomic,strong)CHCTextField *passWordNumField;

@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UILabel *newsLabel;


@property (nonatomic,copy)NSString *phoneNum;
@property (nonatomic,copy)NSString *testNum;
@property (nonatomic,copy)NSString *password;

@property (nonatomic,copy)UIButton *eyeBtn;
//@property (nonatomic,copy)UIButton *testBtn;
@property (nonatomic,copy)UILabel *testBtn;

//@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger sec;

@property (nonatomic,copy)NSString *resultPhoneNum;
@property (nonatomic,copy)NSString *resultMsgcode;
@end



@implementation RegisterViewController


- (void)setVcType:(RegisterVCtype)vcType {
    _vcType = vcType;
    if (_vcType == Frist_RegisterVC) {
        self.title = @"注册";
//        _passWordNumField.placeholder = @"请输入密码";
    } else if (_vcType == ForgetPassWord_ResetRegisterVC) {
        self.title = @"找回密码";
//        _passWordNumField.placeholder = @"请输入新密码";
    }
    
}

//- (UITextField *)phoneNumField {
//    if (!_phoneNumField) {
//        _phoneNumField = [[UITextField alloc] init];
//        _phoneNumField.placeholder = @"请输入手机号";
//        [_phoneNumField setValue: CHCHexColor(@"a6a6a6") forKeyPath:@"placeholderLabel.textColor"];
////        _phoneNumField.textAlignment =
//    }
//    return _phoneNumField;
//}
//
//- (UITextField *)testNumField {
//    if (!_testNumField) {
//        _testNumField = [[UITextField alloc] init];
//        _testNumField.placeholder = @"请输入验证码";
//        [_testNumField setValue:[UIColor grayColor] forKey:@"placeholderLabel.textColor"];
//        
//    }
//    return _testNumField;
//}
//
//- (UITextField *)passWardNumField {
//    if (!_passWardNumField) {
//        _passWardNumField = [[UITextField alloc] init];
//        _passWardNumField.placeholder = @"请输入密码";
//        _passWardNumField.secureTextEntry = YES;
//        [_passWardNumField setValue:[UIColor grayColor] forKey:@"placeholderLabel.textColor"];
//        
//        UIButton *leftpassWardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftpassWardBtn.frame = CGRectMake(12, 10, 20, 20);
//        [leftpassWardBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [leftpassWardBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
//        
//        [leftpassWardBtn addTarget:self action:@selector(passWardNumClick:) forControlEvents:UIControlEventTouchUpInside];
//        _passWardNumField.rightView = leftpassWardBtn;
//        
//    }
//    return _passWardNumField;
//}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius  = 6;
        _nextBtn.enabled = NO;
        _nextBtn.font = [UIFont systemFontOfSize:16];
        _nextBtn.backgroundColor = CHCHexColor(@"a6a6a6");
    }
    return _nextBtn;
}




- (MyTextField *)phoneNumField {
    if (!_phoneNumField) {
        _phoneNumField = [[MyTextField alloc] init];
        _phoneNumField.backgroundColor = [UIColor whiteColor];
        UIImageView *phoneNumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Register_phoneNum"]];
        phoneNumView.frame = CGRectMake(12, 0, 20, 20);
        _phoneNumField.leftView = phoneNumView;
        _phoneNumField.keyboardType = UIKeyboardTypeASCIICapable;
        _phoneNumField.font = font();
        _phoneNumField.placeholder = @"请输入手机号";
        [_phoneNumField setValue:CHCHexColor(@"a6a6a6") forKeyPath:@"placeholderLabel.textColor"];
        _phoneNumField.returnKeyType = UIReturnKeyNext;
        _phoneNumField.leftViewMode = UITextFieldViewModeAlways;
        _phoneNumField.delegate =self;
    }
    return _phoneNumField;
}

- (MyTextField *)testNumField {
    if (!_testNumField) {
        _testNumField = [[MyTextField alloc] init];
        _testNumField.backgroundColor = [UIColor whiteColor];
        
        UIImageView *testNumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Register_testNum"]];
        testNumView.frame = CGRectMake(12, 0, 20, 20);
//        testNumView.backgroundColor =[UIColor redColor];
        _testNumField.leftView = testNumView;
        _testNumField.keyboardType = UIKeyboardTypeASCIICapable;
        _testNumField.placeholder = @"请输入验证码";
        _testNumField.returnKeyType = UIReturnKeyNext;
        [_testNumField setValue:CHCHexColor(@"a6a6a6") forKeyPath:@"placeholderLabel.textColor"];
        _testNumField.font = font();
        _testNumField.leftViewMode = UITextFieldViewModeAlways;
        
        _testBtn = [UILabel new];
//        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_testBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//       
//        [_testBtn setTitle:@"再次获取60秒" forState:UIControlStateSelected];
//         [_testBtn.titleLabel  sizeToFit];
//        _testBtn.titleLabel.adjustsFontSizeToFitWidth =  YES;
//        [_testBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
//        _testBtn.layer.masksToBounds = YES;
//        _testBtn.layer.cornerRadius = 3;
//        _testBtn.layer.borderWidth = 0.5;
//        _testBtn.layer.borderColor = CHCHexColor(@"cccccc").CGColor;
//        _testBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        _testBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
////        _testBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [_testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        _testBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
//        _testBtn.frame = CGRectMake(12, 0, 80, 20);
//        [_testBtn sizeToFit];

        
        _testBtn.text = @"获取验证码";
        _testBtn.layer.masksToBounds = YES;
        _testBtn.layer.cornerRadius = 3;
        _testBtn.layer.borderWidth = 0.5;
        _testBtn.layer.borderColor = CHCHexColor(@"cccccc").CGColor;
        _testBtn.textAlignment = NSTextAlignmentCenter;
        _testBtn.userInteractionEnabled = YES;
        _testBtn.font = [UIFont systemFontOfSize:12];
        _testBtn.textColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testNumClick)];
        [_testBtn addGestureRecognizer:tap];
        
//        [_testBtn addTarget:self action:@selector(testNumClick) forControlEvents:UIControlEventTouchUpInside];
        _testNumField.rightView = _testBtn;
        _testNumField.rightViewMode = UITextFieldViewModeAlways;
        _testNumField.delegate =self;
    
    }
    return _testNumField;
}

- (CHCTextField *)passWardNumField {
    if (!_passWordNumField) {
        
        _passWordNumField = [[CHCTextField alloc] init];
        _passWordNumField.keyboardType = UIKeyboardTypeASCIICapable;
        _passWordNumField.backgroundColor = [UIColor whiteColor];

        if (_vcType == Frist_RegisterVC) {
            _passWordNumField.placeholder = @"请输入密码";
        } else if (_vcType == ForgetPassWord_ResetRegisterVC) {
            _passWordNumField.placeholder = @"请输入新密码";
        }
        _passWordNumField.font = font();
        _passWordNumField.secureTextEntry = YES;
        [_passWordNumField setValue:CHCHexColor(@"a6a6a6") forKeyPath:@"placeholderLabel.textColor"];
        
        UIImageView *passNumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Register_password"]];
        passNumView.frame = CGRectMake(12, 0, 20, 20);
        _passWordNumField.leftView = passNumView;
        _passWordNumField.leftViewMode =UITextFieldViewModeAlways;
        _passWordNumField.delegate =self;
        _passWordNumField.returnKeyType = UIReturnKeyGo;
        
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeBtn setImage:[UIImage imageNamed:@"Register_eye_down"] forState:UIControlStateNormal];
        [_eyeBtn setImage:[UIImage imageNamed:@"Register_eye_on"] forState:UIControlStateSelected];
        _eyeBtn.frame =CGRectMake(12, 0, 20, 20);
        [_eyeBtn addTarget:self action:@selector(passNumClick) forControlEvents:UIControlEventTouchUpInside];
        _passWordNumField.rightView = _eyeBtn;
        _passWordNumField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _passWordNumField;
}

- (UILabel *)newsLabel {
    if (!_newsLabel) {
        _newsLabel = [[UILabel alloc] init];
        _newsLabel.text = @"密码由6-20位英文字母、数字或者下划线组成";
        _newsLabel.font = [UIFont systemFontOfSize:14];
        _newsLabel.textColor = CHCHexColor(@"808080");
    }
    return _newsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAll];
    // Do any additional setup after loading the view.
}

- (void)initAll {
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    
//    [self initTableView];
    
    [self creatUI];
    
    
}
//- (void)creatTimer {
//    self.sec = 60;
//    _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTestLabel) userInfo:nil repeats:YES];
//}

- (void)creatUI {
    
    [self.view addSubview:self.phoneNumField];
    [self.view addSubview:self.testNumField];
    [self.view addSubview:self.passWardNumField];
    [self.view addSubview:self.newsLabel];
    [self.view addSubview:self.nextBtn];
    
    CGFloat left_right_Constraints = 12;
    CGFloat textHeight = 45;
    
    [self.phoneNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(64+16);
        make.height.offset(textHeight);
    }];
    
    [self.testNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.phoneNumField.mas_bottom).offset(16);
        make.height.equalTo(self.phoneNumField);
    }];
    
    [self.passWordNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.testNumField.mas_bottom).offset(16);
        make.height.equalTo(self.phoneNumField);
    }];
    
    [self.newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(left_right_Constraints);
        make.right.equalTo(self.view.mas_right).offset(-left_right_Constraints);
        make.top.equalTo(self.passWordNumField.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(left_right_Constraints);
        make.right.equalTo(self.view.mas_right).offset(-left_right_Constraints);
        make.top.equalTo(self.newsLabel.mas_bottom).offset(30);
        make.height.offset(textHeight);
    }];

}

//- (void)reloadTestLabel {
//   
//    self.sec--;
//    
//    if (self.sec>0) {
//        
//        self.testBtn.titleLabel.text = [NSString stringWithFormat:@"再次%ld秒",self.sec];
//        self.testBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
//    } else if (self.sec == 0) {
//        [self testNumClick];
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//    
//    
//}


- (void)nextClick {
    
    [self textFieldrResignFirstResponder];
//    NextRegisterViewController *nvc = [[NextRegisterViewController alloc] init];
////    nvc.information = dict;
//    [self.navigationController pushViewController:nvc animated:YES];

//    [self testPhoneNum];
//
    //手机号是否为空
    if ([[LZXHelper isNullToString:self.phoneNumField.text] isEqualToString:@""]) {
        [self showHint:@"请输入手机号码"];
        return;
    }
    //手机号是否合法
    if (![LZXHelper isMobileNumber:self.phoneNumField.text]) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    
    if (![LZXHelper validatePassWord:_passWordNumField.text]) {
        [self showHint:@"密码格式错误,请重新输入密码"];
        return;
    }
    
    self.phoneNum = self.phoneNumField.text;
    self.testNum = self.testNumField.text;
    self.password = self.passWordNumField.text;
    
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    dict[@"phoneNum"] = self.phoneNum;
    dict[@"password"] = self.password;
    
    
    [self showloadingName:@"正在验证"];
    if (self.vcType == Frist_RegisterVC) {
        
        [[AccountLogic sharedManager] logicTestCodeNext:self.phoneNum code:self.testNum password:self.password success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            
            NSDictionary *data =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
            if ([data[@"resultcode"] isEqualToString:@"0"]) {
                [self hideHud];
                NextRegisterViewController *nvc = [[NextRegisterViewController alloc] init];
                nvc.information = dict;
                [self.navigationController pushViewController:nvc animated:YES];
                
            } else if ([data[@"resultcode"] isEqualToString:@"1002"]) {
                [self showHint:@"账号已注册"];
            } else {
                [self showHint:data[@"resultmessage"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showHint:@"服务器异常,验证失败"];
        }];
        
        
        
    } else if (self.vcType == ForgetPassWord_ResetRegisterVC) {
        
        [[AccountLogic sharedManager] logicTestCodeWithForgetNext:self.phoneNum code:self.testNum password:self.password progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            NSDictionary *data =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
            if ([data[@"resultcode"] isEqualToString:@"0"]) {
                [self hideHud];
                
                [self showHint:@"修改密码成功,请重新登录"];
                [self performSelector:@selector(dissMissVC) withObject:nil afterDelay:1.0f];

                
            } else if ([data[@"resultcode"] isEqualToString:@"1024"]) {
                [self showHint:@"验证码错误"];
            } else {
                [self showHint:data[@"resultmessage"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showHint:@"服务器异常,验证失败"];
        }];
        
    }
    
    
}

- (void)dissMissVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textFieldrResignFirstResponder {
    [self.phoneNumField resignFirstResponder];
    [self.passWordNumField resignFirstResponder];
    [self.testNumField resignFirstResponder];
}


//- (void)testPhoneNum {
//    //手机号是否为空
//    if ([[LZXHelper isNullToString:self.phoneNumField.text] isEqualToString:@""]) {
//        [self showHint:@"请输入手机号码"];
//        return;
//    }
//    //手机号是否合法
//    if (![LZXHelper isMobileNumber:self.phoneNumField.text]) {
//        [self showHint:@"请输入正确的手机号"];
//        return;
//    }
//}

- (void)testNumClick {
    
    [self textFieldrResignFirstResponder];
    
    
//    self.testBtn.selected = !_testBtn.selected;
    [self requestTestNum];
    
//    [self receiveCheckNumButton];
    
//    if (!self.timer) {
////        [self creatTimer];
////        self.testBtn.selected = YES;
////        self.testBtn.enabled = NO;
////    
////            
////        self.testBtn.backgroundColor = CHCHexColor(@"cccccc");
////        [self.testBtn setTitleColor:[UIColor whiteColor]];
////        [self requestTestNum];
//        
//        self.testBtn.selected = YES;
//        self.testBtn.enabled = NO;
//
//
//        
//        [self requestTestNum];
//        
//
//    } else {
//        self.sec = 60;
//        self.testBtn.backgroundColor = zWhiteColor;
//        [self.testBtn setTitleColor:[UIColor blackColor]];
//        self.testBtn.selected = NO;
//        self.testBtn.enabled = YES;
//    }
    
}

- (void)receiveCheckNumButton{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置

                self.testBtn.text = @"获取验证码";
                self.testBtn.userInteractionEnabled = YES;
                self.testBtn.backgroundColor = [UIColor whiteColor];
                self.testBtn.textColor = [UIColor blackColor];

            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色

                [self.testBtn setBackgroundColor:CHCHexColor(@"cccccc")];
                self.testBtn.userInteractionEnabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];

                [self.testBtn setText:[NSString stringWithFormat:@"再次获取%@秒",strTime]];
                [self.testBtn setTextColor:[UIColor whiteColor]];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

// 请求验证码
- (void)requestTestNum {
    
//    [self testPhoneNum];
    //手机号是否为空
    if ([[LZXHelper isNullToString:self.phoneNumField.text] isEqualToString:@""]) {
        [self showHint:@"请输入手机号码"];
        return;
    }
    //手机号是否合法
    if (![LZXHelper isMobileNumber:self.phoneNumField.text]) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    
    self.phoneNum =  self.phoneNumField.text;
    
    
    [self showloadingName:@"正在获取验证码"];
    if (self.vcType == Frist_RegisterVC) {
        
        [[AccountLogic sharedManager] logicSendTestCode:self.phoneNum progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            NSDictionary *data =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
            if ([data[@"resultcode"] isEqualToString:@"0"]) {
                [self hideHud];
                [self showHint:@"获取验证码成功"];
                [self receiveCheckNumButton];
                
                
            } else if ([data[@"resultcode"] isEqualToString:@"isv.BUSINESS_LIMIT_CONTROL"]) {
                [self showHint:@"重复操作过多,请稍后再试"];

                self.testBtn.enabled = YES;
            } else {

                self.testBtn.enabled = YES;
                [self showHint:data[@"resultmessage"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showHint:@"服务器异常,获取验证码失败"];
        }];
        
    } else if (self.vcType == ForgetPassWord_ResetRegisterVC) {
        
        [[AccountLogic sharedManager] logicSendTestCodeWithForget:self.phoneNum progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            NSDictionary *data =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
            if ([data[@"resultcode"] isEqualToString:@"0"]) {
                
                [self hideHud];
                [self showHint:@"获取验证码成功"];
                [self receiveCheckNumButton];

            }  else if ([data[@"resultcode"] isEqualToString:@"isv.BUSINESS_LIMIT_CONTROL"]) {
                [self showHint:@"重复操作过多,请稍后再试"];

                self.testBtn.enabled = YES;
                
            } else {
                
                self.testBtn.enabled = YES;
                [self showHint:data[@"resultmessage"]];

            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showHint:@"服务器异常,获取验证码失败"];
        }];
        
    }
    
    


}


- (void)passNumClick {
    _eyeBtn.selected = !_eyeBtn.selected;
    self.passWardNumField.secureTextEntry = !self.passWardNumField.secureTextEntry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneNumField) {
//        [self testPhoneNum];
        [self.testNumField becomeFirstResponder];
    }
    else if (textField == self.testNumField) {
        [self.passWordNumField becomeFirstResponder];
    }
    else if (textField == self.passWordNumField) {
//        [self.passwordField becomeFirstResponder];
        [self textFieldReturn];
    }
    return YES;
}


- (void)textFieldReturn {
    
    if (![self.phoneNumField.text isEqualToString:@""]&&![self.testNumField.text isEqualToString:@""]&&![self.passWordNumField.text isEqualToString:@""]) {
        self.nextBtn.backgroundColor = zBlueColor;
        self.nextBtn.userInteractionEnabled = YES;
        self.nextBtn.enabled = YES;
        [self nextClick];
        
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //    if (![self.phoneNumField.text isEqualToString:@""]&&![self.testNumField.text isEqualToString:@""]&&![self.passWordNumField.text isEqualToString:@""]) {
    //        self.nextBtn.backgroundColor = zBlueColor;
    //    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [self textfieldObserverWithAllMessage];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self textfieldObserverWithAllMessage];
    
    if ([NSString containEmoji:string]) {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    return YES;
    
}

- (void)textfieldObserverWithAllMessage {
    if (![self.phoneNumField.text isEqualToString:@""]&&![self.testNumField.text isEqualToString:@""]&&![self.passWordNumField.text isEqualToString:@""]) {
        self.nextBtn.backgroundColor = zBlueColor;
        self.nextBtn.userInteractionEnabled = YES;
        self.nextBtn.enabled = YES;
    }
    else {
        self.nextBtn.backgroundColor = CHCHexColor(@"a6a6a6");
        self.nextBtn.userInteractionEnabled = NO;
        self.nextBtn.enabled = NO;
    }
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
