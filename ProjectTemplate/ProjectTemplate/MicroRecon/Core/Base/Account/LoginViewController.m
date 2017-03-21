//
//  LoginViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "TabBarViewController.h"
#import "AccountLogic.h"
#import "LoginResponseModel.h"
#import "FriendsModel.h"
#import "FriendsListModel.h"
#import "UnitRsultModel.h"
#import "UserInfoBaseModel.h"
#import "TeamsModel.h"
#import "QRCodeGenerator.h"
#import "RegisteredViewController.h"
#import "CUrlServer.h"

#import "RegisterViewController.h"

#import "LoginTextField.h"

#import "MBProgressHUD.h"

#define QRViewMargin 20
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface LoginViewController ()<UITextFieldDelegate> {

    dispatch_queue_t _q;
}
@property (nonatomic,strong)MBProgressHUD *hub;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic,strong)UIImageView *countIv;
@property (nonatomic,strong)UIImageView *passwordIv;
@property (nonatomic, strong) UILabel *iconLbl;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) LoginTextField *passwordField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *forgetBtn;


@property (nonatomic, strong) UILabel *line2;
@property (nonatomic, strong) UILabel *line3;
@property (nonatomic, strong) NSMutableArray *userAllArray;
@end

@implementation LoginViewController




#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _q = dispatch_queue_create("zlogin", DISPATCH_QUEUE_SERIAL);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.iconIv];
    [self.view addSubview:self.iconLbl];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.countIv];
    [self.view addSubview:self.passwordIv];

    [self.view addSubview:self.line2];
    [self.view addSubview:self.line3];
    self.view.backgroundColor =[UIColor colorWithHexString:@"2f4158"];
    
    [self makeConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)userAllArray {

    if (_userAllArray == nil) {
        _userAllArray = [NSMutableArray array];
    }
    return _userAllArray;
}
#pragma mark - Setter && Getter
// Icon图标
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [UIImageView new];
        _iconIv.image = [UIImage imageNamed:@"logo"];
    }
    return _iconIv;
}

// Icon名称
- (UILabel *)iconLbl {
    if (!_iconLbl) {
        _iconLbl = [UILabel new];
        _iconLbl.text = @"猎鹰";
        _iconLbl.font = [UIFont boldSystemFontOfSize:14.f];
        _iconLbl.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _iconLbl;
}

// 用户名输入框
- (UITextField *)usernameField {
    if (!_usernameField) {
        _usernameField = [UITextField new];
        _usernameField.placeholder = @"请输入警号/手机号/身份证号";
//        _usernameField.placeholder = @"请输入警号";
       [_usernameField setValue:[UIColor colorWithHexString:@"#808080"]forKeyPath:@"_placeholderLabel.textColor"];
        [_usernameField setFont:[UIFont systemFontOfSize:16]];
        _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameField.keyboardType = UIKeyboardTypeASCIICapable;
        _usernameField.borderStyle =  UITextBorderStyleNone;
        _usernameField.delegate = self;
        _usernameField.returnKeyType = UIReturnKeyNext;
        _usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:UIUseralarm];
        _usernameField.textColor = [UIColor colorWithHexString:@"808080"];
        
    }
    return _usernameField;
}

// 密码输入框
- (LoginTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [LoginTextField new];
        _passwordField.placeholder = @"请输入密码";
        [_passwordField setFont:[UIFont systemFontOfSize:16]];
        [_passwordField setValue:[UIColor colorWithHexString:@"808080"]forKeyPath:@"_placeholderLabel.textColor"];
        _passwordField.secureTextEntry = YES; // 掩码
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.keyboardType = UIKeyboardTypeDefault;
        _passwordField.returnKeyType = UIReturnKeyGo;
        _passwordField.borderStyle =  UITextBorderStyleNone;
        _passwordField.delegate = self;
        _passwordField.textColor = [UIColor colorWithHexString:@"808080"];
    }
    return _passwordField;
}

