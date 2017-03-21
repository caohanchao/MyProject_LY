//
//  PersonnelInformationSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/6.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PersonnelInformationSQ.h"


@interface PersonnelInformationSQ ()



@end
@implementation PersonnelInformationSQ

//根据FMDatabase获取PersonnelInformationSQ对象
+ (instancetype)personnelInformationDAO {
    
    PersonnelInformationSQ *dao = [[PersonnelInformationSQ alloc] init];
    
    return dao;
    
}

// 插入一条好友信息到列表
- (BOOL)insertPersonnelInformationOfFriendsListModel:(FriendsListModel *)model {
    
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into tb_PersonnelInformation(PI_alarm,PI_nickname,PI_name,PI_headpic,PI_phone,PI_isfriend,PI_useralarm) values(?,?,?,?,?,?,?)",model.alarm,model.nickname,model.name,model.headpic,model.phone,@"YES",model.useralarm];
        
        if (!isSuccess) {
            ZEBLog(@"tb_PersonnelInformation-----%@",db.lastError);
        }

    
    }];
        return isSuccess;

}
// 插入一条好友信息到列表
- (BOOL)insertPersonnelInformationOfUserInfoModel:(UserInfoModel *)model {
    
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into tb_PersonnelInformation(PI_alarm,PI_name,PI_headpic,PI_phone,PI_useralarm) values(?,?,?,?,?)",model.alarm,model.name,model.headpic,model.phonenum,model.useralarm];
        
        if (!isSuccess) {
            ZEBLog(@"tb_PersonnelInformation-----%@",db.lastError);
        }
        
        
    }];
    return isSuccess;
    
}
// 插入一条组织人员信息到列表
- (BOOL)insertPersonnelInformationOfUserAllModel:(UserAllModel *)model {
    
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into tb_PersonnelInformation(PI_alarm,PI_name,PI_department,PI_headpic,PI_nickname,PI_phone,PI_ptime,PI_status,PI_isdepartment,PI_useralarm,PI_post) values(?,?,?,?,?,?,?,?,?,?,?)",model.RE_alarmNum,model.RE_name,model.RE_department,model.RE_headpic,model.RE_nickname,model.RE_phonenum,model.RE_ptime,model.RE_status,@"YES",model.RE_useralarm,model.RE_post];
        if (!isSuccess) {
            ZEBLog(@"tb_PersonnelInformation-----%@",db.lastError);
        }

    }];
 
    return isSuccess;

}
//事务插入好友信息（处理大量数据）
- (void)transactionInsertPersonnelInformationOfFriendsListModel:(NSArray *)array {
   
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            FriendsListModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from tb_PersonnelInformation where PI_alarm = ?";
            FMResultSet *rs = [db executeQuery:sql,model.alarm];
            if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                
                ret = YES;
            }else{
                
                ret = NO;
            }
            [rs close];
            
            if (ret) {
                res = [db executeUpdate:@"update tb_PersonnelInformation set PI_nickname = ?,PI_name = ?,PI_headpic = ?,PI_phone = ?, PI_isfriend = ?, PI_useralarm = ? where PI_alarm = ?",model.nickname, model.name, model.headpic, model.phone,@"YES",model.useralarm, model.alarm];
            } else {
                res = [db executeUpdate:@"insert into tb_PersonnelInformation(PI_alarm,PI_nickname,PI_name,PI_headpic,PI_phone,PI_isfriend,PI_useralarm) values(?,?,?,?,?,?,?)",model.alarm,model.nickname,model.name,model.headpic,model.phone,@"YES",model.useralarm];
            }
            
            if (!res) {
                NSLog(@"break");
                *rollback = YES;
                return;
            }
        }

    }];
    
}
//事务插入组织人员（处理大量数据）
- (void)transactionInsertPersonnelInformationOfUserAllModel:(NSArray *)array {
    
    __block BOOL res;
    __block NSInteger count = array.count;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            UserAllModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from tb_PersonnelInformation where PI_alarm = ?";
            FMResultSet *rs = [db executeQuery:sql,model.RE_alarmNum];
            if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                
                ret = YES;
            }else{
                
                ret = NO;
            }
            [rs close];
            if (ret) {
                 res = [db executeUpdate:@"update tb_PersonnelInformation set PI_name = ?,PI_department = ?,PI_headpic = ?,PI_nickname = ?,PI_phone = ?,PI_ptime = ?, PI_status = ?, PI_isdepartment = ?,PI_useralarm = ?,PI_post = ? where PI_alarm = ?",model.RE_name, model.RE_department, model.RE_headpic, model.RE_nickname,model.RE_phonenum,model.RE_ptime,model.RE_status,@"YES", model.RE_useralarm,model.RE_post,model.RE_alarmNum];
            }else {
                res = [db executeUpdate:@"insert into tb_PersonnelInformation(PI_alarm,PI_name,PI_department,PI_headpic,PI_nickname,PI_phone,PI_ptime,PI_status,PI_isdepartment,PI_useralarm,PI_post) values(?,?,?,?,?,?,?,?,?,?,?)",model.RE_alarmNum,model.RE_name,model.RE_department,model.RE_headpic,model.RE_nickname,model.RE_phonenum,model.RE_ptime,model.RE_status,@"YES",model.RE_useralarm,model.RE_post];
            }
            
            if (!res) {
                NSLog(@"break");
                *rollback = YES;
                return;
            }
            
        }

    }];
    
}
// 查询在列表的好友列表
- (NSMutableArray *)selectFrirndlist {

    __block NSMutableArray *array = [NSMutableArray array];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_PersonnelInformation where PI_isfriend = ?",@"YES"];
        while (set.next) {
            FriendsListModel *model = [[FriendsListModel alloc] init];
            model.alarm = [set stringForColumn:@"PI_alarm"];
            model.headpic = [set stringForColumn:@"PI_headpic"];
            model.name = [set stringForColumn:@"PI_name"];
            model.nickname = [set stringForColumn:@"PI_nickname"];
            model.phone = [set stringForColumn:@"PI_phone"];
            model.useralarm = [set stringForColumn:@"PI_useralarm"];
            [array addObject:model];
        }
        [set close];

    }];
        return array;
}
// 查询在列表的组织人员列表
- (NSMutableArray *)selectDepartmentmemberlist {
    __block NSMutableArray *array = [NSMutableArray array];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_PersonnelInformation"];
        while (set.next) {
            
            UserAllModel *model = [[UserAllModel alloc] init];
            model.RE_alarmNum = [set stringForColumn:@"PI_alarm"];
            model.RE_name = [set stringForColumn:@"PI_name"];
            model.RE_department = [set stringForColumn:@"PI_department"];
            model.RE_headpic = [set stringForColumn:@"PI_headpic"];
            model.RE_nickname = [set stringForColumn:@"PI_nickname"];
            model.RE_phonenum = [set stringForColumn:@"PI_phone"];
            model.RE_ptime = [set stringForColumn:@"PI_ptime"];
            model.RE_status = [set stringForColumn:@"PI_status"];
            model.RE_useralarm = [set stringForColumn:@"PI_useralarm"];
            model.RE_post = [set stringForColumn:@"PI_post"];
            [array addObject:model];
        }
        [set close];
    }];
    
    
    return array;
    
}
/*
 CREATE TABLE IF NOT EXISTS tb_PersonnelInformation(PI_id INTEGER PRIMARY KEY AUTOINCREMENT,PI_alarm TEXT unique,PI_nickname TEXT,PI_name TEXT,PI_headpic TEXT,PI_age TEXT,PI_sex TEXT,PI_phone TEXT,PI_post TEXT,PI_department TEXT,PI_addtime TEXT,PI_permission TEXT,PI_ptime TEXT,PI_status TEXT,PI_isdepartment BOOL,PI_isfriend BOOL)
 */
