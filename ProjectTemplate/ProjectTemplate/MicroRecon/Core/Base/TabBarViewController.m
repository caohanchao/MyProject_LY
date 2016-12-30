//
//  TabBarViewController.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TabBarViewController.h"

#import "ChatListViewController.h"
#import "ContactViewController.h"
#import "ApplicationViewController.h"
#import "MeViewController.h"
#import "ChatLogic.h"
#import "CUrlServer.h"
#import "Hotfix.h"
#import "AccountLogic.h"
#import "LoginViewController.h"
#import "CallHelpViewController.h"

@interface TabBarViewController ()


@end


@implementation TabBarViewController

UINavigationController * NavInTabbar(UIViewController * vc, NSString * imgName, NSString * selectImgName) {
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    UIImage * image = [UIImage imageNamed:imgName];
    [image drawInRect:CGRectMake(0, 0, 20, 20)];
    UIImage * selectImage = [UIImage imageNamed:selectImgName];
    [selectImage drawInRect:CGRectMake(0, 0, 20, 20)];
    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:vc.tabBarItem.title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:
                      [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return nav;
}
//
- (instancetype)init {
    if (self = [super init]) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:NOTfirst]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NOTfirst];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self getCUrlServer];
        }
        
    }
    
    return self;
}

-(void)getCUrlServer
{
    // Override point for customization after application launch.
    //状态栏颜色
    [UIApplication sharedApplication].
    statusBarStyle =UIStatusBarStyleLightContent;
    // 连接 IComet
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        CUrlServer *cUrlServer = [CUrlServer sharedManager];
        [cUrlServer cUrlInit];
        [cUrlServer cUrlSetopt];
    });
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    [Hotfix httpJSPatch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginFromOtherDevice) name:DidLoginFromOtherDeviceNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCUrlServer) name:AllMessageReloadNotification object:nil];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [self.view addGestureRecognizer:longPress];
    
    ChatListViewController * chatVC = [[ChatListViewController alloc] init];
    ContactViewController * contactVC = [[ContactViewController alloc] init];
    ApplicationViewController * appVC = [[ApplicationViewController alloc] init];
    MeViewController * meVC = [[MeViewController alloc] init];
    CallHelpViewController *callHelp = [[CallHelpViewController alloc] init];
//    chatVC.title = @"消息";
//    contactVC.title = @"通讯录";
//    appVC.title = @"应用";
//    meVC.title = @"我";
    self.viewControllers = @[
                             NavInTabbar(chatVC    , @"gmsg"        , @"bmsg"       ),
                             NavInTabbar(contactVC , @"glook"     , @"blook"    ),
                             NavInTabbar(callHelp   , @"gbsb"       , @"gbsb"),
                             NavInTabbar(appVC     , @"gapp" , @"bapp"),
                             NavInTabbar(meVC      , @"gme"          , @"bme"         )];
//        self.viewControllers = @[
//                                 NavInTabbar(chatVC    , @"news_n"        , @"news_s"       ),
//                                 NavInTabbar(contactVC , @"contact_n"     , @"contact_s"    ),
//                                 NavInTabbar(appVC     , @"application_n" , @"application_s"),
//                                 NavInTabbar(meVC      , @"me_n"          , @"me_s"         )];
    
    // 矫正TabBar图片位置，使之垂直居中显示
    CGFloat offset = 6.5;
    
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
         item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
            //[item setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    }
}
#pragma mark - didLoginFromOtherDevice
- (void)didLoginFromOtherDevice {
    
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[AccountLogic sharedManager] logicLogout:alarm token:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[CUrlServer sharedManager] cUrlCleanup];
        [DBManager closeDB];
        
        [delegate stopNStimer];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:NOTfirst];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的帐号在其他设备登录，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            
        }];
        
        [alertController addAction:action1];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    if (delegate.tabbar) {
        delegate.tabbar = nil;
    }
    
    
}
//- (void)longPress:(UILongPressGestureRecognizer *)longPress {
//    
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        
//    if (self.selectedIndex == 2) {
//        [LYRouter openURL:@"ly://CallHelpViewControllerLongPressCallHelp"];
//    }else {
//        ZEBLog(@"长按了第%ld个",self.selectedIndex);
//    }
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
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
