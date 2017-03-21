//
//  NextRegisterViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define LeftMargin 12


#import "NextRegisterViewController.h"
#import "DJGetPicture.h"
#import "UploadModel.h"
#import "TreeTableViewController.h"
#import "GetorgbyregisterModel.h"
#import "GetorgbyregisterBaseModel.h"
#import "Node.h"
#import "TreeTableView.h"
#import "AccountLogic.h"
#import "CHCLabel.h"
@interface NextRegisterViewController ()<UIScrollViewDelegate,UITextFieldDelegate,TreeTableViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UITextField *_alarmTextField;
    UITextField *_nameTextField;
    UITextField *_IDCardTextField;
    UILabel *_unitLabel;
}

@property (nonatomic)BOOL isMan;

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIView *jwTableView;
@property (nonatomic,strong)UIView *fzTableView;
@property (nonatomic,strong)UIButton *registerBtn;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UIButton *uploadImgBtn;

@property (nonatomic,strong)UIButton *jwBtn;//警务人员
@property (nonatomic,strong)UIButton *fzBtn;//辅助人员
@property (nonatomic,strong)UILabel *scrollLine;

@property(nonatomic,copy) NSString *headPicPath;//图片返回地址
@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,copy)NSArray *jwTitleArray;
@property (nonatomic,copy)NSArray *fzTitleArray;

@property(nonatomic,copy) NSString *unitID;//部门id
@property (nonatomic,strong)CHCLabel *showlabel;

@property (nonatomic,strong)TreeTableViewController *treeVC;
@property (nonatomic,strong)UIControl *overlayView;
@property (nonatomic,strong)UIView *unitView;

@end

@implementation NextRegisterViewController

- (CHCLabel *)showlabel {
    if (!_showlabel) {
        _showlabel = [[CHCLabel alloc] initWithView:self.view];
    }
    return _showlabel;
}

- (NSArray *)jwTitleArray {
    if (!_jwTitleArray) {
        _jwTitleArray = @[@"姓        名",@"警        号",@"身份证号",@"单        位"];
    }
    return _jwTitleArray;
}

- (NSArray *)fzTitleArray {
    if (!_fzTitleArray) {
        _fzTitleArray = @[@"姓        名",@"身份证号",@"单        位"];
    }
    return _fzTitleArray;
}


- (UIView *)jwTableView {
    if (!_jwTableView) {
        _jwTableView =[[UIView alloc] init];
//        _jwTableView.backgroundColor = zBlueColor;
        
    }
    return _jwTableView;
}

- (UIView *)fzTableView {
    if (!_fzTableView) {
        _fzTableView =[[UIView alloc] init];
//        _fzTableView.backgroundColor = zBlackColor;
    }
    return _fzTableView;
}


- (UIButton *)fzBtn {
    if (!_fzBtn) {
        _fzBtn = [CHCUI createButtonWithtarg:self sel:@selector(fzBtnClick) titColor:zBlackColor font:[UIFont systemFontOfSize:14] image:nil backGroundImage:nil title:@"辅助人员"];
        [_fzBtn setTitleColor:zBlackColor forState:UIControlStateNormal];
        [_fzBtn setTitleColor:zBlueColor forState:UIControlStateSelected];
    }
    return _fzBtn;
}
- (UIButton *)jwBtn {
    if (!_jwBtn) {
        _jwBtn = [CHCUI createButtonWithtarg:self sel:@selector(jwBtnClick) titColor:zBlackColor font:[UIFont systemFontOfSize:14] image:nil backGroundImage:nil title:@"警务人员"];
        _jwBtn.selected = YES;
        [_jwBtn setTitleColor:zBlackColor forState:UIControlStateNormal];
        [_jwBtn setTitleColor:zBlueColor forState:UIControlStateSelected];
    }
    return _jwBtn;
}

