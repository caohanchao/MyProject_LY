//
//  ViewController.m
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import "ShakeViewController.h"
#import "ZEBAudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "ShakeLoadingView.h"
#import "ShakeBottomView.h"
#import "ShakeResultView.h"
#import "ShakeRadius.h"
#import "ShakeSelectRadius.h"
#import "ShakeCameraBaseModel.h"
#import "ShakeCameraModel.h"
#import "ShakeNoResultView.h"
#import "ShakeMapViewController.h"
#import "XMLocationManager.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define H   300
#define imageW  150
#define imageH  85

@interface ShakeViewController ()<ShakeSelectRadiusDelegate>

@property (nonatomic, strong) UIImageView *image;           //背景图片
@property (nonatomic, strong) UIImageView *upImage;       //上一半手 的图片

@property (nonatomic, strong) UIImageView *downImage;     //上一半手 的图片

@property (nonatomic, strong) UIView *upView;             //下一半手

@property (nonatomic, strong) UIView *downView;           //下一半手 的图片

@property (nonatomic, strong) ShakeLoadingView *shakeLoadingView;// 搜索view

@property (nonatomic, strong) ShakeBottomView *shakeBottomView; // 底部 view
@property (nonatomic, strong) ShakeResultView *shakeResultView; // 展示结果的view
@property (nonatomic, strong) ShakeNoResultView *shakeNoResultView; // 展示没有结果的view

@property (nonatomic, strong) UIImageView *topLine;//上view的线条
@property (nonatomic, strong) UIImageView *downLine;//下view的线条

@property (nonatomic, assign) SHAKETYPE shakeType; // 摇的类型
@property (nonatomic, strong) ShakeRadius *shakeRadiusView;
@property (nonatomic, strong) ShakeSelectRadius *shakeSelectRadiusView;


@property (nonatomic, copy) NSString *radius; // 半径
@property (nonatomic, weak) HYBURLSessionTask *tempTask; // 记住上次的Task

@property (nonatomic, strong) NSMutableArray *dataArray; // 数据源

@end

