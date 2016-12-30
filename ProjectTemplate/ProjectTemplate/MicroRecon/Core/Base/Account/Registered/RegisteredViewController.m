//
//  RegisteredViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "RegisteredViewController.h"
#import "UIButton+Layout.h"
#import "SelectPosition.h"
#import "DJGetPicture.h"
#import "LZXHelper.h"
#import "TreeTableViewController.h"
#import "Common.h"
#import "UploadModel.h"

#define LeftMargin 20


@interface RegisteredViewController ()<UIScrollViewDelegate, SelectPositionDelegate,UITextFieldDelegate,TreeTableViewControllerDelegate> {
    
    
    UIScrollView *_bgScrollView;
    UIView *_topView;
    UIView *_bottomView;
    UITextField *_alarmTextField;
    UITextField *_nameTextField;
    UITextField *_IDCardTextField;
    UITextField *_MobilePhoneTextField;
    UILabel *_unitLabel;
    UITextField *_phoneTextField;
    UITextField *_passwordTextField;
    UITextField *_confirmPasswordTextField;
    UIButton *_positionBtn;
    UILabel *_positionLabel;
//    UIButton *_manBtn;
//    UIButton *_womanBtn;
}

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSInteger sex;// 0 女  1 男

@property (nonatomic,strong) UIImage *headImage;

@property(nonatomic,copy) NSString *unitID;//部门id

@property(nonatomic,copy) NSString *headPicPath;//图片返回地址

@property(nonatomic,copy) NSString *positionNum;

@end



@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"注册";

    [self initall];
}

- (void)initall {
    [self setLeftNavbar];
    [self createBgScrollView];
    [self createUI];
}

- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
//        _titleArray = @[@"警        号",@"姓        名",@"性        别",@"身份证号",@"手机号码",@"单        位",@"单位电话",@"职        务",@"密        码",@"确认密码"];
        _titleArray = @[@"警        号",@"姓        名",@"身份证号",@"手机号码",@"单        位",@"单位电话",@"职        务",@"密        码",@"确认密码"];
    }
    return _titleArray;
}
- (void)setLeftNavbar {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 19, 19);
    [btn setBackgroundImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
}
- (void)backBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark 创建底层ScrollView
- (void)createBgScrollView {
    
    _bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _bgScrollView.delegate = self;
    _bgScrollView.directionalLockEnabled = YES;
    
    [self.view addSubview:_bgScrollView];
    
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
}
//解决UIScrollView不滚的问题
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //    120+40+500+60
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight+(kScreenHeight)/2);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self textFieldresignFirstResponder];
}
- (void)createUI {
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_topView];
    
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_bottomView];
    
    UIButton *resisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resisterBtn.layer.masksToBounds = YES;
    resisterBtn.layer.cornerRadius = 5;
    [resisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [resisterBtn setBackgroundColor:zBlueColor];
    resisterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    resisterBtn.titleLabel.font = ZEBFont(18);
    [resisterBtn addTarget:self action:@selector(resister) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:resisterBtn];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgScrollView.mas_top).offset(16);
        make.left.equalTo(_bgScrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100));
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(16);
        make.left.equalTo(_bgScrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 500));
    }];
    [resisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_bottom).offset(30);
        make.left.equalTo(_bgScrollView).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40, 45));
    }];
    
    
    
    
    UIButton *addTXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addTXBtn setImage:[UIImage imageNamed:@"select_img_icon"] forState:UIControlStateNormal];
    [addTXBtn addTarget:self action:@selector(addTXImage:) forControlEvents:UIControlEventTouchUpInside];
    addTXBtn.layer.cornerRadius = 5;
    addTXBtn.layer.masksToBounds = YES;
    [_topView addSubview:addTXBtn];
    
    UILabel *addTXLabel = [[UILabel alloc] init];
    addTXLabel.text = @"点击上传头像";
    addTXLabel.textColor  = [UIColor grayColor];
    addTXLabel.textAlignment = NSTextAlignmentCenter;
    addTXLabel.font = ZEBFont(13);
    [_topView addSubview:addTXLabel];
    
    
    [addTXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_topView);
        make.size.mas_equalTo(CGSizeMake(55, 55));
        
    }];
    [addTXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addTXBtn.mas_bottom).offset(5);
        make.centerX.equalTo(addTXBtn.mas_centerX);
    }];
    
    NSInteger count = self.titleArray.count;
    for (int i = 0; i < count; i++) {
        NSString *titleStr = self.titleArray[i];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = ZEBFont(15);
        titleLab.text = titleStr;
        [_bottomView addSubview:titleLab];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.5;
        [_bottomView addSubview:line];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44.5);
            make.left.equalTo(_bottomView).offset(LeftMargin);
            make.top.equalTo(_bottomView).offset(45*i);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom);
            make.left.equalTo(_bgScrollView).offset(LeftMargin);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
        }];
    }
    //警号
    _alarmTextField = [[UITextField alloc] init];
    _alarmTextField.backgroundColor = [UIColor whiteColor];
    _alarmTextField.tintColor = zBlueColor;
    _alarmTextField.returnKeyType=UIReturnKeyDone;
    _alarmTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _alarmTextField.delegate=self;
    [_bottomView addSubview:_alarmTextField];
    
    
    //姓名
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.tintColor = zBlueColor;
    _nameTextField.delegate=self;
    _nameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _nameTextField.returnKeyType=UIReturnKeyDone;
    [_bottomView addSubview:_nameTextField];
    //性别
