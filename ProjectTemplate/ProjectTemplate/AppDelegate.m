//
//  AppDelegate.m
//  ProjectTemplate
//
//  Created by Jomper Chow on 16/5/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "curl.h"
#import <AVFoundation/AVFoundation.h>
#import "LoginViewController.h"
#import "AccountLogic.h"
#import "HYBNetworking.h"
#import <AFNetworking.h>
#import <Bugtags/Bugtags.h>

#import "DeviceSystemVersion.h"
#import "CUrlServer.h"
#import "ChatLogic.h"
#import "XMLocationManager.h"
#import "LYApp.h"
#import "LoginResponseModel.h"
#import "LocationManager.h"
#import "PullMessageLogic.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    BOOL _isSendHeaart;
}

@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,copy)NSString *message;
@property(nonatomic)BOOL isFirst;

@property(nonatomic,strong) LocationManager *locationManager;
@property(nonatomic,strong) UILongPressGestureRecognizer * longPressGr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [LYApp startApp];
    
   
    //初次启动，保存字符串@“no”，证明程序在前台
  //  [self cacheApplicationState:@"no"];
    
    [self initLocationManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
 
    //初始化 全局curl
    curl_global_init(0L);
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if ((alarm && ![@"" isEqualToString:alarm]) && ( token &&![@"" isEqualToString:token])) {
        AccountLogic *logic = [AccountLogic sharedManager];
        [logic logicReconnect:alarm token:token progress:^(NSProgress * _Nonnull progress) {

        //自动登录不提示
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AutomaticLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
             LoginResponseModel *model = [LoginResponseModel LoginWithData:reponse];
            if (model && [@"0" isEqualToString:model.resultcode] &&
                model.results && model.results.count) {
                [self savaUserInfo:model.results[0]];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DidLoginFromOtherDeviceNotification object:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        self.tabbar = [TabBarViewController new];
        self.window.rootViewController = self.tabbar;
    } else {
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    }
    //设置网络请求超时时间
    [HYBNetworking setTimeout:30];
    [self.window makeKeyAndVisible];
    
    //监听网络变化
    [self performSelector:@selector(addobserverNetWork) withObject:nil afterDelay:1.0f];
    //发送心跳包
    [self sendHeart];
    _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(sendHeart) userInfo:nil repeats:YES];
//    [self startNStimer];
    
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingUserSteps = YES; // 具体可设置的属性请查看 Bugtags.h

    [Bugtags startWithAppKey:BugtagsKey invocationEvent:BTGInvocationEventType options:options];
    options.trackingCrashes = YES;

    [self pushNotification:application];
    
    _isSendHeaart = YES;
    
    return YES;
}
#pragma mark - Private Methods
// 保存登录后服务器返回的用户信息
- (void)savaUserInfo:(Login * _Nonnull)userInfo {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userInfo.token forKey:@"token"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)startNStimer
{
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)stopNStimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}


//初始化定位 获取经纬度
-(void)initLocationManager
{
    self.locationManager = [LocationManager shareManager];
    [self.locationManager startLocation];
    
    __weak AppDelegate *weakself = self;
    self.locationManager.locationCompleteBlock = ^(CLLocation *location){
        weakself.latitude = [NSString stringWithFormat:@"%.8lf",location.coordinate.latitude];
        weakself.longitude =[NSString stringWithFormat:@"%.8lf",location.coordinate.longitude];
    };
    [[XMLocationManager shareManager] requestAuthorization:nil];

}

//消息推送
-(void)pushNotification:(UIApplication *)application{

    if ([UIDevice currentDevice].systemVersion.doubleValue<=8.0) {
        
        UIRemoteNotificationType type=UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [application registerForRemoteNotificationTypes:type];
        
    }
   
    UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
    
    [application registerUserNotificationSettings:setting];
    
    [application registerForRemoteNotifications];
 
}

/**
 *  获取到用户对应当前应用程序的deviceToken时就会调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    ZEBLog(@"deviceToken:%@", deviceToken);
    
    NSString *deviceTokenstr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    [deviceTokenstr writeToFile:[NSString stringWithFormat:@"%@/Documents/deviceToken.log",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@",deviceTokenstr);
    
    if (![deviceTokenstr isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenstr forKey:@"DeviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    ZEBLog(@"Regist fail:%@",error);
}



/*
 ios7以前苹果支持多任务, iOS7以前的多任务是假的多任务
 而iOS7开始苹果才真正的推出了多任务
 */
// 接收到远程服务器推送过来的内容就会调用
// 注意: 只有应用程序是打开状态(前台/后台), 才会调用该方法
/// 如果应用程序是关闭状态会调用didFinishLaunchingWithOptions
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
     如果应用程序在后台 , 只有用户点击了通知之后才会调用
     如果应用程序在前台, 会直接调用该方法
     即便应用程序关闭也可以接收到远程通知
     */
    ZEBLog(@"p3:%@", userInfo);
    
    
//    NSLog(@"%ld",[[[DBManager sharedManager]MessageDAO] getMaxQid]);
    
//
//    static int count = 0;
//    count++;
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 250, 200, 200);
//    label.numberOfLines = 0;
//    label.textColor = [UIColor whiteColor];
//    label.text = [NSString stringWithFormat:@"%@ \n %d", userInfo, count];
//    label.font = [UIFont systemFontOfSize:11];
//    label.backgroundColor = [UIColor grayColor];
//    [self.window.rootViewController.view addSubview:label];
}

