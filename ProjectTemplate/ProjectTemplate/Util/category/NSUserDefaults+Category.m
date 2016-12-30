//
//  NSUserDefaults+Category.m
//  DLDQ_IOS
//
//  Created by simman on 14-5-14.
//  Copyright (c) 2014年 Liwei. All rights reserved.
//

#import "NSUserDefaults+Category.h"

@implementation NSUserDefaults (Category)



- (void) setObj:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) objForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void) removeObjForKey:(NSString *)keyName
{
    if (!keyName) return;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




//
//
//
//- (NSInteger)isUserLogin
//{
//    if ([[NSUSER_DEFAULT valueForKey:@"user_id"] length] > 0) {
//        return [[NSUSER_DEFAULT valueForKey:@"user_id"] integerValue];
//    }
//    return NO;
//}
//
//- (void)savaUser:(User *)user
//{
//    [NSUSER_DEFAULT setObject:user.user_id forKey:@"user_id"];
//    [NSUSER_DEFAULT synchronize];
//}
//
//- (void)UserLogout
//{
//    [NSUSER_DEFAULT setObject:@"" forKey:@"user_id"];
//    [NSUSER_DEFAULT synchronize];
//}
//
//// 设置RegistrationID
//
//- (void)setRegistrationID:(NSString *)regID
//{
//    [NSUSER_DEFAULT setObject:regID forKey:@"user_registration_id"];
//    [NSUSER_DEFAULT synchronize];
//}
//
//- (NSString *)getRegistrationID
//{
//    return [NSUSER_DEFAULT objectForKey:@"user_registration_id"];
//}
//
//// =======>>  用户设置
//
//- (void)setOpenSoundTip:(BOOL)boo
//{
//    [NSUSER_DEFAULT setObject:[NSString stringWithFormat:@"%d", boo] forKey:@"user_is_open_soundtip"];
//    [NSUSER_DEFAULT synchronize];
//}
//
//- (void)setOpenVibrateTip:(BOOL)boo
//{
//    [NSUSER_DEFAULT setObject:[NSString stringWithFormat:@"%d", boo] forKey:@"user_is_open_vibratetip"];
//    [NSUSER_DEFAULT synchronize];
//}
//
//- (BOOL)isOpenSoundTip
//{
//    return [[NSUSER_DEFAULT objectForKey:@"user_is_open_soundtip"] boolValue];
//}
//
//- (BOOL)isOpenVibrateTip
//{
//    return [[NSUSER_DEFAULT objectForKey:@"user_is_open_vibratetip"] boolValue];
//}
//
//- (BOOL) isUseVerify
//{
//    return [[NSUSER_DEFAULT objectForKey:@"is_use_verify"] boolValue];
//}
//
//- (void) setUseVerify:(BOOL)boo
//{
//    [NSUSER_DEFAULT setObject:[NSString stringWithFormat:@"%d", boo] forKey:@"is_use_verify"];
//    [NSUSER_DEFAULT synchronize];
//}
//
//- (int) isRegisterBuyer
//{
//    return [[NSUSER_DEFAULT objectForKey:@"is_register_buyer"] intValue];
//}
//
//- (void) setRegisterBuyer:(BOOL)boo
//{
//    [NSUSER_DEFAULT setObject:[NSString stringWithFormat:@"%d", boo] forKey:@"is_register_buyer"];
//    [NSUSER_DEFAULT synchronize];
//}

@end