//    _manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_manBtn setTitle:@"男" forState:UIControlStateNormal];
//    [_manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_manBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateSelected];
//    _manBtn.selected=YES;
//    self.sex = 1;
//    [_manBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
//    [_manBtn layoutButtonForTitle:@"男" titleFont:ZEBFont(13) image:[UIImage imageNamed:@"RadioButton"] gapBetween:10 layType:1];
//    [_manBtn layoutButtonForTitle:@"男" titleFont:ZEBFont(13) image:[UIImage imageNamed:@"RadioButtonSelected"] gapBetween:10 layType:1];
//    
//    [_manBtn addTarget:self action:@selector(selectmanBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_manBtn];
    
//    _womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
//    [_womanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_womanBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateSelected];
//    [_womanBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
//    [_womanBtn layoutButtonForTitle:@"女" titleFont:ZEBFont(13) image:[UIImage imageNamed:@"RadioButton"] gapBetween:10 layType:1];
//    [_womanBtn layoutButtonForTitle:@"女" titleFont:ZEBFont(13) image:[UIImage imageNamed:@"RadioButtonSelected"] gapBetween:10 layType:1];
//    
//    [_womanBtn addTarget:self action:@selector(selectWomamBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_womanBtn];
    
    //身份证号
    _IDCardTextField = [[UITextField alloc] init];
    _IDCardTextField.backgroundColor = [UIColor whiteColor];
    _IDCardTextField.tintColor = zBlueColor;
    _IDCardTextField.delegate=self;
    _IDCardTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _IDCardTextField.returnKeyType=UIReturnKeyDone;
    [_bottomView addSubview:_IDCardTextField];
    
    
    //手机号
    _MobilePhoneTextField = [[UITextField alloc] init];
    _MobilePhoneTextField.backgroundColor = [UIColor whiteColor];
    _MobilePhoneTextField.tintColor = zBlueColor;
    _MobilePhoneTextField.delegate=self;
    _MobilePhoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    _MobilePhoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _MobilePhoneTextField.returnKeyType=UIReturnKeyDone;
    [_bottomView addSubview:_MobilePhoneTextField];
    
    
    //单位
    _unitLabel = [[UILabel alloc] init];
    _unitLabel.backgroundColor = [UIColor whiteColor];
    _unitLabel.textColor = [UIColor blackColor];
    _unitLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOR:)];
    [_unitLabel addGestureRecognizer:tap];
    _unitLabel.text = @"选择单位";
    _unitLabel.font = ZEBFont(15);
    [_bottomView addSubview:_unitLabel];
    
    UIImageView *jtImageView = [[UIImageView alloc] init];
    jtImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOR:)];
    [jtImageView addGestureRecognizer:tap2];
    jtImageView.image  = [UIImage imageNamed:@"personal"];
    [_bottomView addSubview:jtImageView];
    
    
    //单位电话
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.backgroundColor = [UIColor whiteColor];
    _phoneTextField.tintColor = zBlueColor;
    _phoneTextField.delegate=self;
    _phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _phoneTextField.returnKeyType=UIReturnKeyDone;
    [_bottomView addSubview:_phoneTextField];
    //职务
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.text = @"请选择职务";
    _positionLabel.textColor = [UIColor blackColor];
    _positionLabel.font = ZEBFont(15);
    [_bottomView addSubview:_positionLabel];
    
    _positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_positionBtn setImage:[UIImage imageNamed:@"itemleft"] forState:UIControlStateNormal];
    [_positionBtn addTarget:self action:@selector(selectPosition:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_positionBtn];
    
    //密码
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.tintColor = zBlueColor;
    _passwordTextField.delegate=self;
    _passwordTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTextField.returnKeyType=UIReturnKeyDone;
    [_bottomView addSubview:_passwordTextField];
    
    
    //确认密码
    _confirmPasswordTextField = [[UITextField alloc] init];
    _confirmPasswordTextField.backgroundColor = [UIColor whiteColor];
    _confirmPasswordTextField.tintColor = zBlueColor;
    _confirmPasswordTextField.delegate=self;
    _confirmPasswordTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _confirmPasswordTextField.returnKeyType=UIReturnKeyDone;
    [_bottomView addSubview:_confirmPasswordTextField];
    
    
    
    [_alarmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView);
        make.right.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*1);
        make.right.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
