//
//  PostPraiseUserSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostPraiseUserSQ.h"

@implementation PostPraiseUserSQ

+ (instancetype)PostPraiseUserSQ {
    
    PostPraiseUserSQ *dao = [[PostPraiseUserSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertPostPraise:(PostInfoModel *)model withPostID:(NSString*)postID;
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into ps_praiseUser(PS_alarm,PS_department,PS_headpic,PS_name, PS_time,PS_postid) values(?,?,?,?,?,?)",model.alarm, model.department, model.headpic, model.name, model.time,postID];
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
- (void)transactionInsertPostPraiseModel:(NSArray *)array withPostID:(NSString*)postID
{
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            PostInfoModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from ps_praiseUser where PS_alarm = ?";
            
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
                    res = [db executeUpdate:@"update ps_praiseUser set PS_alarm = ?,PS_department = ?,PS_headpic = ?,PS_name = ?, PS_time = ? , PS_postid = ? where PS_alarm = ?",model.alarm, model.department, model.headpic, model.name, model.time,postID,model.alarm];
                } else {
                    res = [db executeUpdate:@"insert into ps_praiseUser(PS_alarm,PS_department,PS_headpic,PS_name, PS_time,PS_postid) values(?,?,?,?,?,?)",model.alarm, model.department, model.headpic, model.name, model.time,postID];
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
- (NSMutableArray *)selectPostPraiseWithPostid:(NSString*)postID;
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from ps_praiseUser where PS_postid = ? ",postID];
         while (set.next) {
             PostInfoModel *model = [[PostInfoModel alloc] init];
             model.alarm = [set stringForColumn:@"PS_alarm"];
             model.department = [set stringForColumn:@"PS_department"];
             model.headpic = [set stringForColumn:@"PS_headpic"];
             model.name = [set stringForColumn:@"PS_name"];
             model.time = [set stringForColumn:@"PS_time"];

             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//取消点赞
- (BOOL)deletePostListByPuid:(NSString *)puid WithPostid:(NSString*)postID;
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from ps_praiseUser where PS_alarm = ? and  PS_postid = ?", puid,postID];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 删除这条动态所有点赞
- (BOOL)deletePostListWithPostid:(NSString*)postID
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from ps_praiseUser where PS_postid = ?", postID];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}


// 清除表
- (BOOL) clearPostPraise
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"ps_praiseUser"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