- (UIButton *)uploadImgBtn {
    if (!_uploadImgBtn) {
       // _uploadImgBtn = [CHCUI createButtonWithtarg:self sel:@selector(uploadImgBtnClick:) titColor:nil font:nil image:@"select_img_icon" backGroundImage:nil title:nil];
        _uploadImgBtn = [CHCUI createButtonWithtarg:self sel:@selector(uploadImgBtnClick:) titColor:nil font:nil image:@"icon_zudui" backGroundImage:nil title:nil];
        _uploadImgBtn.layer.masksToBounds =YES;
        _uploadImgBtn.layer.cornerRadius = 6;
    }
    return _uploadImgBtn;
}

- (UIView *)topView {
    if (!_topView ) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];

    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
    }
    return _bottomView;
}
- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn =[UIButton  buttonWithType:UIButtonTypeCustom];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5;
        [_registerBtn setTitle:@"注    册" forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:CHCHexColor(@"a6a6a6")];
        _registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _registerBtn.titleLabel.font = ZEBFont(18);
        [_registerBtn addTarget:self action:@selector(resister) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.userInteractionEnabled = NO;
    }
    return _registerBtn;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //    120+40+500+60
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight+(kScreenHeight)/4);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initAll];
    
    self.scrollLine = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth()/4-55/2, 45-1.5, 55, 1.5)];
    self.scrollLine.backgroundColor = zBlueColor;
    [self.bottomView addSubview:self.scrollLine];
    
    [self firstAddJWView];
    
//    [self httpGetorgbyregister];
    
    
}

- (void)initAll {
    self.view.backgroundColor =zGroupTableViewBackgroundColor;
    
    [self createBgScrollView];
    [self createTopView];
    [self createBottomView];
    
    [self.bgScrollView addSubview:self.topView];
    [self.bgScrollView addSubview:self.bottomView];
    [self.bgScrollView addSubview:self.registerBtn];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgScrollView.mas_top).offset(16);
        make.left.equalTo(_bgScrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(16);
        make.left.equalTo(_bgScrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45+4*40));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_bottom).offset(30);
        make.left.equalTo(_bgScrollView).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40, 40));
    }];
    

}

- (void)firstAddJWView {
    [self.bottomView addSubview:self.jwTableView];
    [self createJWView];
}



- (void)createBgScrollView {
    _bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _bgScrollView.delegate = self;
    _bgScrollView.directionalLockEnabled = YES;
    
    UIGestureRecognizer *ges = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
    ges.delegate = self;
    [_bgScrollView addGestureRecognizer:ges];
    

    
    [self.view addSubview:_bgScrollView];
    
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
}

- (void)createTopView {
    
    [self.topView addSubview:self.showlabel];
    [self.topView addSubview:self.uploadImgBtn];
    
    UILabel *addTXLabel = [[UILabel alloc] init];
    addTXLabel.text = @"点击上传头像";
    addTXLabel.textColor  = [UIColor grayColor];
    addTXLabel.textAlignment = NSTextAlignmentCenter;
    addTXLabel.font = ZEBFont(10);
    [self.topView addSubview:addTXLabel];
    
    [self.uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.top.equalTo(self.topView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [addTXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadImgBtn.mas_bottom).offset(8);
        make.centerX.equalTo(self.uploadImgBtn.mas_centerX);
    }];

}

- (void)createBottomView {
    [self.bottomView addSubview:self.jwBtn];
    [self.bottomView addSubview:self.fzBtn];
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = LineColor;
    [self.bottomView addSubview:line1];
    
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/2;
    
    [self.jwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top);
        make.left.equalTo(self.bottomView.mas_left);
        make.height.offset(45);
        make.width.offset(btnWidth);
    }];
    
    [self.fzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jwBtn.mas_right);
        make.top.equalTo(self.jwBtn.mas_top);
        make.height.equalTo(self.jwBtn.mas_height);
        make.width.offset(btnWidth);
    }];
}

- (void)removeJwView {
    [self.jwTableView removeAllSubviews];
    [self.jwTableView removeFromSuperview];
    self.jwTableView = nil;
}

- (void)removeFzView {
    [self.fzTableView removeAllSubviews];
    [self.fzTableView removeFromSuperview];
    self.fzTableView = nil;
}