//    [_manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomView).offset(45*2);
//        make.left.equalTo(_bottomView).offset(LeftMargin+100);
//        make.size.mas_equalTo(CGSizeMake(80, 44.5));
//    }];
//    [_womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomView).offset(45*2);
//        make.left.equalTo(_manBtn.mas_right).offset(LeftMargin);
//        make.size.mas_equalTo(CGSizeMake(80, 44.5));
//        
//    }];
    [_IDCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*2);
        make.right.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
    
    [_MobilePhoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*3);
        make.right.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*4);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.right.equalTo(_bottomView.mas_right).offset(-45);
        make.height.mas_equalTo(@44.5);
    }];
    [jtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*4+10);
        make.right.equalTo(_bottomView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*5);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.right.equalTo(_bottomView);
        make.height.mas_equalTo(@44.5);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*6);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
    [_positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*6);
        make.right.equalTo(_bottomView).offset(-20);
        make.height.mas_equalTo(@44.5);
    }];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*7);
        make.right.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
    
    [_confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(45*8);
        make.right.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(LeftMargin+80);
        make.height.mas_equalTo(@44.5);
    }];
}
#pragma mark -
#pragma mark 添加头像
- (void)addTXImage:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;
    [DJGetPicture shareGetPicture:^(UIImage *image) {
        self.headImage=image;
        [btn setImage:image forState:UIControlStateNormal];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.99);
        if (image.size.width > 720.0f && [imageData length] > 10 * 1024) {
            //image = [image scaleImage:720.0f/image.size.width];
            image =[image imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
            imageData = UIImageJPEGRepresentation(image, 0.99);
        }
        if ([imageData length] > 10 * 1024) {
            imageData = UIImageJPEGRepresentation(image, 10 * 1024 / [imageData length]);
        }
        
        [weakSelf httpUploadImages:[UIImage imageWithData:imageData]];
        
    } controller:self];
}

