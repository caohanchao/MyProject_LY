//
//  UserDetailSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserDetailSQ.h"
#import "UserInfoModel.h"

@interface UserDetailSQ()


@end

@implementation UserDetailSQ


+ (instancetype)userDetailDAO {
    
    UserDetailSQ *dao = [[UserDetailSQ alloc] init];
    
    return dao;
    
}
/*
 CREATE TABLE IF NOT EXISTS tb_userInfo(UI_id INTEGER PRIMARY KEY AUTOINCREMENT,UI_alarm TEXT,UI_department TEXT,UI_headpic TEXT,UI_identitycard TEXT,UI_name TEXT,UI_phonenum TEXT,UI_post TEXT,UI_sex TEXT)
 */
// 插入一条信息到列表
- (BOOL)insertUserDetail:(UserInfoModel *)model {
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        isSuccess = [db executeUpdate:@"insert into tb_userInfo(UI_alarm,UI_department,UI_headpic,UI_identitycard,UI_name,UI_phonenum,UI_post,UI_sex,UI_age) values(?,?,?,?,?,?,?,?,?)",model.alarm,model.department,model.headpic,model.identitycard,model.name,model.phonenum,model.post,model.sex,model.age];
        if (!isSuccess) {
            ZEBLog(@"tb_userInfo-----%@",db.lastError);
        }
    }];
        return isSuccess;
    
    
    
}
//  查询用户信息
- (UserInfoModel *)selectUserDetail {
    __block UserInfoModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *alarm = [user objectForKey:@"alarm"];
        
        FMResultSet *set = [db executeQuery:@"select * from tb_userInfo where UI_alarm = ?", alarm];
        while (set && set.next) {
            UserInfoModel *model = [[UserInfoModel alloc] init];
            model.alarm = [set stringForColumn:@"UI_alarm"];
            model.department = [set stringForColumn:@"UI_department"];
            model.headpic = [set stringForColumn:@"UI_headpic"];
            model.identitycard = [set stringForColumn:@"UI_identitycard"];
            model.name = [set stringForColumn:@"UI_name"];
            model.phonenum = [set stringForColumn:@"UI_phonenum"];
            model.post = [set stringForColumn:@"UI_post"];
            model.sex = [set stringForColumn:@"UI_sex"];
            model.age = [set stringForColumn:@"UI_age"];
            
            model.soundSet = [set stringForColumn:@"UI_soundSet"];
            model.vibrateSet  = [set stringForColumn:@"UI_vibrateSet"];
            model.locationSet = [set stringForColumn:@"UI_locationSet"];
            model.autoUploadSet = [set stringForColumn:@"UI_autoUploadSet"];
            tempModel = model;
        }
        [set close];
        
    }];
        return tempModel;
        

    
}

//更新自动上传
- (BOOL)updateUserDetailAutoUploadSet:(NSString *)set
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_autoUploadSet = ? where UI_alarm = ?",set,alarm];
        
    }];
    return ret;
}

// 更新用户信息
- (BOOL)updateUserDetail:(UserInfoModel *)model {
    
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_department = ?, UI_headpic = ?, UI_identitycard = ?, UI_name = ?, UI_phonenum = ?, UI_post = ?, UI_sex = ?, UI_age = ? where UI_alarm = ?",model.department,model.headpic,model.identitycard,model.name,model.phonenum,model.post,model.sex,model.age,model.alarm];
        
    }];
    
    return ret;
    
}

- (BOOL)updateUserDetailSoundSet:(NSString *)set
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_soundSet = ? where UI_alarm = ?",set,alarm];
        
    }];
    return ret;
}
- (BOOL)updateUserDetailVibrateSet:(NSString *)set
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_vibrateSet = ? where UI_alarm = ?",set,alarm];
        
    }];
    return ret;
}

- (BOOL)updateUserDetailLocationSet:(NSString *)set
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_locationSet = ? where UI_alarm = ?",set,alarm];
        
    }];
    return ret;
}

// 更新用户信息警号
- (BOOL)updateUserDetailUseralarm:(NSString *)useralarm alarm:(NSString *)alarm {
    
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_useralarm = ? where UI_alarm = ?",useralarm,alarm];
        
    }];
    
    return ret;
    
}
//更新数据库性别
- (BOOL)updateUserDetailSex:(NSString *)sex {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
     __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_sex = ? where UI_alarm = ?",sex,alarm];
        
    }];
    return ret;

}
//更新数据库电话
- (BOOL)updateUserDetailPhone:(NSString *)phone {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_phonenum = ? where UI_alarm = ?",phone,alarm];
        
    }];
    return ret;
    

}
//更新数据库头像
- (BOOL)updateUserDetailHeadpic:(NSString *)headpic {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:@"update tb_userInfo set UI_headpic = ? where UI_alarm = ?",headpic,alarm];
    }];
        return ret;

}
// 清除表
- (BOOL) clearUser
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"tb_userInfo"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
  
        }
        
    }];
    return ret;
}
@end