- (void)fzBtnClick {
    _fzBtn.selected = YES;
    _jwBtn.selected = NO;
    
    [self removeJwView];

    if (!_fzTableView) {
        [self.bottomView addSubview:self.fzTableView];
        [self createFZView];
        [UIView animateWithDuration:0.2 animations:^{
            _scrollLine.frame = CGRectMake(midX(self.fzBtn)-55/2, maxY(self.fzBtn)-1.5, 55, 1.5);
        }];
    }
    [self registerBtnSelectState];
}

- (void)jwBtnClick {
    _jwBtn.selected = YES;
    _fzBtn.selected = NO;
    
    [self removeFzView];
    

    if (!_jwTableView) {
        [self.bottomView addSubview:self.jwTableView];
        [self createJWView];
        [UIView animateWithDuration:0.2 animations:^{
            _scrollLine.frame = CGRectMake(midX(self.jwBtn)-55/2, maxY(self.jwBtn)-1.5, 55, 1.5);
        }];
    }
    [self registerBtnSelectState];
}


- (void)createFZView {
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = LineColor;
    [self.fzTableView addSubview:line1];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(16);
        make.left.equalTo(_bgScrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45+3*40));
    }];

    [self.fzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jwBtn.mas_bottom);
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom);
    }];
    
    [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fzTableView.mas_left);
        make.right.equalTo(self.fzTableView.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.fzBtn.mas_bottom).offset(-0.5);
    }];
    NSInteger count = self.fzTitleArray.count;
    for (int i = 0; i < count; i++) {
        NSString *titleStr = self.fzTitleArray[i];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = ZEBFont(13);
        titleLab.text = titleStr;
        titleLab.textColor = CHCHexColor(@"808080");
        
        [self.fzTableView addSubview:titleLab];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = LineColor;
        line.alpha = 0.5;
        [self.fzTableView addSubview:line];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@40);
            make.left.equalTo(self.fzTableView).offset(LeftMargin);
            make.top.equalTo(self.fzTableView).offset(40*i);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom);
            make.left.equalTo(_bgScrollView).offset(LeftMargin);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
        }];
    }
    [self createOtherTextField];

    UIImageView *GoRightImg = [CHCUI createImageWithbackGroundImageV:@"go_right"];
    [self.fzTableView addSubview:GoRightImg];
    [self.fzTableView addSubview:_nameTextField];
    [self.fzTableView addSubview:_IDCardTextField];
    [self.fzTableView addSubview:_unitLabel];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jwBtn.mas_bottom).offset(0.5);
        make.right.equalTo(self.fzTableView);
        make.left.equalTo(self.fzTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [_IDCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTextField.mas_bottom).offset(0.5);
        make.right.equalTo(self.fzTableView);
        make.left.equalTo(self.fzTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IDCardTextField.mas_bottom).offset(0.5);
//        make.right.equalTo(self.fzTableView);
        make.left.equalTo(self.fzTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [GoRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fzTableView.mas_right).offset(-12);
        make.centerY.equalTo(_unitLabel.mas_centerY).offset(0);
        make.left.equalTo(_unitLabel.mas_right).offset(12);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
}



- (void)createJWView {
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = LineColor;
    [self.jwTableView addSubview:line1];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(16);
        make.left.equalTo(_bgScrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45+4*40));
    }];

    [self.jwTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jwBtn.mas_bottom);
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom);
    }];
    
    [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jwTableView.mas_left);
        make.right.equalTo(self.jwTableView.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.fzBtn.mas_bottom).offset(-0.5);
    }];

    
    NSInteger count = self.jwTitleArray.count;
    for (int i = 0; i < count; i++) {
        NSString *titleStr = self.jwTitleArray[i];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = ZEBFont(13);
        titleLab.text = titleStr;
        titleLab.textColor = CHCHexColor(@"808080");
        
        [self.jwTableView addSubview:titleLab];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = LineColor;
        line.alpha = 0.5;
        [self.jwTableView addSubview:line];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@40);
            make.left.equalTo(self.jwTableView).offset(LeftMargin);
            make.top.equalTo(self.jwTableView).offset(40*i);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom);
            make.left.equalTo(_bgScrollView).offset(LeftMargin);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
        }];
    }
    
    [self createOtherTextField];
    
    _alarmTextField = [[UITextField alloc] init];
    _alarmTextField.backgroundColor = [UIColor whiteColor];
    _alarmTextField.tintColor = zBlueColor;
    _alarmTextField.returnKeyType=UIReturnKeyDone;
    _alarmTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _alarmTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _alarmTextField.delegate=self;
    _alarmTextField.font = ZEBFont(13);
    
    
    UIImageView *GoRightImg = [CHCUI createImageWithbackGroundImageV:@"go_right"];
    [self.jwTableView addSubview:GoRightImg];
    
    [self.jwTableView addSubview:_alarmTextField];
    
    [self.jwTableView addSubview:_nameTextField];
    [self.jwTableView addSubview:_IDCardTextField];
    [self.jwTableView addSubview:_unitLabel];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jwBtn.mas_bottom).offset(0.5);
        make.right.equalTo(self.jwTableView);
        make.left.equalTo(self.jwTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [_alarmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTextField.mas_bottom).offset(0.5);
        make.right.equalTo(self.jwTableView);
        make.left.equalTo(self.jwTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [_IDCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alarmTextField.mas_bottom).offset(0.5);
        make.right.equalTo(self.jwTableView);
        make.left.equalTo(self.jwTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IDCardTextField.mas_bottom).offset(0.5);
//        make.right.equalTo(self.jwTableView);
        make.left.equalTo(self.jwTableView).offset(LeftMargin+80);
        make.height.offset(40-0.5);
    }];
    
    [GoRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jwTableView.mas_right).offset(-12);
        make.centerY.equalTo(_unitLabel.mas_centerY).offset(0);
        make.left.equalTo(_unitLabel.mas_right).offset(12);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
}

