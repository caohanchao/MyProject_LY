//
//  AppDelegate.h
//  ProjectTemplate
//
//  Created by Jomper Chow on 16/5/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNChatUntiles.h"
#import "TabBarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) TabBarViewController *tabbar;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy)NSString *beginTime;

/**
 用户经纬度 设置全局 任何地方都可以拿到
 */
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;

- (void)sendHeart;

-(void)stopNStimer;

-(void)startNStimer;

@end