//接收到远程服务器推送过来的内容就会调用
// ios7以后用这个处理后台任务接收到得远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
//    self.window.rootViewController = [TabBarViewController new];
    
//    NSLog(@"%ld",[[[DBManager sharedManager]MessageDAO] getMaxQid]);
    

    
    ZEBLog(@"-------------%@",userInfo);
    
    /*
     UIBackgroundFetchResultNewData, 成功接收到数据
     UIBackgroundFetchResultNoData, 没有;接收到数据
     UIBackgroundFetchResultFailed 接收失败
     
     */
//    NSLog(@"p1:%s",__func__);
//    NSLog(@"p2:%@",userInfo);
    /*
    NSString *contentid =  userInfo[@"aps"][@"alert"];
    if (contentid) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 250, 200, 200);
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@", contentid];
        label.font = [UIFont systemFontOfSize:30];
        label.backgroundColor = [UIColor grayColor];
        [self.window.rootViewController.view addSubview:label];
        //注意: 在此方法中一定要调用这个调用block, 告诉系统是否处理成功.
        // 以便于系统在后台更新UI等操作
        completionHandler(UIBackgroundFetchResultNewData);
    }else
    {
        completionHandler(UIBackgroundFetchResultFailed);
    }
     */
    
}


//监听网络状态

-(void)addobserverNetWork{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.message=@"未识别的网络";
                [self addobserverNotification];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.message=@"网络未连接";
                [self addobserverNotification];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.message=@"3G|4G网络";
                [self addobserverNotification];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.message=@"wifi网络";
                [self addobserverNotification];
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
   

}

#pragma mark -
#pragma mark 发送心跳包
- (void)sendHeart {
    
//    NSLog(@"----%@,%@",self.latitude,self.longitude);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        
        [[ChatLogic sharedManager] logicSendHeartWithLatitude:self.latitude WithLongitude:self.longitude success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
//                                                                 options:NSJSONReadingMutableContainers error:nil];
//            if ([dict[@"resultcode"] isEqualToString:@"1018"]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:DidLoginFromOtherDeviceNotification object:nil];
//            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

#pragma mark -
#pragma mark 发送心跳包
- (void)sendHeartSS {
    
    if (_isSendHeaart == NO) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
            
            [[ChatLogic sharedManager] logicSendHeartWithLatitude:self.latitude WithLongitude:self.longitude success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                                     options:NSJSONReadingMutableContainers error:nil];
                if ([dict[@"resultcode"] isEqualToString:@"1018"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DidLoginFromOtherDeviceNotification object:nil];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        
        
    }
    else
    {
        _isSendHeaart = NO;
    }
    
}

//保存程序当前的状态，，为 yes 时说明程序在后台，为 no 时说明程序在前台
- (void)cacheApplicationState:(NSString *)string {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    if ([users stringForKey:@"isBack"]) {
        [users removeObjectForKey:@"isBack"];
        [users setValue:string forKey:@"isBack"];
        [users synchronize];
    }else {
        [users setValue:string forKey:@"isBack"];
        [users synchronize];
    }
}
//取出程序当前的状态，，为 yes 时说明程序在后台，为 no 时说明程序在前台
- (BOOL)receiptApplicationState {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSString *string = [users stringForKey:@"isBack"];
    if ([string isEqualToString:@"yes"]) {
        return YES;
    }else
        return NO;
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    curl_global_cleanup();
    
    [self.locationManager stopLocation];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; 
}
- (void)applicationWillEnterForeground:(UIApplication *)application NS_AVAILABLE_IOS(4_0) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //为no时 程序处在前台
    [self cacheApplicationState:@"no"];
}


-(void)addobserverNotification{
    
    NSNotification *notification =[NSNotification notificationWithName:@"NetWork" object:nil userInfo:@{@"message":self.message}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)addReloadDataNotication
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AllMessageReloadNotification object:nil];
}