- (void)createOtherTextField {
    //姓名
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.tintColor = zBlueColor;
    _nameTextField.delegate=self;
    _nameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _nameTextField.returnKeyType=UIReturnKeyDone;
    _nameTextField.font = ZEBFont(13);
    
    _IDCardTextField = [[UITextField alloc] init];
    _IDCardTextField.backgroundColor = [UIColor whiteColor];
    _IDCardTextField.tintColor = zBlueColor;
    _IDCardTextField.delegate=self;
    _IDCardTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _IDCardTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _IDCardTextField.returnKeyType=UIReturnKeyDone;
    _IDCardTextField.font = ZEBFont(13);
    
    _unitLabel = [[UILabel alloc] init];
    _unitLabel.backgroundColor = [UIColor whiteColor];
    _unitLabel.textColor = [UIColor blackColor];
    _unitLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOR:)];
    [_unitLabel addGestureRecognizer:tap];
    _unitLabel.text = @"";
    _unitLabel.font = ZEBFont(13);
    
}

- (void)uploadImgBtnClick:(UIButton *)btn {
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

}

-(void)textFieldresignFirstResponder{
    [_alarmTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_IDCardTextField resignFirstResponder];
    
}

#pragma mark -
#pragma mark 选单位
- (void)chooseOR:(UITapGestureRecognizer *)recognizer {
    
    [self textFieldresignFirstResponder];
    
//    if (!isNULL(_IDCardTextField.text)&&![LZXHelper validateIdentityCard:_IDCardTextField.text]) {
//
//        return;
//    }
    
    self.treeVC = [[TreeTableViewController alloc] init];
    self.treeVC.delegate = self;
    
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.2;
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];

    
    self.unitView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight()-300, screenWidth(), 300)];
    self.unitView.backgroundColor = [UIColor whiteColor];
    [self.unitView addSubview:self.treeVC.view];

    [keywindow addSubview:self.unitView];
}

//遮罩消失
- (void)dismiss {
    [self.treeVC selectCell];
    [UIView animateWithDuration:.1 animations:^{
        
        self.unitView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [self.unitView removeFromSuperview];
        }
    }];
}

- (void)resister {
    [self textFieldresignFirstResponder];
    
    if (_jwBtn.selected) {

        if (![LZXHelper validateIdentityCard:_IDCardTextField.text]) {

            [self.showlabel show:@"身份证格式错误,请重新填写"];
            return;
        }
        
        [self httpRequestWithResister:0];
        
    }
    else {

        if (isNULL(_nameTextField.text)&&isNULL(_IDCardTextField.text)&&isNULL(_unitLabel.text)) {
            return;
        }
        
        if (![LZXHelper validateIdentityCard:_IDCardTextField.text]) {

            [self.showlabel show:@"身份证格式错误,请重新填写"];
            return;
        }
        
        [self httpRequestWithResister:1];
        
    }
}

