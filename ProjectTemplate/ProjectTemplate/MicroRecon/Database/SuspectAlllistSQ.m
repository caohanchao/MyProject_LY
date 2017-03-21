//
//  SuspectAlllistSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SuspectAlllistSQ.h"


@interface SuspectAlllistSQ ()

@end

@implementation SuspectAlllistSQ

+ (instancetype)suspectAlllistSQ {

    SuspectAlllistSQ *dao = [[SuspectAlllistSQ alloc] init];
    
    return dao;
}
/*
 CREATE TABLE IF NOT EXISTS sl_suspectalllist(SL_id INTEGER PRIMARY KEY AUTOINCREMENT,SL_create_time TEXT ,SL_createuser TEXT,SL_gid TEXT,SL_gname TEXT,SL_headpic TEXT,SL_suspectdec TEXT,SL_suspectid TEXT unique,SL_suspectname TEXT,SL_suspecttype TEXT,SL_username TEXT)
 */
- (BOOL)insertSuspectAlllist:(SuspectlistModel *)model {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into sl_suspectalllist(SL_create_time,SL_createuser, SL_gid, SL_gname, SL_headpic,SL_suspectdec, SL_suspectid, SL_suspectname, SL_suspecttype,SL_username) values(?,?,?,?,?,?,?,?,?,?)",model.create_time, model.createuser, model.gid, model.gname, model.headpic,model.suspectdec,model.suspectid,model.suspectname,model.suspecttype,model.username];
    }];
    return ret;
    
}


//事务插入组织人员（处理大量数据）
- (void)transactionInsertSuspectAlllist:(NSArray *)array {
    
    __block BOOL res;
    __block NSInteger count = array.count;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {

        for (int i = 0; i < count; i++) {
            SuspectlistModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from sl_suspectalllist where SL_suspectid = ?";
            FMResultSet *rs = [db executeQuery:sql,model.suspectid];
            if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                
                ret = YES;
            }else{
                
                ret = NO;
            }
            [rs close];
            if (ret) {
                res = [db executeUpdate:@"update sl_suspectalllist set SL_create_time = ?,SL_createuser = ?,SL_gid = ?,SL_gname = ?,SL_headpic = ?,SL_suspectdec = ?, SL_username = ?, SL_suspectname = ?,SL_suspecttype = ? where SL_suspectid = ?",model.create_time, model.createuser, model.gid, model.gname,model.headpic,model.suspectdec,model.username,model.suspectname, model.suspecttype, model.suspectid];
            }else {
                res = [db executeUpdate:@"insert into sl_suspectalllist(SL_create_time,SL_createuser, SL_gid, SL_gname, SL_headpic,SL_suspectdec, SL_suspectid, SL_suspectname, SL_suspecttype,SL_username) values(?,?,?,?,?,?,?,?,?,?)",model.create_time, model.createuser, model.gid, model.gname, model.headpic,model.suspectdec,model.suspectid,model.suspectname,model.suspecttype,model.username];
            }
            
            if (!res) {
                NSLog(@"break");
                *rollback = YES;
                return;
            }
            
        }
        
    }];
    
}

- (NSMutableArray *)selectSuspectlistByGid:(NSString *)gid {
    
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from sl_suspectalllist where SL_gid = ? order by SL_create_time desc ",gid];
         while (set.next) {
             SuspectlistModel *model = [[SuspectlistModel alloc] init];
             model.create_time = [set stringForColumn:@"SL_create_time"];
             model.createuser = [set stringForColumn:@"SL_createuser"];
             model.gid = [set stringForColumn:@"SL_gid"];
             model.gname = [set stringForColumn:@"SL_gname"];
             model.headpic = [set stringForColumn:@"SL_headpic"];
             model.suspectdec = [set stringForColumn:@"SL_suspectdec"];
             model.suspectid = [set stringForColumn:@"SL_suspectid"];
             model.suspectname = [set stringForColumn:@"SL_suspectname"];
             model.suspecttype = [set stringForColumn:@"SL_suspecttype"];
             model.username = [set stringForColumn:@"SL_username"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;

}
- (NSMutableArray *)selectAllSuspects {
    
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from sl_suspectalllist order by SL_create_time desc "];
         while (set.next) {
             SuspectlistModel *model = [[SuspectlistModel alloc] init];
             model.create_time = [set stringForColumn:@"SL_create_time"];
             model.createuser = [set stringForColumn:@"SL_createuser"];
             model.gid = [set stringForColumn:@"SL_gid"];
             model.gname = [set stringForColumn:@"SL_gname"];
             model.headpic = [set stringForColumn:@"SL_headpic"];
             model.suspectdec = [set stringForColumn:@"SL_suspectdec"];
             model.suspectid = [set stringForColumn:@"SL_suspectid"];
             model.suspectname = [set stringForColumn:@"SL_suspectname"];
             model.suspecttype = [set stringForColumn:@"SL_suspecttype"];
             model.username = [set stringForColumn:@"SL_username"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
    
}

- (SuspectlistModel *)selectSuspectByWorkId:(NSString *)workId {

    __block SuspectlistModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from sl_suspectalllist where SL_suspectid = ?", workId];
        if (set.next) {
            SuspectlistModel *model = [[SuspectlistModel alloc] init];
            model.create_time = [set stringForColumn:@"SL_create_time"];
            model.createuser = [set stringForColumn:@"SL_createuser"];
            model.gid = [set stringForColumn:@"SL_gid"];
            model.gname = [set stringForColumn:@"SL_gname"];
            model.headpic = [set stringForColumn:@"SL_headpic"];
            model.suspectdec = [set stringForColumn:@"SL_suspectdec"];
            model.suspectid = [set stringForColumn:@"SL_suspectid"];
            model.suspectname = [set stringForColumn:@"SL_suspectname"];
            model.suspecttype = [set stringForColumn:@"SL_suspecttype"];
            model.username = [set stringForColumn:@"SL_username"];
            tempModel = model;
        }
        [set close];
        
        
    }];
    
    
    return tempModel;

}
@end