- (void)httpUploadImages:(UIImage *)image {
    [self showloadingName:@"正在上传图片..."];
    
    [[HttpsManager sharedManager]uploadTwo:image progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        [self hideHud];
        
        UploadModel *model = [UploadModel uploadWithData:reponse];
        self.headPicPath= model.url;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //    [[HttpsManager sharedManager] upload:image progress:^(NSProgress * _Nonnull progress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
    //        [self hideHud];
    //
    //        UploadModel *model = [UploadModel uploadWithData:reponse];
    //        self.headPicPath= model.url;
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //    }];
    
}


#pragma mark -
#pragma mark 选择性别
//- (void)selectmanBtn:(UIButton *)btn {
//    
//    
//    if (btn.selected) {
//        btn.selected = NO;
//        
//    }else {
//        btn.selected = YES;
//        _womanBtn.selected = NO;
//        self.sex = 1;
//    }
//}
//- (void)selectWomamBtn:(UIButton *)btn {
//    
//    
//    if (btn.selected) {
//        btn.selected = NO;
//        
//    }else {
//        btn.selected = YES;
//        _manBtn.selected = NO;
//        self.sex = 0;
//    }
//    
//}
#pragma mark -
#pragma mark 选单位
- (void)chooseOR:(UITapGestureRecognizer *)recognizer {
    
    [self textFieldresignFirstResponder];
    
    TreeTableViewController *treeTableViewController = [[TreeTableViewController alloc] init];
    treeTableViewController.delegate = self;
    [self.navigationController pushViewController:treeTableViewController animated:YES];
    
    
}
#pragma mark -
#pragma mark 选择职位
- (void)selectPosition:(UIButton *)btn {
    [self textFieldresignFirstResponder];
    SelectPosition *sPosition = [SelectPosition sigle];
    sPosition.delegate = self;
    [sPosition show];
    
}
- (void)selectThePosition:(NSString *)position positionNum:(NSString *)positionNum {
    
    _positionLabel.text = position;
    self.positionNum=positionNum;
}

#pragma mark -
#pragma mark 选择单位


-(void)selectUnit:(TreeTableViewController *)con orgStr:(NSString *)orgStr orgID:(NSString *)orgID{
    _unitLabel.text=orgStr;
    self.unitID=orgID;
    
    
}
//注册
-(void)resister{
    [self textFieldresignFirstResponder];
    if (self.headImage==nil) {
        [self showHint:@"请选择头像"];
        return;
    }
    if (_alarmTextField.text==nil || [_alarmTextField.text isEqualToString:@""]) {
        [self showHint:@"请填写警号"];
        return;
    }else{
        if (![LZXHelper validateAccountNum:_alarmTextField.text]) {
            [self showHint:@"警号填写有误"];
            return;
        }
    }
    if (_nameTextField.text==nil||[_nameTextField.text isEqualToString:@""]) {
        [self showHint:@"姓名不能为空"];
        return;
    }
    if (_IDCardTextField.text==nil || [_IDCardTextField.text isEqualToString:@""]) {
        [self showHint:@"身份证号不能为空"];
        return;
    }else{
        if (![LZXHelper validateIdentityCard:_IDCardTextField.text]) {
            [self showHint:@"身份证号填写错误"];
            return;
        }
    }
    if (_MobilePhoneTextField.text==nil || [_MobilePhoneTextField.text isEqualToString:@""]) {
        [self showHint:@"手机号不能为空"];
        return;
    }else{
        if (![LZXHelper isMobileNumber:_MobilePhoneTextField.text]) {
            [self showHint:@"手机号码填写有误"];
            return;
        }
    }
    if (self.unitID==nil ||[self.unitID isEqualToString:@""]) {
        
        [self showHint:@"请选择单位"];
        return;
    }
    
    if (self.positionNum==nil||[self.positionNum isEqualToString:@""]) {
        [self showHint:@"请选择职务"];
        return;
    }
    
    if (_phoneTextField.text==nil || [_phoneTextField.text isEqualToString:@""]) {
        [self showHint:@"单位电话不能为空"];
        return;
    }else{
        if (![LZXHelper isTelephoneNumber:_phoneTextField.text]) {
            [self showHint:@"电话号码填写有误"];
            return;
        }
    }
    if (_positionLabel.text==nil||[_positionLabel.text isEqualToString:@""]) {
        [self showHint:@"请选择职务"];
        return;
    }
    if (_passwordTextField.text==nil||[_passwordTextField.text isEqualToString:@""]) {
        [self showHint:@"密码不能为空"];
        return;
    }else{
        if (![LZXHelper validateAccountNum:_passwordTextField.text]) {
            [self showHint:@"密码格式错误"];
            return;
        }
    }
    
    if (_confirmPasswordTextField.text==nil||[_confirmPasswordTextField.text isEqualToString:@""]) {
        [self showHint:@"确认密码不能为空"];
        return;
    }else{
        if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
            
            [self showHint:@"密码不一致"];
            return;
        }
        
    }
    
    self.sex = (NSInteger)[LZXHelper isManOrWomanWithValidateIdentityCard:_IDCardTextField.text];
    
    NSMutableDictionary *dict=[NSMutableDictionary new];
    dict[@"picture"]=self.headPicPath;
    dict[@"action"]=@"register";
    dict[@"alarm"]=_alarmTextField.text;
    dict[@"name"]=_nameTextField.text;
    dict[@"sex"]=@(self.sex);
    dict[@"identitycard"]=_IDCardTextField.text;
    dict[@"phonenum"]=_MobilePhoneTextField.text;
    dict[@"department"]=self.unitID;
    dict[@"workphone"]=_phoneTextField.text;
    dict[@"post"]=self.positionNum;
    dict[@"passwd"]=_passwordTextField.text;
    dict[@"confirmpasswd"]=_confirmPasswordTextField.text;
    dict[@"serialnumber"]=@"";
    
    
    __block typeof(self) weakSelf=self;
    [self showloadingName:@"正在提交"];
    [[HttpsManager sharedManager]post:RegisterUserInfo parameters:dict progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
       // NSLog(@"%@",reponse);
        BaseResponseModel *message=[BaseResponseModel ResponseWithData:reponse];
        //NSLog(@"%@%@",message.resultmessage,message.resultcode);
        
        if ([message.resultcode integerValue]==0&&[message.resultmessage isEqualToString:@"成功"]){
            [weakSelf showHint:@"注册成功"];
            
            [weakSelf performSelector:@selector(backLogin) withObject:nil afterDelay:1.5f];
        }
        
        else if ([message.resultcode integerValue]==1002) {
            [weakSelf showHint:@"已经注册"];
        }
        [weakSelf hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"请求错误"];
         [weakSelf hideHud];
        
    }];
    
}

-(void)backLogin{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldresignFirstResponder{
    [_alarmTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_IDCardTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_MobilePhoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
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