// 登录按钮
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        _loginBtn.titleLabel.font = ZEBFont(16);
        [_loginBtn.layer setMasksToBounds:YES];
        [_loginBtn.layer setCornerRadius:5.f];
        [_loginBtn setTitle:@"登\t\t录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"00aaee"];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)forgetBtn{

    if (!_forgetBtn){
        _forgetBtn =[UIButton new];
        _forgetBtn.titleLabel.font = ZEBFont(14);
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor colorWithHexString:@"a2a2a2"]];
        [_forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetBtn;
}

// 注册按钮
- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_registerBtn setTitleColor:[UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1] forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font =[UIFont systemFontOfSize:16];
        [_registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(resisterBtn) forControlEvents:UIControlEventTouchUpInside];
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"a2a2a2"]];
        [_registerBtn setBackgroundColor:[UIColor colorWithHexString:@"445469"]];
    }
    return _registerBtn;
}

//-(UILabel *)line1
//{
//    if (!_line1)
//    {
//        _line1 = [UILabel new];
//        _line1.backgroundColor =[UIColor colorWithHexString:@"2a3a4f"];
//    }
//    return _line1;
//
//}

-(UILabel *)line2
{
    if (!_line2)
    {
        _line2 = [UILabel new];
        _line2.backgroundColor =[UIColor colorWithHexString:@"2a3a4f"];
    }
    return _line2;
    
}
-(UILabel *)line3
{
    if (!_line3)
    {
        _line3 = [UILabel new];
        _line3.backgroundColor =[UIColor colorWithHexString:@"2a3a4f"];
    }
    return _line3;
    
}

-(UIImageView *)countIv
{
    if (!_countIv)
    {
        _countIv = [UIImageView new];
        _countIv.image = [UIImage imageNamed:@"count-14"];
    }
    return _countIv;

}

-(UIImageView *)passwordIv
{
    if (!_passwordIv)
    {
        _passwordIv = [UIImageView new];
        _passwordIv.image = [UIImage imageNamed:@"lock-icon"];
    }
    return _passwordIv;
    
}

#pragma mark - Masonry
- (void)makeConstraints {
    CGFloat leftMargin = 45.f;
    CGFloat rightMargin = 24.f;
    NSNumber *height = @36;
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(110);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(12.5);
        make.size.mas_equalTo(CGSizeMake(110, 115));
    }];
    
    [self.iconLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.countIv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconLbl.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(leftMargin);
        make.height.offset(18);
        make.width.offset(18);
        
    }];
    
    [self.passwordIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countIv.mas_bottom).offset(34);
        make.left.equalTo(self.view).offset(leftMargin);
        make.height.offset(18);
        make.width.offset(18);
        
    }];
    
    
    
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.countIv.mas_right).offset(24);
        make.centerY.equalTo(self.countIv.mas_centerY);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(55);
//        make.width.offset(231);
    }];
    

    
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).offset(-0.5);
        make.left.right.width.equalTo(self.usernameField);
        make.height.offset(1);
        
    }];
    
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordIv.mas_right).offset(24);
        make.centerY.equalTo(self.passwordIv.mas_centerY);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(55);
//        make.width.offset(231);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(-1);
        make.left.right.width.equalTo(self.passwordField);
        make.height.offset(1);
        
        
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(36);
        make.right.equalTo(self.view).offset(-36);
        make.height.mas_equalTo(45);
    }];
    
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.loginBtn.mas_bottom).offset(19);
        make.left.offset(35);
        make.height.offset(30);
        make.width.offset(70);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.and.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(45);
    }];
    
}




#pragma mark - Selector

- (void)hiddenKeyboard {
    [self.view endEditing:YES];
}

- (void)login {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if (username == nil || username.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入警号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        [self showHint:@"请输入警号"];
        return;
    } else if (password == nil || password.length == 0) {
        [self showHint:@"请输入密码"];
        return;
    }
    [self showLoginLoading];
    [self showLoginLoadingName:@"正在登录"];
    
    
    [[AccountLogic sharedManager] logicLogin:username password:password progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        LoginResponseModel *model = [LoginResponseModel LoginWithData:response];
        if (model && [@"0" isEqualToString:model.resultcode] &&
            model.results && model.results.count) {
            [self savaUserInfo:model.results[0]];
//            [self hideHud];
            [self httpGtUserDesInfo];

        }else if ([@"1001" isEqualToString:model.resultcode]){
            [self hideHud];
            [self showHint:@"帐号正在审核"];
        
        }else if ([model.resultcode isEqualToString:@"1008"]){
            [self hideHud];
            [self showHint:@"用户名或密码错误"];
        }else {
            [self showHint:model.resultmessage];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZEBLog(@"loginerror-------%@",[error description]);
        [self showHint:@"登录异常"];
    }];
    
}
//忘记密码
-(void)forgetBtnClick
{
    RegisterViewController *resister = [[RegisterViewController alloc] init];
    resister.vcType = ForgetPassWord_ResetRegisterVC;
    [self.navigationController pushViewController:resister animated:YES];
}

