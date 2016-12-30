//
//  GrouplistSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GrouplistSQ.h"


@interface GrouplistSQ()


@end

@implementation GrouplistSQ

//根据FMDatabase获取GrouplistSQ对象
+ (instancetype)grouplistDAO {
    
    GrouplistSQ *dao = [[GrouplistSQ alloc] init];
    return dao;
    
}

// 插入一条信息到列表
- (BOOL)insertGrouplist:(TeamsListModel *)model {

    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into tb_grouplist(GR_gid,GR_name,GR_type,GR_admin,GR_creattime,GR_usercount) values(?,?,?,?,?,?)",model.gid,model.gname,model.type,model.admin,model.creattime,model.count ];
        if (!isSuccess) {
            ZEBLog(@"insertGrouplist-------%@",db.lastError);
        }

    
    }];
    
        return isSuccess;

}
// 插入一条信息到列表
- (BOOL)insertGrouplistByGroupDesModel:(GroupDesModel *)model {
    
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into tb_grouplist(GR_gid,GR_name,GR_type,GR_admin,GR_creattime,GR_usercount) values(?,?,?,?,?,?)",model.gid,model.gname,model.gtype,model.gadmin,model.gcreatetime,model.count];
        if (!isSuccess) {
            ZEBLog(@"insertGrouplist-------%@",db.lastError);
        }
        
        
    }];
    
    return isSuccess;
    
}

- (BOOL)insertOrUpdataGrouplistByGroupDesModel:(GroupDesModel *)model {
    
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        BOOL ret ;
        NSString *sql = @"select * from tb_grouplist where GR_gid = ?";
        FMResultSet *rs = [db executeQuery:sql,model.gid];
        if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
            ret = YES;
        }else{
            ret = NO;
        }
        [rs close];
        if (ret) {
            isSuccess = [db executeUpdate:@"update tb_grouplist set GR_name = ?,GR_type = ?,GR_admin = ?,GR_creattime = ?,GR_usercount = ? where GR_gid = ?",model.gname,model.gtype,model.gadmin,model.gcreatetime,model.count,model.gid];
        }else {
            isSuccess = [db executeUpdate:@"insert into tb_grouplist(GR_gid,GR_name,GR_type,GR_admin,GR_creattime,GR_usercount) values(?,?,?,?,?,?)",model.gid,model.gname,model.gtype,model.gadmin,model.gcreatetime,model.count];
        }
    }];
    return isSuccess;
    
}

// 创建群成功插入一条信息到消息列表
- (BOOL)insertGrouplistGroupSuccess:(NSString *)gid gname:(NSString *)gname gadmin:(NSString *)gadmin gcreatetime:(NSString *)gcreatetime gtype:(NSString *)gtype gusercount:(NSString *)gusercount {
    
    
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into tb_grouplist(GR_gid,GR_name,GR_type,GR_admin,GR_creattime,GR_usercount) values(?,?,?,?,?,?)",gid,gname,gtype,gadmin,gcreatetime,gusercount];
        if (!isSuccess) {
            ZEBLog(@"insertGrouplist-------%@",db.lastError);
        }

    
    }];
    
        return isSuccess;
    
}

- (void)transactionInsertOrUpdataGrouplist:(NSArray *)array {
    
    
    __block NSInteger count = array.count;
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0; i < count; i++) {
            TeamsListModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from tb_grouplist where GR_gid = ?";
            FMResultSet *rs = [db executeQuery:sql,model.gid];
            if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                
                ret = YES;
            }else{
                
                ret = NO;
            }
            [rs close];
            if (ret) {
                isSuccess = [db executeUpdate:@"update tb_grouplist set GR_name = ?,GR_type = ?,GR_admin = ?,GR_creattime = ?,GR_usercount = ? where GR_gid = ?",model.gname,model.type,model.admin,model.creattime,model.count,model.gid];
            }else {
                 isSuccess = [db executeUpdate:@"insert into tb_grouplist(GR_gid,GR_name,GR_type,GR_admin,GR_creattime,GR_usercount) values(?,?,?,?,?,?)",model.gid,model.gname,model.type,model.admin,model.creattime,model.count];
            }
            
            if (!isSuccess) {
                NSLog(@"break");
                *rollback = YES;
                return;
            }
