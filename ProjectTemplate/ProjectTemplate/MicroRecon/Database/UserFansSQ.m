//
//  UserFansSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserFansSQ.h"

@implementation UserFansSQ

+ (instancetype)UserFansSQ {
    
    UserFansSQ *dao = [[UserFansSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertUserFans:(HomePageListModel *)model withUserAlarm:(NSString*)userAlarm
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into hf_userFans(HF_alarm,HF_department,HF_headpic,HF_name, HF_time,HF_userAlarm) values(?,?,?,?,?,?)",model.alarm, model.department, model.headpic, model.name, model.time, userAlarm];
    }];
    if (ret == YES) {
        ZEBLog(@"----------postsuccess");
    }
    else{
        ZEBLog(@"----------posterror");
    }
    return ret;
}

//事务插入动态信息（处理大量数据）
- (void)transactionInsertHomePageListModel:(NSArray *)array withUserAlarm:(NSString*)userAlarm
{
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            HomePageListModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from hf_userFans where HF_alarm = ?";
            
            if (![[LZXHelper isNullToString:model.alarm] isEqualToString:@""])
            {
                FMResultSet *rs = [db executeQuery:sql,model.alarm];
                if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                    
                    ret = YES;
                }else{
                    
                    ret = NO;
                }
                [rs close];
                
                if (ret) {
                    res = [db executeUpdate:@"update hf_userFans set HF_alarm = ?,HF_department = ?,HF_headpic = ?,HF_name = ?, HF_time = ?,HF_userAlarm = ? where HF_alarm = ?",model.alarm, model.department, model.headpic, model.name,model.time, userAlarm,model.alarm];
                } else {
                    res = [db executeUpdate:@"insert into hf_userFans(HF_alarm,HF_department,HF_headpic,HF_name, HF_time,HF_userAlarm) values(?,?,?,?,?,?)",model.alarm, model.department, model.headpic, model.name, model.time, userAlarm];
                }
            }
            
            if (!res) {
                NSLog(@"break    -    error--%@",[[db lastError] description]);
                *rollback = YES;
                return;
            }
        }
        
    }];
    
}

// 查询动态
- (NSMutableArray *)selectUserFansWithUserAlarm:(NSString*)userAlarm
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from hf_userFans where HF_userAlarm = ? order by HF_time desc",userAlarm];
         while (set.next) {
             HomePageListModel *model = [[HomePageListModel alloc] init];
             model.alarm = [set stringForColumn:@"HF_alarm"];
             model.department = [set stringForColumn:@"HF_department"];
             model.headpic = [set stringForColumn:@"HF_headpic"];
             model.name = [set stringForColumn:@"HF_name"];
             model.time = [set stringForColumn:@"HF_time"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//删除动态
- (BOOL)deleteUserFansWithUserAlarm:(NSString*)userAlarm withAlarm:(NSString*)alarm
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from hf_userFans where HF_userAlarm = ? and  HF_alarm = ?", userAlarm,alarm];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 删除此人所有粉丝
- (BOOL)deleteUserFansWithPostid:(NSString*)postID
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from hf_userFans where HF_userAlarm = ?", postID];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 清除表
- (BOOL) clearUserFans
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"hf_userFans"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