#pragma mark -
#pragma mark 注册
- (void)resisterBtn {

//    RegisteredViewController *resister = [[RegisteredViewController alloc] init];

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:resister];
    
//    [self presentViewController:nav animated:YES completion:^{
//    
//    }];
    RegisterViewController *resister = [[RegisterViewController alloc] init];
    resister.vcType = Frist_RegisterVC;
    [self.navigationController pushViewController:resister animated:YES];
    

    
}
#pragma mark - Private Methods
// 保存登录后服务器返回的用户信息
- (void)savaUserInfo:(Login * _Nonnull)userInfo {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userInfo.alarm forKey:UserUUID];
    [user setObject:userInfo.headpic forKey:@"headpic"];
    [user setObject:userInfo.token forKey:@"token"];
    [user setObject:userInfo.name forKey:@"name"];
    [user setObject:userInfo.alarm forKey:@"alarm"];
    [user setObject:userInfo.useralarm forKey:UIUseralarm];
    
    
    NSString *osInfo = [[UIDevice currentDevice] systemVersion];
    NSString *deviceInfo = [[UIDevice currentDevice] model];
    [user setObject:osInfo forKey:@"OSInfo"];
    [user setObject:deviceInfo forKey:@"DeviceInfo"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //切换帐号
    [ZEBDatabaseHelper refreshDatabaseFile];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passwordField) {
        [self login];
    }
    else if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([NSString containEmoji:string]) {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    return YES;
}


#pragma mark 请求好友列表数据
- (void)httpGetInfo {
    
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    //组织列表的数据库数据清空
    [[DBManager sharedManager] eraseTable:@"tb_departmentlist"];
    [self showLoginLoadingName:@"正在加载单位列表数据"];
    [HYBNetworking getWithUrl:[NSString stringWithFormat:UnitList_URL,alarm,token] refreshCache:YES success:^(id response) {
        // ZEBLog(@"---%@",[NSString stringWithFormat:UnitList_URL,alarm,token]);
        UnitRsultModel *model = [UnitRsultModel getInfoWithData:response[@"response"]];
        [self.userAllArray addObjectsFromArray:model.userall];
        
        //缓存所有成员头像
        [self cacheAllImage];
        
        dispatch_sync(_q, ^{
            //事务插入
            [[[DBManager sharedManager] DepartmentlistSQ] transactionInsertDepartmentlist:model.departall];
            
        });
        dispatch_sync(_q, ^{
            //事务插入
            [[[DBManager sharedManager] personnelInformationSQ] transactionInsertPersonnelInformationOfUserAllModel:model.userall];
        });
//        [self hideHud];
        
        [self httpFriendListInfo];

    } fail:^(NSError *error) {
        [self showHint:@"加载单位列表数据失败"];
    }];
    
}


- (void)httpFriendListInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:FriendsLise_URL,alarm,@"1",alarm,token];
    
    [self showLoginLoadingName:@"正在加载好友列表数据"];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        FriendsModel *model = [FriendsModel getInfoWithData:(NSDictionary *)response];
        //事务插入
        dispatch_sync(_q, ^{
            //事务插入
            [[[DBManager sharedManager] personnelInformationSQ] transactionInsertPersonnelInformationOfFriendsListModel:model.results];
            ZEBLog(@"---------%@",urlString);
        });
//        [self hideHud];
        [self httpGetGroupInfo];
        
    } fail:^(NSError *error) {
        [self showHint:@"加载好友列表数据失败"];
    }];
    
    
}