// 根据id查询在消息列表对应的消息
- (FriendsListModel *)selectFrirndlistById:(NSString *)Id {
    
    __block FriendsListModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_PersonnelInformation where PI_alarm = ?", Id];
        if (set.next) {
            FriendsListModel *model = [[FriendsListModel alloc] init];
            model.alarm = [set stringForColumn:@"PI_alarm"];
            model.headpic = [set stringForColumn:@"PI_headpic"];
            model.name = [set stringForColumn:@"PI_name"];
            model.nickname = [set stringForColumn:@"PI_nickname"];
            model.phone = [set stringForColumn:@"PI_phone"];
            model.useralarm = [set stringForColumn:@"PI_useralarm"];
            tempModel = model;
        }
        [set close];
    }];

    
    return tempModel;
}
// 根据姓名查询在消息列表对应的信息
- (FriendsListModel *)selectFrirndlistByName:(NSString *)name {
    
    
    __block FriendsListModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_PersonnelInformation where PI_name = ?", name];
        if (set.next) {
            FriendsListModel *model = [[FriendsListModel alloc] init];
            model.alarm = [set stringForColumn:@"PI_alarm"];
            model.headpic = [set stringForColumn:@"PI_headpic"];
            model.name = [set stringForColumn:@"PI_name"];
            model.nickname = [set stringForColumn:@"PI_nickname"];
            model.phone = [set stringForColumn:@"PI_phone"];
            model.useralarm = [set stringForColumn:@"PI_useralarm"];
            tempModel = model;
        }
        [set close];
    }];
    
    
    return tempModel;
}
// 根据id查询在消息列表对应的消息
- (UserAllModel *)selectDepartmentmemberlistById:(NSString *)Id {
    
    __block UserAllModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    
        FMResultSet *set = [db executeQuery:@"select * from tb_PersonnelInformation where PI_alarm = ?", Id];
        if (set.next) {
            UserAllModel *model = [[UserAllModel alloc] init];
            
            model.RE_alarmNum = [set stringForColumn:@"PI_alarm"];
            model.RE_name = [set stringForColumn:@"PI_name"];
            model.RE_department = [set stringForColumn:@"PI_department"];
            model.RE_headpic = [set stringForColumn:@"PI_headpic"];
            model.RE_nickname = [set stringForColumn:@"PI_nickname"];
            model.RE_phonenum = [set stringForColumn:@"PI_phone"];
            model.RE_ptime = [set stringForColumn:@"PI_ptime"];
            model.RE_status = [set stringForColumn:@"PI_status"];
            model.RE_useralarm = [set stringForColumn:@"PI_useralarm"];
            model.RE_post = [set stringForColumn:@"PI_post"];
            tempModel = model;
        }
        [set close];
    }];
    

    return tempModel;

}
// 根据id查询在消息列表对应的消息 返回群成员
- (GroupMemberModel *)selectDepartmentGroupMemberModelById:(NSString *)Id {
    
    __block GroupMemberModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    
        FMResultSet *set = [db executeQuery:@"select * from tb_PersonnelInformation where PI_alarm = ?", Id];
        if (set.next) {
            GroupMemberModel *model = [[GroupMemberModel alloc] init];
            
            model.ME_uid = [set stringForColumn:@"PI_alarm"];
            model.ME_nickname = [set stringForColumn:@"PI_name"];
            model.headpic = [set stringForColumn:@"PI_headpic"];
            
             tempModel = model;
        }
        [set close];
    }];
    
    
    return tempModel;

    
}
// 插入或更新好友列表数据
- (BOOL)insertOrUpdateNewPersonnelInformationOfFriendsListModel:(FriendsListModel *)model {
    
        if ([self isExistForAlarm:model.alarm]) {
            return [self updateNewPersonnelInformationOfFriendsListModel:model];
        } else {
            return [self insertPersonnelInformationOfFriendsListModel:model];
        }
    
    
    return NO;
}
/*
 PI_alarm,PI_nickname,PI_name,PI_headpic,PI_phone,PI_isdepartment,PI_isfriend) values(?,?,?,?,?,?,?)",model.alarm,model.nickname,model.name,model.headpic,model.phone,@"NO",@"YES"
 */
