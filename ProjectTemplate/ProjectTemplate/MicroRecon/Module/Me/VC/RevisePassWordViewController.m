//
//  RevisePassWordViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/24.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "RevisePassWordViewController.h"
#import "RevisePassWordRequest.h"
#import "ChatLogic.h"
#import "CUrlServer.h"
#import "AccountLogic.h"
#import "LoginViewController.h"

@interface RevisePassWordViewController ()<UITextFieldDelegate>

//@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *firstView;
@property (nonatomic,strong)UITextField *oldPassWord;
@property (nonatomic,strong)UITextField *newPassWord;
@property (nonatomic,strong)UITextField *sureNewPassWord;
@property (nonatomic,strong)UIButton *sureBtn;

@property (nonatomic,copy)NSArray *dataArray;

@end


@implementation RevisePassWordViewController

- (UIView *)firstView {
    if (!_firstView) {
        _firstView = [UIView new];
        _firstView.backgroundColor = zWhiteColor;
    }
    return _firstView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = ZEBFont(14);
        _sureBtn.backgroundColor = zBlueColor;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 5;
//        UIBezierPath *maskpath = [UIBezierPath bezierPathWithRoundedRect:_sureBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//        CAShapeLayer *shapelayer = [[CAShapeLayer alloc] init];
//        shapelayer.frame = _sureBtn.frame;
//        shapelayer.path = maskpath.CGPath;
//        shapelayer.backgroundColor = zBlueColor.CGColor;
//        _sureBtn.layer.mask = shapelayer;
        [_sureBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UITextField *)oldPassWord {
    if (!_oldPassWord) {
        _oldPassWord = [[UITextField alloc] init];
        _oldPassWord.keyboardType = UIKeyboardTypeASCIICapable;
        _oldPassWord.delegate = self;
        _oldPassWord.placeholder = self.dataArray[0];
        _oldPassWord.font = ZEBFont(14);
        _oldPassWord.textColor = zBlackColor;//CHCHexColor(@"a6a6a6")
        _oldPassWord.secureTextEntry = YES;
        [_oldPassWord setValue:zGrayColor forKeyPath:@"placeholderLabel.textColor"];
    }
    return _oldPassWord;
}

- (UITextField *)newPassWord {
    if (!_newPassWord) {
        _newPassWord = [[UITextField alloc] init];
        _newPassWord.keyboardType = UIKeyboardTypeASCIICapable;
        _newPassWord.delegate = self;
        _newPassWord.placeholder = self.dataArray[1];
        _newPassWord.font = ZEBFont(14);
        _newPassWord.textColor = zBlackColor;
        _newPassWord.secureTextEntry = YES;
        [_newPassWord setValue:zGrayColor forKeyPath:@"placeholderLabel.textColor"];
    }
    return _newPassWord;
}

- (UITextField *)sureNewPassWord {
    if (!_sureNewPassWord) {
        _sureNewPassWord = [[UITextField alloc] init];
        _sureNewPassWord.keyboardType = UIKeyboardTypeASCIICapable;
        _sureNewPassWord.delegate = self;
        _sureNewPassWord.placeholder = self.dataArray[2];
        _sureNewPassWord.font = ZEBFont(14);
        _sureNewPassWord.textColor = zBlackColor;
        _sureNewPassWord.secureTextEntry = YES;
        [_sureNewPassWord setValue:zGrayColor forKeyPath:@"placeholderLabel.textColor"];
    }
    return _sureNewPassWord;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"旧密码",@"新密码",@"确认密码"];
    }
    return _dataArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initAll];
    // Do any additional setup after loading the view.
}

- (void)initAll {
    
    CGFloat height = 45;
    
    [self.view addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(10+64);
        make.size.mas_equalTo(CGSizeMake(screenWidth(),height*3));
    }];
    
    [self.firstView addSubview:self.oldPassWord];
    [self.oldPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView.mas_left).offset(12);
        make.top.equalTo(self.firstView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(screenWidth(), height-0.5));
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView.mas_left).offset(12);
        make.right.equalTo(self.firstView.mas_right).offset(0);
        make.top.equalTo(self.oldPassWord.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.firstView addSubview:self.newPassWord];
    [self.newPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView.mas_left).offset(12);
        make.top.equalTo(self.firstView.mas_top).offset(height);
        make.size.mas_equalTo(CGSizeMake(screenWidth(), height-0.5));
    }];
    
    UILabel *line2 = [UILabel new];
    line2.backgroundColor = LineColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView.mas_left).offset(12);
        make.right.equalTo(self.firstView.mas_right).offset(0);
        make.top.equalTo(self.newPassWord.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.firstView addSubview:self.sureNewPassWord];
    [self.sureNewPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstView.mas_left).offset(12);
        make.top.equalTo(self.firstView.mas_top).offset(height*2);
        make.size.mas_equalTo(CGSizeMake(screenWidth(), height-0.5));
    }];
    
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.equalTo(self.firstView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(screenWidth()-24, 40));
    }];


}

- (void)btnClick {
    
    [self.view endEditing:YES];
    if (![LZXHelper validatePassWord:_newPassWord.text]) {
        [self showHint:@"密码格式错误,请重新输入密码"];
        return;
    }
    if (![LZXHelper validatePassWord:_sureNewPassWord.text]) {
        [self showHint:@"密码格式错误,请重新输入密码"];
        return;
    }
    if (![_newPassWord.text isEqualToString:_sureNewPassWord.text]) {
        [self showHint:@"密码输入不相同,请重新输入密码"];
        return;
    }
    
    [self reuqestData];

}

- (void)reuqestData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"oldpasswd"] = self.oldPassWord.text;
    param[@"newpasswd"] = self.newPassWord.text;
    param[@"confirmpasswd"] = self.sureNewPassWord.text;
    
    [RevisePassWordRequest revisePasswordWithParam:param success:^(id  _Nullable reponse) {
        if ([reponse isKindOfClass:[NSDictionary class]]) {
            if ([reponse[@"resultcode"] isEqualToString:@"0"]) {
                [self showHint:@"修改密码成功"];
                [self performSelector:@selector(resetloginIn) withObject:nil afterDelay:0.5];
            }else {
                [self showHint:@"修改密码失败"];
            }
        }else {
             [self showHint:@"修改密码失败"];
        }
//      ZEBLog(@"reponse:%@",reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"连接服务器失败"];
    }];
}
#pragma mark -
#pragma mark 重新登陆
- (void)resetloginIn {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[AccountLogic sharedManager] logicLogout:alarm token:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        //退出登录
        [self loginOut];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}
//退出登录
- (void)loginOut {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
    [self switchpushForCurl];
    
    [[CUrlServer sharedManager] cUrlCleanup];
    [DBManager closeDB];
    
    //便于建立新的长链接
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:NOTfirst];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.view.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate stopNStimer];
    
    if (appDelegate.tabbar) {
        appDelegate.tabbar = nil;
    }
}
- (void)switchpushForCurl
{
    [[ChatLogic sharedManager] switchPushLogicWithPushType:@"0" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        NSLog(@"消息切换成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"消息切换失败 error:%@",error);
    }];
}
#pragma mark textFieldDelegate
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
