/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)

- (MBProgressHUD *)HUD;

- (void)setHUD:(MBProgressHUD *)HUD;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint Time:(NSTimeInterval) time;

- (void)showHint:(NSString *)hint;

//- (void)showLoginLoadingName:(NSString *)loadingName;

- (void)showloadingName:(NSString *)loadingName;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showloadingNameHor:(NSString *)loadingName;

// 错误提示
- (void)showloadingError:(NSString *)errorInfo;

@end