//0.警务  1.辅助
- (void)httpRequestWithResister:(NSInteger)type {
    if ([LZXHelper validateIdentityCard:_IDCardTextField.text]) {
        self.isMan = [LZXHelper isManOrWomanWithValidateIdentityCard:_IDCardTextField.text];
    }
    
    NSString *alarm;
    NSString *postID;
    if (type == 0) {
        alarm = _alarmTextField.text;
        postID = @"19";
    }else {
        alarm = @"";
        postID = @"20";
    }
    
    if ([self.headPicPath isEqualToString:@""] || self.headPicPath == nil) {
        self.headPicPath = @"";
    }
    
    NSMutableDictionary *information = [NSMutableDictionary dictionary];
    information[@"name"] = _nameTextField.text;
    information[@"sex"] = [@(self.isMan) stringValue];
    information[@"alarm"] =alarm;
    information[@"phonenum"] = self.information[@"phoneNum"];
    information[@"picture"] = self.headPicPath;
    information[@"identitycard"] = _IDCardTextField.text;
    information[@"serialnumber"] = @"";
    information[@"passwd"] = self.information[@"password"];
    information[@"department"] =self.unitID;
    information[@"post"] = postID;
    
    [self showloadingName:@"正在提交"];
    [[AccountLogic sharedManager] logicRegister:information progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        NSDictionary *data =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
        
        [self hideHud];
        if ([data[@"resultcode"]isEqualToString:@"0"]) {
            
            [self.showlabel show:@"注册成功,请等待审核"];

            [self performSelector:@selector(dissMissVC) withObject:nil afterDelay:1.2f];
            
            
        } else if ([data[@"resultcode"]isEqualToString:@"1002"]) {

            [self.showlabel show:@"账号已注册"];
            
        } else {

            [self.showlabel show:data[@"resultmessage"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        [self.showlabel show:@"服务器异常,请稍后再试"];
    }];
    
    
}

- (void)dissMissVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)registerBtnSelectState {
    if (_jwBtn.selected) {

        if (!isNULL(_alarmTextField.text)&&!isNULL(_nameTextField.text)&&!isNULL(_IDCardTextField.text)&&!isNULL(_unitLabel.text)){
            self.registerBtn.backgroundColor = zBlueColor;
            _registerBtn.userInteractionEnabled = YES;
        }
        else {
            self.registerBtn.backgroundColor = CHCHexColor(@"a6a6a6");
        }
    }else {
        if (!isNULL(_nameTextField.text)&&!isNULL(_IDCardTextField.text)&&!isNULL(_unitLabel.text)){
            self.registerBtn.backgroundColor = zBlueColor;
            _registerBtn.userInteractionEnabled = YES;
        }
        else {
            self.registerBtn.backgroundColor = CHCHexColor(@"a6a6a6");
        }
    }
    
}

#pragma mark -
#pragma mark 选择单位


-(void)selectUnit:(TreeTableViewController *)con orgStr:(NSString *)orgStr orgID:(NSString *)orgID{
    if(orgID != nil){
        self.unitID=orgID;
    }
    if (orgStr != nil) {
        _unitLabel.text=orgStr;
    }

    [self registerBtnSelectState];

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self textFieldresignFirstResponder];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        
        [self tapGes:gestureRecognizer];
        return YES;
    }
}

- (void)tapGes:(UIGestureRecognizer *)ges {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == _IDCardTextField) {
        if (![LZXHelper validateIdentityCard:_IDCardTextField.text]) {
            [self textFieldresignFirstResponder];
            [self.showlabel show:@"身份证格式错误,请重新填写"];
//            [self showHint:@"身份证格式错误,请重新填写"];
        }
    }
    
    [self registerBtnSelectState];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self registerBtnSelectState];
    
    if ([NSString containEmoji:string]) {
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