@implementation ShakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"摇一摇";
    self.radius = @"100";
    
    XMLocationManager *manager = [XMLocationManager shareManager];
    [manager requestAuthorization:^{
    }];
    [self uiConfig];
    [self initRoutable];
    
}
//注册block路由
- (void)initRoutable{
    __block typeof(self) mySelf = self;
    //跳转详情
    [LYRouter registerURLPattern:@"ly://ShakeViewControllerCallPhone" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",userInfo[@"phone"]]];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        //记得添加到view上
        [mySelf.view addSubview:callWebview];
            }];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (ShakeLoadingView *)shakeLoadingView {

    if (!_shakeLoadingView) {
        _shakeLoadingView = [[ShakeLoadingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_downImage.frame)+7, kWidth, 20)];
    }
    return _shakeLoadingView;
}
- (ShakeNoResultView *)shakeNoResultView {
    if (!_shakeNoResultView) {
        _shakeNoResultView = [[ShakeNoResultView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_downImage.frame)+7, kWidth, 20)];
    }
    return _shakeNoResultView;
}
- (ShakeRadius *)shakeRadiusView {
    if (!_shakeRadiusView) {
        WeakSelf
        _shakeRadiusView = [[ShakeRadius alloc] initWithFrame:CGRectMake(kScreenWidth-85, TopBarHeight+15, 85, 40) block:^(ShakeRadius *view) {
            [weakSelf showRadius];
        }];
    }
    return _shakeRadiusView;
}
- (ShakeSelectRadius *)shakeSelectRadiusView {
    if (!_shakeSelectRadiusView) {
        _shakeSelectRadiusView = [[ShakeSelectRadius alloc] initWithFrame:CGRectMake(kScreenWidth, TopBarHeight+15, shakeSelectH, 40)];
        _shakeSelectRadiusView.delegate = self;
    }
    return _shakeSelectRadiusView;
}
- (UIImageView *)topLine {
    if (!_topLine) {
        _topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_line"]];
        _topLine.frame = CGRectMake(0, CGRectGetMaxY(_upView.frame)-5, kWidth, 5);
    }
    return _topLine;
}
- (UIImageView *)downLine {
    if (!_downLine) {
        _downLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_line"]];
        _downLine.frame = CGRectMake(0, 0, kWidth, 5);
    }
    return _downLine;
}
- (ShakeResultView *)shakeResultView {
    if (!_shakeResultView) {
        __weak typeof(self) weakSelf = self;
        _shakeResultView = [[ShakeResultView alloc] initWithFrame:CGRectMake(kWidth/2-100, CGRectGetMaxY(_downImage.frame), 200, 45) block:^(ShakeResultView *view) {
        //    if (self.shakeType == Camera) {
            ShakeMapViewController *map = [[ShakeMapViewController alloc] init];
            map.shakeMapType = (SHAKEMAPSHAKETYPE)weakSelf.shakeType;
            [map addDistance:weakSelf.dataArray];
            [weakSelf.navigationController pushViewController:map animated:YES];
//            }else {
//                [weakSelf showHint:@"该功能开发中"];
//            }
        }];
    }
    return _shakeResultView;
}
- (BOOL)canBecomeFirstResponder
{//默认是NO
    return YES;
}
#pragma mark -
#pragma mark loadingView
- (void)showLoading {
    
    if (self.shakeType == Camera) {
        self.shakeLoadingView.searchText = @"正在搜索附近摄像头...";
    }else if (self.shakeType == Policing) {
        self.shakeLoadingView.searchText = @"正在搜索附近监控室...";
    }else if (self.shakeType == BaseStation) {
        self.shakeLoadingView.searchText = @"正在搜索附近基站...";
    }
    [self hideNoResult];
    [self hideResult];
    [_downView addSubview:self.shakeLoadingView];
}
- (void)hideLoading {
    [self.shakeLoadingView removeFromSuperview];
}
#pragma mark -
#pragma mark line
- (void)showLine {
    [_upView addSubview:self.topLine];
    [_downView addSubview:self.downLine];
}
- (void)hideLine {
    [self.topLine removeFromSuperview];
    [self.downLine removeFromSuperview];
}
#pragma mark -
#pragma mark shakeResult
- (void)showResult:(NSInteger)count {
    
    if (self.shakeType == Camera) {
        self.shakeResultView.resultStr = [NSString stringWithFormat:@"附近有%ld个摄像头",count];
    }else if (self.shakeType == Policing) {
        self.shakeResultView.resultStr = [NSString stringWithFormat:@"附近有%ld个监控室",count];
    }else if (self.shakeType == BaseStation) {
        self.shakeResultView.resultStr = [NSString stringWithFormat:@"附近有%ld个基站",count];
    }
    [self hideLoading];
    [self hideNoResult];
    [_downView addSubview:self.shakeResultView];
   
}
- (void)showNoResult:(NSInteger)type {// 1.失败 超时 2.摇一摇没有结果
    if (type == 1) {
       [self.shakeNoResultView setText:@"连接超时，请稍后再试"];
    }else if (type == 2) {
    if (self.shakeType == Camera) {
        [self.shakeNoResultView setText:@"附近没有摄像头"];
    }else if (self.shakeType == Policing) {
        [self.shakeNoResultView setText:@"附近没有监控室"];
    }else if (self.shakeType == BaseStation) {
       [self.shakeNoResultView setText:@"附近没有基站"];
    }
    }
    [self hideLoading];
    [self hideResult];
    [_downView addSubview:self.shakeNoResultView];
}
- (void)hideResult {
    [self.shakeResultView removeFromSuperview];
}
- (void)hideNoResult {
    [self.shakeNoResultView removeFromSuperview];
}
- (void)hideAll {
    [self.shakeResultView removeFromSuperview];
    [self.shakeNoResultView removeFromSuperview];
    [self.shakeLoadingView removeFromSuperview];
}
#pragma mark -
#pragma mark initUI
- (void)uiConfig
{
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight / 4, kWidth, kHeight / 2)];
    _image.image = [UIImage imageNamed:@"ShakeHideImg_women"];
    [self.view addSubview:_image];
    
    _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, H)];
    _upView.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.17 alpha:1.00];
    
    _upImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-imageW/2, H-imageH, imageW, imageH)];
    _upImage.image = [UIImage imageNamed:@"Shake_Logo_Up"];
    
    [_upView addSubview:_upImage];
    [self.view addSubview:_upView];
    
    
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, H, kWidth, kHeight-H)];
    _downView.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.17 alpha:1.00];
    
    _downImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-imageW/2, 0, imageW, imageH)];
    _downImage.image = [UIImage imageNamed:@"Down"];
    
    [_downView addSubview:_downImage];
    [self.view addSubview:_downView];
  
    [self.view addSubview:self.shakeRadiusView];
    [self.view addSubview:self.shakeSelectRadiusView];
    
    WeakSelf
    _shakeBottomView = [[ShakeBottomView alloc] initWithFrame:CGRectMake(0, kHeight-82, kWidth, 82) cBlock:^(ShakeBottomView *view) {// 选择的摇动的type
        if (weakSelf.tempTask) {
            [weakSelf.tempTask cancel];
        }
        [weakSelf hideAll];
        weakSelf.shakeType = Camera;
    } pBlock:^(ShakeBottomView *view) {
        if (weakSelf.tempTask) {
            [weakSelf.tempTask cancel];
        }
        [weakSelf hideAll];
        weakSelf.shakeType = Policing;
    } bSBlock:^(ShakeBottomView *view) {
        if (weakSelf.tempTask) {
            [weakSelf.tempTask cancel];
        }
        [weakSelf hideAll];
        weakSelf.shakeType = BaseStation;
    }];
    
    [self.view addSubview:_shakeBottomView];
  
}