#pragma mark -
#pragma mark 请求个人信息
- (void)httpGtUserDesInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GtUserDesInfoUrl,alarm,token];
    
    ZEBLog(@"%@",urlString);
    [self showLoginLoadingName:@"正在加载个人详情数据"];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        UserInfoBaseModel *baseModel = [UserInfoBaseModel getInfoWithData:response];
        dispatch_sync(_q, ^{
            [[[DBManager sharedManager] userDetailSQ] insertUserDetail:baseModel.results[0]];
            ZEBLog(@"---------1");
        });
//        [self hideHud];
        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate startNStimer];
//        [appDelegate sendHeart];
        [self httpGetInfo];
        [self userQRCode];
        
        
    } fail:^(NSError *error) {
        
        [self showHint:@"加载个人详情数据失败"];
    }];
    
}
//用户个人二维码保存本地
- (void)userQRCode {
//    [self showloadingName:@"缓存二维码"];
    NSString *type = @"1";
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *qrStr =  [NSString stringWithFormat:@"{\"key\":\"%@\",\"type\":\"%@\"}",alarm,type];
    UIImage *qrImage = [QRCodeGenerator qrImageForString:qrStr imageSize:self.view.width - 40 - QRViewMargin * 4];
    [ZEBCache nyCodeCacheImage:qrImage alarm:alarm];
//    [self hideHud];
}
#pragma mark -
#pragma mark 请求群组列表数据
- (void)httpGetGroupInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:TeamList_URL,alarm,token];
    
    ZEBLog(@"%@",urlString);
    [self showLoginLoadingName:@"正在加载群组列表数据"];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        
        TeamsModel *model = [TeamsModel getInfoWithData:(NSDictionary *)response];
        
        dispatch_sync(_q, ^{
            //事务插入
            [[[DBManager sharedManager] GrouplistSQ] transactionInsertGrouplist:model.results];
            ZEBLog(@"---------5");
        });
        [self hideHud];
        
        [self showHint:@"登陆成功" Time:0.6];
        [self performSelector:@selector(LoginMainVC) withObject:nil afterDelay:1.5];
        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate startNStimer];
//        [appDelegate sendHeart];
//        appDelegate.tabbar = [TabBarViewController new];
//        self.view.window.rootViewController = appDelegate.tabbar;

    } fail:^(NSError *error) {
        [self showHint:@"加载群组列表数据失败"];
    }];
    
}

- (void)LoginMainVC {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startNStimer];
    [appDelegate sendHeart];
    appDelegate.tabbar = [TabBarViewController new];
    self.view.window.rootViewController = appDelegate.tabbar;
}
- (void)cacheAllImage {
//    [self showloadingName:@"缓存图片中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (UserAllModel *model in self.userAllArray) {
            dispatch_queue_t qs = dispatch_queue_create("loadImage", DISPATCH_QUEUE_SERIAL);
            dispatch_async(qs, ^{
             UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.RE_headpic]]];
                [ZEBCache imageCacheUrlString:image alarm:model.RE_alarmNum];
            });
        }
    });
//    [self hideHud];
}

- (void)showLoginLoading{
    UIView *view =[[ UIApplication sharedApplication].delegate window];
    self.hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hub.minSize = CGSizeMake(210, 100);
    self.hub.labelFont = [UIFont systemFontOfSize:14];
    self.hub.labelColor = CHCHexColor(@"000000");
    self.hub.mode = MBProgressHUDModeCustomView;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.color = [UIColor blackColor];
    self.hub.customView = indicatorView;
    [indicatorView startAnimating];
    self.hub.activityIndicatorColor = [UIColor blackColor];
    self.hub.detailsLabelColor = [UIColor blackColor];
    self.hub.margin = 14.f;
    
    self.hub.backgroundColor = [UIColor colorWithColor:CHCHexColor(@"000000") alpha:0.3];
    self.hub.color = [UIColor whiteColor];
    self.hub.removeFromSuperViewOnHide = YES;
    [self.hub hide:YES afterDelay:30];
    
    [self.hub removeFromSuperViewOnHide];
    [self setHUD:self.hub];
}

- (void)showLoginLoadingName:(NSString *)loadingName {
    self.hub.labelText = loadingName;
}



- (void)hideHud{
    [[self HUD] hide:YES];
}

@end
