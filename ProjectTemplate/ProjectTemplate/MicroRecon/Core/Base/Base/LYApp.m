//
//  LYApp.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/3.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "LYApp.h"
#import "TeamsModel.h"
#import "GroupDesBaseModel.h"
#import "GroupDesModel.h"
#import "UncaughtExceptionHandler.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ZEBDeepSleepPreventer.h"


@implementation LYApp

+(LYApp*)startApp
{
    __strong static id _sharedObject = nil;
    @synchronized(self) {//同步 执行 防止多线程操作
        if (_sharedObject == nil) {
            _sharedObject = [[self alloc] init];
        }
    }
    return _sharedObject;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initall];
    }
    return self;
}

- (void)initall {
    [self initApp];
    [self initNavigationBar];
    [self initNotification];
}
//初始化导航栏
- (void)initNavigationBar {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:zNavColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName ,nil]];
}
- (void)initApp {
    
    // 设置高德地图KEY
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
    //捕获异常崩溃
    [UncaughtExceptionHandler installUncaughtExceptionHandler:YES showAlert:NO];
    //路由注册
    [DCURLRouter loadConfigDictFromPlist:@"DCURLRouter.plist"];
    //    // 后台永久运行
    //    ZEBDeepSleepPreventer *deepSleep = [[ZEBDeepSleepPreventer alloc] init];
    //    [deepSleep startPreventSleep];
}
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpGroupList:) name:ChatListReoloadGrouplistNotification object:nil];
}

#pragma mark -
#pragma mark 请求群详细信息
- (void)httpGroupList:(NSNotification *)notification {
    
    NSString *gid= notification.object;
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GetGroupDesUrl,alarm,gid,token];
    
    ZEBLog(@"%@",urlString);
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        GroupDesBaseModel *gDesModel = [GroupDesBaseModel getInfoWithData:response];
    
        GroupDesModel *desModel = gDesModel.results[0];
        [[[DBManager sharedManager] GrouplistSQ] insertOrUpdataGrouplistByGroupDesModel:desModel];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:nil];
    } fail:^(NSError *error) {
       
    }];


    
}
@end
