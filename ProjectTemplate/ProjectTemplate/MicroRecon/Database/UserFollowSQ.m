//
//  UserFollowSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserFollowSQ.h"

@implementation UserFollowSQ

+ (instancetype)UserFollowSQ {
    
    UserFollowSQ *dao = [[UserFollowSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertUserFollow:(HomePageListModel *)model withUserAlarm:(NSString*)userAlarm
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into ha_userFollow(HA_alarm,HA_department,HA_headpic,HA_name, HA_time,HA_userAlarm) values(?,?,?,?,?,?)",model.alarm, model.department, model.headpic, model.name, model.time, userAlarm];
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
            NSString *sql = @"select * from ha_userFollow where HA_alarm = ?";
            
            if (![[LZXHelper isNullToString:model.alarm] isEqualToString:@""])
            {
                FMResultSet *rs = [db executeQuery:sql,model.alarm];
                if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                    
                    ret = NO;
                }else{
                    
                    ret = NO;
                }
                [rs close];
                
                if (ret) {
                    res = [db executeUpdate:@"update ha_userFollow set HA_alarm = ?,HA_department = ?,HA_headpic = ?,HA_name = ?, HA_time = ?,HA_userAlarm = ? where HA_alarm = ?",model.alarm, model.department, model.headpic, model.name,model.time, userAlarm,model.alarm];
                } else {
                    res = [db executeUpdate:@"insert into ha_userFollow(HA_alarm,HA_department,HA_headpic,HA_name, HA_time,HA_userAlarm) values(?,?,?,?,?,?)",model.alarm, model.department, model.headpic, model.name, model.time, userAlarm];
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


// 查询
- (NSMutableArray *)selectUserFollowWithUserAlarm:(NSString*)userAlarm
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from ha_userFollow where HA_userAlarm = ? order by HA_time desc",userAlarm];
         while (set.next) {
             HomePageListModel *model = [[HomePageListModel alloc] init];
             model.alarm = [set stringForColumn:@"HA_alarm"];
             model.department = [set stringForColumn:@"HA_department"];
             model.headpic = [set stringForColumn:@"HA_headpic"];
             model.name = [set stringForColumn:@"HA_name"];
             model.time = [set stringForColumn:@"HA_time"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//删除
- (BOOL)deleteUserFollowWithUserAlarm:(NSString*)userAlarm withAlarm:(NSString*)alarm
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from ha_userFollow where HA_userAlarm = ? and  HA_alarm = ?", userAlarm,alarm];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 删除此人所有关注
- (BOOL)deleteUserFollowWithPostid:(NSString*)postID
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from ha_userFollow where HA_userAlarm = ?", postID];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 清除表
- (BOOL) clearUserFollow
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"ha_userFollow"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
