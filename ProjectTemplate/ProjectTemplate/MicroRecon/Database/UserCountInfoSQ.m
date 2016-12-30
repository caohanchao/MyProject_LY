//
//  UserCountInfoSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserCountInfoSQ.h"

@implementation UserCountInfoSQ

+ (instancetype)UserCountInfoSQ {
    
    UserCountInfoSQ *dao = [[UserCountInfoSQ alloc] init];
    
    return dao;
}

//事务插入动态信息（处理大量数据）
- (void)insertUserCount:(CardCountInfoModel *)model withUserAlarm:(NSString*)userAlarm
{
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        
            BOOL ret ;
            NSString *sql = @"select * from hn_countInfo where HN_alarm = ?";
            
            if (![[LZXHelper isNullToString:userAlarm] isEqualToString:@""])
            {
                FMResultSet *rs = [db executeQuery:sql,userAlarm];
                if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                    
                    ret = YES;
                }else{
                    
                    ret = NO;
                }
                [rs close];
                
                if (ret) {
                    res = [db executeUpdate:@"update hn_countInfo set HN_fansNum = ?,HN_focusNum = ?,HN_publicNum = ?,HN_alarm = ? where HN_alarm = ?",model.fansNum, model.focusNum, model.publicNum, userAlarm,userAlarm];
                } else {
                    res = [db executeUpdate:@"insert into hn_countInfo(HN_fansNum,HN_focusNum,HN_publicNum,HN_alarm) values(?,?,?,?)",model.fansNum, model.focusNum, model.publicNum, userAlarm];
                }
            }
            
            if (!res) {
                NSLog(@"break    -    error--%@",[[db lastError] description]);
                *rollback = YES;
                return;
            }
    }];
    
}

// 查询动态
- (NSMutableArray *)selectUserCountWithUserAlarm:(NSString*)userAlarm
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from hn_countInfo where HN_alarm = ? ",userAlarm];
         while (set.next) {
             CardCountInfoModel *model = [[CardCountInfoModel alloc] init];
             model.fansNum = [set stringForColumn:@"HN_fansNum"];
             model.focusNum = [set stringForColumn:@"HN_focusNum"];
             model.publicNum = [set stringForColumn:@"HN_publicNum"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//更新数据库
- (BOOL)updataUsrCount:(CardCountInfoModel*)model withUserAlarm:(NSString*)userAlarm
{
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update hn_countInfo set HN_fansNum = ?,HN_focusNum = ?,HN_publicNum = ?,HN_alarm = ? where HN_alarm = ?",model.fansNum, model.focusNum, model.publicNum, userAlarm,userAlarm];
        ZEBLog(@"----------%@",[[db lastErrorMessage] description]);
    }];
    if (ret == YES) {
        ZEBLog(@"----------success");
    }
    else{
        ZEBLog(@"----------error");
    }
    return ret;
}

// 清除表
- (BOOL) clearUserCount
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"hn_countInfo"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