// 更新好友列表信息
- (BOOL)updateNewPersonnelInformationOfFriendsListModel:(FriendsListModel *)model {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_PersonnelInformation set PI_nickname = ?,PI_name = ?,PI_headpic = ?,PI_phone = ?, PI_isfriend = ?,PI_useralarm = ? where PI_alarm = ?",model.nickname, model.name, model.headpic, model.phone,@"YES", model.useralarm, model.alarm];
    }];

        return ret;
    
}

//删除好友信息
-(BOOL)deletePersonelInfomationFriendsListModel:(NSString *)alarm{

    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_PersonnelInformation set PI_isfriend = ? where PI_alarm = ?",@"NO",alarm];
    }];

    return ret;

}


// 插入或更新组织人员列表数据
- (BOOL)insertOrUpdateNewPersonnelInformationOfUserAllModel:(UserAllModel *)model {
    
        if ([self isExistForAlarm:model.RE_alarmNum]) {
            return [self updateNewPersonnelInformationOfUserAllModel:model];
        } else {
            return [self insertPersonnelInformationOfUserAllModel:model];
        }
    
    
    return NO;
}
/*
 [self.db executeUpdate:@"insert into tb_PersonnelInformation(PI_alarm,PI_name,PI_department,PI_headpic,PI_nickname,PI_phone,PI_ptime,PI_status,PI_isdepartment,PI_isfriend) values(?,?,?,?,?,?,?,?,?,?)",model.RE_alarmNum,model.RE_name,model.RE_department,model.RE_headpic,model.RE_nickname,model.RE_phonenum,model.RE_ptime,model.RE_status,@"YES",@"NO"];
 */