#pragma mark - 开始摇晃就会调用
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{

    if (motion == UIEventSubtypeMotionShake) {
        
        //先要取消上次请求
        if (self.tempTask){
            [self.tempTask cancel];
        }
        [self hideLoading];
        [self hideResult];
        [self hideNoResult];
        [self showLine];
        //播放摇晃声音
        [ZEBAudioTool playSound];
        
        CGFloat y1 = CGRectGetMinY(_image.frame);
        CGFloat y2 = CGRectGetMaxY(_image.frame);
        
        CGFloat imageUpY = CGRectGetMaxY(_upView.frame);
        CGFloat imageDownY = CGRectGetMinY(_downView.frame);
        //开始摇晃 设置动画
        [UIView animateWithDuration:0.3 animations:^{
            _upView.frame = CGRectMake(0, -(imageUpY-y1), kWidth, H);
            
        } completion:^(BOOL finished) {
            [self performSelector:@selector(reductionUpView) withObject:nil afterDelay:0.3];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _downView.frame = CGRectMake(0, H + (y2-imageDownY), kWidth, kHeight-H);
            
        } completion:^(BOOL finished) {
            [self performSelector:@selector(reductionDownView) withObject:nil afterDelay:0.3];
        }];

    }
}
- (void)reductionUpView {
    [UIView animateWithDuration:0.3 animations:^{
        _upView.frame = CGRectMake(0, 0, kWidth, H);
        
    }];
}
- (void)reductionDownView {
    [UIView animateWithDuration:0.3 animations:^{
        _downView.frame = CGRectMake(0, H, kWidth, kHeight-H);
      
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(showLoading) withObject:nil afterDelay:0.1];
        [self performSelector:@selector(hideLine) withObject:nil afterDelay:0.1];
        [self performSelector:@selector(shakeHttps) withObject:nil afterDelay:0.1];

    }];
}
#pragma mark - 摇晃结束就会调用
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
//    if (motion == UIEventSubtypeMotionShake) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    }
    
}

#pragma mark - 摇晃被打断就会调用
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇晃被打断
}
#pragma mark -
#pragma mark 网络请求
- (void)shakeHttps {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    AppDelegate *appDelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"action"] = @"sharkgetdata";
    parm[@"alarm"] = alarm;
    parm[@"token"] = token;
    parm[@"gps_w"] = appDelegate.latitude;
    parm[@"gps_h"] = appDelegate.longitude;
    parm[@"type"] = [NSString stringWithFormat:@"%ld",self.shakeType+1]; // 传服务器1. 摄像头 2.监控室 3.基站
    parm[@"distance"] = [self.radius trimWhitespace]; // 半径
    
    [self.dataArray removeAllObjects];
    self.tempTask = [HYBNetworking postWithUrl:ShakeUrl refreshCache:YES params:parm success:^(id response) {
        
        ShakeCameraBaseModel *baseModel  = [ShakeCameraBaseModel getInfoWithData:response];
        [self.dataArray addObjectsFromArray:baseModel.results];
        if (baseModel.results.count > 0) {
           [self showResult:baseModel.results.count];
            [ZEBAudioTool playResultSound];
        }else {
            [self showNoResult:2];
            [ZEBAudioTool playResultSound];
        }
        
    } fail:^(NSError *error) {
        if (error.code != -999) { // NSURLErrorCancelled = -999,
            [self showNoResult:1];
            [ZEBAudioTool playResultSound];
        }
    }];
}

#pragma mark -
#pragma mark 显示选择距离的view
- (void)showRadius {
    [self.shakeRadiusView dissmiss];
    [self.shakeSelectRadiusView show];
}
#pragma mark -
#pragma mark ShakeSelectRadiusdelegate
- (void)shakeSelectRadius:(ShakeSelectRadius *)view index:(NSInteger)index radius:(NSString *)radius {

    [self.shakeRadiusView show];
    [self.shakeRadiusView setRadius:radius];
    self.radius = [radius substringToIndex:radius.length-1];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.shakeSelectRadiusView dissmiss];
    [self.shakeRadiusView show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