//
        }
        
    }];

    
    
}
//事务插入消息（处理大量数据）
- (void)transactionInsertGrouplist:(NSArray *)array {
    
    __block NSInteger count = array.count;
    __block BOOL isSuccess;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    
        for (int i = 0; i < count; i++) {
            TeamsListModel *model = array[i];
            isSuccess = [db executeUpdate:@"insert into tb_grouplist(GR_gid,GR_name,GR_type,GR_admin,GR_creattime,GR_usercount) values(?,?,?,?,?,?)",model.gid,model.gname,model.type,model.admin,model.creattime,model.count ];
            if (!isSuccess) {
                ZEBLog(@"insertGrouplist-------%@",db.lastError);
            }
        
        }
        
    }];
    
}

- (BOOL)updateGroupIsRemindSet:(NSString *)set gid:(NSString *)gid
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret =  [db executeUpdate:@"update tb_grouplist set GR_remindSet = ? where GR_gid = ?",set,gid];

    }];
    
    return ret;
}

//更新数据库
- (BOOL)updateGrouplistAll:(TeamsListModel *)model {

    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_grouplist set GR_usercount = ?,GR_name = ?,GR_type = ?,GR_admin = ?, GR_creattime = ? where GR_gid = ?",model.count, model.gname, model.type, model.admin,model.creattime, model.gid];
    }];

        return ret;

}
// 根据id查询在消息列表对应的消息
- (TeamsListModel *)selectGrouplistById:(NSString *)Id {
    
    __block TeamsListModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_grouplist where GR_gid = ?", Id];
        if (set.next) {
            TeamsListModel *model = [[TeamsListModel alloc] init];
            model.gid = [set stringForColumn:@"GR_gid"];
            model.gname = [set stringForColumn:@"GR_name"];
            model.type = [set stringForColumn:@"GR_type"];
            model.admin = [set stringForColumn:@"GR_admin"];
            model.creattime = [set stringForColumn:@"GR_creattime"];
            model.count = [set stringForColumn:@"GR_usercount"];
            model.memebers = [set stringForColumn:@"GR_member"];
            model.isRemindSet = [set stringForColumn:@"GR_remindSet"];
            tempModel = model;
        }
        [set close];
    
    }];
    

    return tempModel;
}

// 删除指定gid的消息
- (BOOL)deleteGrouplist:(NSString *)gid {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"delete from tb_grouplist where GR_gid = ?", gid];
    }];
    
    return ret;
}

// 查询所有的消息
- (NSMutableArray *)selectGrouplists {
    
    __block NSMutableArray *array = [NSMutableArray array];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_grouplist order by GR_creattime desc"];
        while (set.next) {
            TeamsListModel *model = [[TeamsListModel alloc] init];
            model.gid = [set stringForColumn:@"GR_gid"];
            model.gname = [set stringForColumn:@"GR_name"];
            model.type = [set stringForColumn:@"GR_type"];
            model.admin = [set stringForColumn:@"GR_admin"];
            model.creattime = [set stringForColumn:@"GR_creattime"];
            model.count = [set stringForColumn:@"GR_usercount"];
            model.memebers = [set stringForColumn:@"GR_member"];
            
            model.isRemindSet = [set stringForColumn:@"GR_remindSet"];
            [array addObject:model];
        }
        [set close];
    }];
    
    return array;

}
//查询列表数
- (NSInteger)getCountsFromDB {
    
    __block NSInteger count = 0;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select count(*) from tb_grouplist";
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            //查找 指定类型的记录条数
            count = [[rs stringForColumnIndex:0] integerValue];
        }
        [rs close];
    }];
    
        return count;

}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistGroupForGid:(NSString *)gid  {
    
    if ([self selectGrouplistById:gid]) {
        return YES;
    }else {
        return NO;
    }
}
//更新群成员
- (BOOL)updateGroupMembers:(NSString *)member gid:(NSString *)gid {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret =  [db executeUpdate:@"update tb_grouplist set GR_member = ? where GR_gid = ?",member,gid];
    
    }];
    
        return ret;

    
}
//更新名称
- (BOOL)updateGroupName:(NSString *)name gid:(NSString *)gid {
    
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_grouplist set GR_name = ? where GR_gid = ?",name,gid];
    }];

       
        return ret;

}
//更新群成员数量
- (BOOL)updateGroupMemberCount:(NSString *)count gid:(NSString *)gid {
    
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"update tb_grouplist set GR_usercount = ? where GR_gid = ?",count,gid];
    }];
    
    
    return ret;
    
}
@end
