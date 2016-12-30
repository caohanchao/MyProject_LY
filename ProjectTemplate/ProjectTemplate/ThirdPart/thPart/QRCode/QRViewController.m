//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "QRViewController.h"
#import "MyQRCodeView.h"
#import "UIView+Layout.h"
@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
//    [self setupQRCodeView];
    
}
- (void)setUgType:(UGTYPE)ugType {

    _ugType = ugType;
    [self setupQRCodeView];
}

- (void)setupQRCodeView {
    
    // view 的高度 = view宽 + 上面高 + 下面高
    MyQRCodeView *qrView = [[MyQRCodeView alloc] initWithFrame:
                            CGRectMake(0, 0, self.view.width - 20 * 2, self.view.width - 20 * 2 + 60 + 30 + 30)];
    qrView.center = self.view.center;
    if ([UIScreen mainScreen].bounds.size.height <= 480) { // 4s 重新调整下高度
        qrView.frame = CGRectMake(20, 20, self.view.width - 20 * 2, self.view.width - 20 * 2 + 60 + 30 + 10);
    }
    if (_ugType == USER) {
        qrView.iconStr = _iconStr;
        qrView.nameStr = _nameStr;
    }else if(_ugType == GROUP) {
        qrView.gModel = _gModel;
    }
    //qrView.addressStr = _addressStr;
    [self.view addSubview:qrView];
}

@end
