//
//  UserDetailSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoModel;

@interface UserDetailSQ : NSObject


//根据FMDatabase获取userDetailDAO对象
+ (instancetype)userDetailDAO;

- (BOOL)updateUserDetailSoundSet:(NSString *)set;
- (BOOL)updateUserDetailVibrateSet:(NSString *)set;
- (BOOL)updateUserDetailLocationSet:(NSString *)set;
- (BOOL)updateUserDetailAutoUploadSet:(NSString *)set;
// 插入一条信息到列表
- (BOOL)insertUserDetail:(UserInfoModel *)model;
// 根据id查询在消息列表对应的信息
- (UserInfoModel *)selectUserDetail;
// 更新用户信息
- (BOOL)updateUserDetail:(UserInfoModel *)model;
//更新数据库性别
- (BOOL)updateUserDetailSex:(NSString *)sex;
//更新数据库电话
- (BOOL)updateUserDetailPhone:(NSString *)phone;
//更新数据库头像
- (BOOL)updateUserDetailHeadpic:(NSString *)headpic;
// 更新用户信息警号
- (BOOL)updateUserDetailUseralarm:(NSString *)useralarm alarm:(NSString *)alarm;
// 清除表
- (BOOL) clearUser;
@end
