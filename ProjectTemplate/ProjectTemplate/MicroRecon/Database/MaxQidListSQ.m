//
//  MaxQidListSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/7.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "MaxQidListSQ.h"

@implementation MaxQidListSQ

+ (instancetype)maxQidlistSQ {
    
    MaxQidListSQ *dao = [[MaxQidListSQ alloc] init];
    
    return dao;
}
// 插入一条信息到列表
- (BOOL)insertMaxQidlist:(ICometModel *)model {
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        isSuccess = [db executeUpdate:@"insert into tb_maxqidlist(max_rid,max_sid,max_qid) values(?,?,?)",model.rid,model.sid,[NSString stringWithFormat:@"%ld",model.qid]];
        if (!isSuccess) {
            ZEBLog(@"tb_userInfo-----%@",db.lastError);
        }
    }];
    return isSuccess;
}
// 插入一条信息到列表
- (BOOL)insertMaxQid:(NSInteger)qid {
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        isSuccess = [db executeUpdate:@"insert into tb_maxqidlist(max_rid,max_sid,max_qid) values(?,?,?)",@"chat_maxQid",@"",[NSString stringWithFormat:@"%ld",qid]];
        if (!isSuccess) {
            ZEBLog(@"tb_userInfo-----%@",db.lastError);
        }
    }];
    return isSuccess;
}
//事务插入（处理大量数据）
- (void)transactioninsertMaxQidlist:(NSArray *)array {
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            ICometModel *model = array[i];

                res = [db executeUpdate:@"insert into tb_maxqidlist(max_rid,max_sid,max_qid) values(?,?,?)",model.rid,model.sid,[NSString stringWithFormat:@"%ld",model.qid]];
            
            if (!res) {
                NSLog(@"break");
                *rollback = YES;
                return;
            }
        }
        
    }];
    
}
//更新数据库
- (BOOL)updataMaxQidlist:(ICometModel*)model {
    __block BOOL ret;
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_maxqidlist set max_qid = ? where max_rid = ?",[NSString stringWithFormat:@"%ld",model.qid], model.rid];
    }];
    if (ret == YES) {
        ZEBLog(@"----------success");
    }
    else{
        ZEBLog(@"----------error");
    }
    return ret;
}
// 根据id查询在消息列表对应的消息
- (ICometModel *)selectUserlistById:(NSString *)chatId {
    
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from tb_maxqidlist where max_rid = ?", chatId];
        if (set.next) {
            ICometModel *model = [[ICometModel alloc] init];
            model.qid = [[set stringForColumn:@"max_qid"] integerValue];
            model.sid = [set stringForColumn:@"max_sid"];
            model.rid = [set stringForColumn:@"max_rid"];
            tempModel = model;
        }
        
        [set close];
        
    }];
    return tempModel;
}
// 查询最大qid
- (NSInteger)selectmaxQid {
    
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from tb_maxqidlist where max_rid = ?", @"chat_maxQid"];
        if (set.next) {
            ICometModel *model = [[ICometModel alloc] init];
            model.qid = [[set stringForColumn:@"max_qid"] integerValue];
            model.sid = [set stringForColumn:@"max_sid"];
            model.rid = [set stringForColumn:@"max_rid"];
            tempModel = model;
        }
        
        [set close];
        
    }];
    return tempModel.qid;
}
// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateMaxQidlist:(ICometModel *)model {
    if ([self selectUserlistById:model.rid]) {
        return [self updataMaxQidlist:model];
    } else {
        return [self insertMaxQidlist:model];
    }
}
// 根据id查询在消息列表对应的消息
- (NSInteger)selectMaxQidByChatId:(NSString *)Id {
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from tb_maxqidlist where max_rid = ?", Id];
        if (set.next) {
            
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"max_sid"];
            model.rid = [set stringForColumn:@"max_rid"];
            model.qid = [[set stringForColumn:@"max_qid"] integerValue];
            
            tempModel = model;
        }
        
        [set close];
    }];
    
    
    return tempModel.qid;
}
// 清除表
- (BOOL) clearMaxQidlist
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"tb_maxqidlist"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}
@end
