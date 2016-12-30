//
//  NSUserDefaults+Category.h
//  DLDQ_IOS
//
//  Created by simman on 14-5-14.
//  Copyright (c) 2014年 Liwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface NSUserDefaults (Category)


/**
 *  get方法
 *
 *  @param key key
 *
 *  @return id
 */
- (id) objForKey:(NSString *)key;

/**
 *  set 方法，添加同步
 *
 *  @param obj obj
 *  @param key key
 */
- (void) setObj:(id)obj forKey:(NSString *)key;

/**
 *  remove
 *
 *  @param keyName
 */
- (void) removeObjForKey:(NSString *)keyName;






//
//
//// 检测用户是否已经登录
//- (NSInteger)isUserLogin;
//
//- (void)savaUser:(User *)user;
//- (void)UserLogout;
//
//// registrationID
//- (void)setRegistrationID:(NSString *)regID;
//- (NSString *)getRegistrationID;
//
//// =====>>>  用户设置
//
//- (void) setOpenVibrateTip:(BOOL)boo;
//- (void) setOpenSoundTip:(BOOL)boo;
//
//- (BOOL) isOpenVibrateTip;      // 是否开启震动提示
//- (BOOL) isOpenSoundTip;        // 是否开启声音提示
//
//// =====>>> 是否使用校验码
//- (BOOL) isUseVerify;
//- (void) setUseVerify:(BOOL)boo;
//
//// ======>>> 是否注册为买手
//
//- (int) isRegisterBuyer;
//- (void) setRegisterBuyer:(BOOL)boo;


@end