//应用程序进入活动状态时
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    
    if ((alarm && ![@"" isEqualToString:alarm]) && ( token &&![@"" isEqualToString:token]))
    {
        [self switchPushWithPushType:@"0"];
        
        if ([CUrlServer sharedManager].isComet ==YES)
        {
//            [[ChatLogic sharedManager] logicGetHistoryMessage:^(NSProgress * _Nonnull progress) {
//                NSLog(@"getHistoryMessage progress");
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
//                NSLog(@"getHistoryMessage success");
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"getHistoryMessage failuer");
//            }];
            
            [[PullMessageLogic sharedManager] logicPullHistoryMessage:^(NSProgress * _Nonnull progress) {
                
            } completion:^(id  _Nonnull aResponseObject, NSError * _Nullable anError) {
                if (anError == nil) {
                    
                }
                
            }];
        }
        else
        {
            [self addReloadDataNotication];
        }
    }
    
     [self performSelector:@selector(sendHeartSS) withObject:nil afterDelay:2.0f];
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //进入后台后,断开长连接
//    [[CUrlServer sharedManager] cUrlCleanup];
    
    //为yes时 程序处在后台
    [self cacheApplicationState:@"yes"];
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    //判断是否登出,如果登出则不需要切入APNS
    if (![token isEqualToString:@""] && token)
    {
        //切换消息推送方式 (0.长连接   1.APNS)
        [self switchPushWithPushType:@"1"];
    }
    
   
    
    // 设置永久后台运行
//    UIApplication *app = [UIApplication sharedApplication];
//    __block UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//       dispatch_async(dispatch_get_main_queue(), ^{
//           if (bgTask != UIBackgroundTaskInvalid) {
//               bgTask = UIBackgroundTaskInvalid;
//           }
//       });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       dispatch_async(dispatch_get_main_queue(), ^{
//           if (bgTask != UIBackgroundTaskInvalid) {
//               bgTask = UIBackgroundTaskInvalid;
//           }
//           double delayInSeconds = 30.0;
//           dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//           dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//               if(![[[UIDevice currentDevice] model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
//                   //[self redirectNSLogToDocumentFolder];
//               }
//           });
//       });
//    });
}

- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"longtermrun.log"];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];

    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}



#pragma mark - 切换消息推送
-(void)switchPushWithPushType:(NSString *)pushType
{
    [[ChatLogic sharedManager] switchPushLogicWithPushType:pushType success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"消息切换失败 error:%@",error);
    }];
}
#pragma mark -
#pragma mark tabBarControllerDelegate
- (void)setTabbar:(TabBarViewController *)tabbar {
    _tabbar = tabbar;
    _tabbar.delegate = self;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
       // [self.tabbar showHint:@"该功能开发中"];
        [tabBarController.tabBar addGestureRecognizer:self.longPressGr];
        
        return YES;
    }
    
    [tabBarController.tabBar removeGestureRecognizer:self.longPressGr];
    
    return YES;
}

- (UILongPressGestureRecognizer*)longPressGr
{
    if (!_longPressGr) {
        _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        _longPressGr.minimumPressDuration = 1.0;
    }
    return _longPressGr;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [LYRouter openURL:@"ly://CallHelpViewControllerLongPressCallHelp"];
    }
}

@end
