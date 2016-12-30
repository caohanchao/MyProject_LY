//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ScanViewController.h"
#import "QRViewController.h"
#import "QRView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"
#import "QRViewController.h"
#import "UserInfoModel.h"
#import "UserDesInfoController.h"
#import "QRResultGroupController.h"
#import "UserInfoViewController.h"
#import "QRCodelWebController.h"

@interface ScanViewController ()<ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"二维码扫描";
    self.view.backgroundColor = zWhiteColor;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(openQRPhoto)];
    
    self.navigationItem.rightBarButtonItem = barBtn;
    
    [self initConfig];
 }


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
  
    [self.session startRunning];
}
- (void)initConfig {
    
    //相机权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }

        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
//    // 检查授权
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
 
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResize;
    self.preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // kaishi
    [self.session startRunning];
    
    QRView *qrView = [[QRView alloc] initWithFrame:self.view.frame];
    
    //NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    CGSize size = CGSizeZero;
    if (self.view.frame.size.width > 320) {
        size = CGSizeMake(300, 300);
    } else {
        size = CGSizeMake(200, 200);
    }
    
    qrView.transparentArea = size;
    qrView.backgroundColor = [UIColor clearColor];
    qrView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:qrView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, qrView.center.y - size.height/2 - 30,
                                                                  self.view.frame.size.width, 20)];
    tipLabel.text = @"请将摄像头对准二维码 即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *myQRViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(qrView.frame.origin.x,
                                                                       qrView.center.y + size.height/2 + 15,
                                                                       qrView.frame.size.width, 20)];
    [myQRViewBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    myQRViewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myQRViewBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [myQRViewBtn addTarget:self action:@selector(go2myQRView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:myQRViewBtn];
    
}

- (void)go2myQRView {
    
    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    QRViewController *myQRView = [[QRViewController alloc] init];
    myQRView.title = @"我的二维码";
    myQRView.nameStr = model.name;
    myQRView.iconStr = model.headpic;
    myQRView.ugType = USER;
    [self.navigationController pushViewController:myQRView animated:YES];
}

- (void)openQRPhoto {
    
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.allowsEditing = YES;
    reader.readerDelegate = self;
    reader.showsHelpOnFail = NO;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma mark -----AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects firstObject];
        
        self.urlString = metaDataObject.stringValue;
       // NSLog(@"-----%@",self.urlString);
    }
    
    [self handelURLString:self.urlString];
}

// 处理扫描的字符串
-(void)handelURLString:(NSString *)string
{
    
     //NSLog(@"%@",string);
    
    if ([ZEBUtils checkURLHTTPWWW:string]) {//判断是不是URL
    
        [self.session stopRunning];
        
        QRCodelWebController *web = [[QRCodelWebController alloc] init];
        web.title = @"扫描结果";
        web.detailURL = string;
        [self.navigationController pushViewController:web animated:YES];
        
    }else {
        
        NSDictionary *dic = [self dictionaryWithJsonString:string];
    
        if ([dic[@"type"] isEqualToString:@"1"]) {
            NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
            if ([dic[@"key"] isEqualToString:alarm]) {
                [self.session stopRunning];
                UserInfoViewController *userInfoController = [[UserInfoViewController alloc] init];
                [self.navigationController pushViewController:userInfoController animated:YES];
            }else {
                [self.session stopRunning];
                
                UserDesInfoController *userCon = [[UserDesInfoController alloc] init];
                userCon.RE_alarmNum = dic[@"key"];
//                userCon.cType = Others;
                
                if (self.pageType == 1) {
                    userCon.cType = Others;
                }else if (self.pageType == 2) {
                    userCon.cType = GroupController;
                }else if (self.pageType == 3) {
                    userCon.cType = ApplicationPage;
                }
                
                [self.navigationController pushViewController:userCon animated:YES];
//                UserDesInfoController *userCon = [[UserDesInfoController alloc] init];
//                userCon.RE_alarmNum = dic[@"key"];
//                userCon.cType = Others;
//                [self.navigationController pushViewController:userCon animated:YES];
                
            }
            
        }else if ([dic[@"type"] isEqualToString:@"2"]) {
            [self.session stopRunning];
            QRResultGroupController *groupCon = [[QRResultGroupController alloc] init];
            groupCon.gid = dic[@"gid"];
            groupCon.gname = dic[@"gname"];
            groupCon.gtype = dic[@"gtype"];
            groupCon.otherAlarm = dic[@"alarm"];
            if (self.pageType == 1) {
                groupCon.myType = CHATLISTQRRESULT;
            }else if (self.pageType == 2) {
                groupCon.myType = CONTACTQRRESULT;
            }else if (self.pageType == 3) {
                groupCon.myType = APPLICATIONQRRESULT;
            }
            [self.navigationController pushViewController:groupCon animated:YES];
            
        }else {
            QRCodelWebController *web = [[QRCodelWebController alloc] init];
            web.title = @"扫描结果";
            web.codeStr = string;
            [self.navigationController pushViewController:web animated:YES];
        }
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSArray *resuluts = [info objectForKey:ZBarReaderControllerResults];
    
    if (resuluts.count > 0) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for (ZBarSymbol *sym in resuluts) {
            int tempQ = sym.quality;
            if (quality < tempQ) {
                quality = tempQ;
                bestResult = sym;
            }
        }
        
        [self presentResult:bestResult];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry {
    if (retry) {
        //retry == 1 选择图片为非二维码。
        [self showHint:@"请选择二维码图片"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
       // NSLog(@"%@",tempStr);
        
        [self handelURLString:tempStr];
    }
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
       // NSLog(@"json解析失败：%@",err);
        return nil;
    }
    //NSLog(@"%@",dic);
    return dic;
}
@end