// 更新组织成员列表信息
- (BOOL)updateNewPersonnelInformationOfUserAllModel:(UserAllModel *)model {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_PersonnelInformation set PI_name = ?,PI_department = ?,PI_headpic = ?,PI_nickname = ?,PI_phone = ?,PI_ptime = ?, PI_status = ?, PI_isdepartment = ?,PI_useralarm = ? where PI_alarm = ?",model.RE_name, model.RE_department, model.RE_headpic, model.RE_nickname,model.RE_phonenum,model.RE_ptime,model.RE_status,@"YES",model.RE_useralarm, model.RE_alarmNum];
    }];

        return ret;

    
}
// 更新人员信息
- (BOOL)updateNewPersonnelInformationOfUserInfoModel:(UserInfoModel *)model {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_PersonnelInformation set PI_name = ?,PI_headpic = ?,PI_phone = ?, PI_post = ?, PI_sex = ?,PI_identitycard = ?,PI_useralarm = ? where PI_alarm = ?",model.name, model.headpic, model.phonenum,model.post,model.sex, model.identitycard, model.useralarm, model.alarm];
    }];

        return ret;
    
    
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistForAlarm:(NSString *)alarm  {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from tb_PersonnelInformation where PI_alarm = ?";
        FMResultSet *rs = [db executeQuery:sql,alarm];
        if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
            
            ret = YES;
        }else{
            
            ret = NO;
        }
        [rs close];
    }];
    
    
    return ret;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isFriendExistForAlarm:(NSString *)alarm  {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from tb_PersonnelInformation where PI_alarm = ? and PI_isfriend = ?";
        FMResultSet *rs = [db executeQuery:sql,alarm,@"YES"];
        if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
            ret = YES;
        }else{
            
            ret = NO;
        }
        [rs close];
    }];
    
    return ret;
}
//查询Department列表数
- (NSInteger)getDepartmentCountsFromDB {
    
    __block NSInteger count = 0;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select count(*) from tb_PersonnelInformation where PI_isdepartment = ?";
        FMResultSet *rs = [db executeQuery:sql,@"YES"];
        
        while ([rs next]) {
            //查找 指定类型的记录条数
            count = [[rs stringForColumnIndex:0] integerValue];
        }
        [rs close];
    }];
    
        return count;
    
}

@end
