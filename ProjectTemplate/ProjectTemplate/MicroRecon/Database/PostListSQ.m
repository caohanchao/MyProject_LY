//
//  PostListSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostListSQ.h"

@implementation PostListSQ

+ (instancetype)PostListSQ {
    
    PostListSQ *dao = [[PostListSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertPostList:(PostListModel *)model
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
       ret = [db executeUpdate:@"insert into ca_allPost(CA_alarm,CA_comment,CA_department,CA_headpic, CA_ispraise,CA_mode,CA_picture,CA_position,CA_postid,CA_posttype,CA_praisenum, CA_publishname, CA_pushtime,CA_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
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
- (void)transactionInsertPostListModel:(NSArray *)array {
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            PostListModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from ca_allPost where CA_postid = ?";
            
            if (![[LZXHelper isNullToString:model.postid] isEqualToString:@""])
            {
                FMResultSet *rs = [db executeQuery:sql,model.postid];
                if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                    
                    ret = YES;
                }else{
                    
                    ret = NO;
                }
                [rs close];
                
                if (ret) {
                    res = [db executeUpdate:@"update ca_allPost set CA_alarm = ?,CA_comment = ?,CA_department = ?,CA_headpic = ?, CA_ispraise = ?,CA_mode = ?,CA_picture = ?,CA_position = ?,CA_postid = ?,CA_posttype = ?,CA_praisenum = ?, CA_publishname = ?, CA_pushtime = ? ,CA_text = ? where CA_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
                } else {
                    res = [db executeUpdate:@"insert into ca_allPost(CA_alarm,CA_comment,CA_department,CA_headpic, CA_ispraise,CA_mode,CA_picture,CA_position,CA_postid,CA_posttype,CA_praisenum, CA_publishname, CA_pushtime,CA_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
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

//更新数据库
- (BOOL)updataPostList:(PostListModel*)model
{
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
       ret = [db executeUpdate:@"update ca_allPost set CA_alarm = ?,CA_comment = ?,CA_department = ?,CA_headpic = ?, CA_ispraise = ?,CA_mode = ?,CA_picture = ?,CA_position = ?,CA_postid = ?,CA_posttype = ?,CA_praisenum = ?, CA_publishname = ?, CA_pushtime = ? ,CA_text = ? where CA_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
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
// 查询动态
- (NSMutableArray *)selectPostList
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from ca_allPost order by CA_pushtime desc"];
         while (set.next) {
             PostListModel *model = [[PostListModel alloc] init];
             model.alarm = [set stringForColumn:@"CA_alarm"];
             model.comment = [set stringForColumn:@"CA_comment"];
             model.department = [set stringForColumn:@"CA_department"];
             model.headpic = [set stringForColumn:@"CA_headpic"];
             model.ispraise = [set stringForColumn:@"CA_ispraise"];
             model.mode = [set stringForColumn:@"CA_mode"];
             model.picture = [set stringForColumn:@"CA_picture"];
             model.position = [set stringForColumn:@"CA_position"];
             model.postid = [set stringForColumn:@"CA_postid"];
             model.posttype = [set stringForColumn:@"CA_posttype"];
             model.praisenum = [set stringForColumn:@"CA_praisenum"];
             model.publishname = [set stringForColumn:@"CA_publishname"];
             model.pushtime = [set stringForColumn:@"CA_pushtime"];
             model.text = [set stringForColumn:@"CA_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}
//查询根据id
- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from ca_allPost where CA_postid = ?",postid];
         while (set.next) {
             PostListModel *model = [[PostListModel alloc] init];
             model.alarm = [set stringForColumn:@"CA_alarm"];
             model.comment = [set stringForColumn:@"CA_comment"];
             model.department = [set stringForColumn:@"CA_department"];
             model.headpic = [set stringForColumn:@"CA_headpic"];
             model.ispraise = [set stringForColumn:@"CA_ispraise"];
             model.mode = [set stringForColumn:@"CA_mode"];
             model.picture = [set stringForColumn:@"CA_picture"];
             model.position = [set stringForColumn:@"CA_position"];
             model.postid = [set stringForColumn:@"CA_postid"];
             model.posttype = [set stringForColumn:@"CA_posttype"];
             model.praisenum = [set stringForColumn:@"CA_praisenum"];
             model.publishname = [set stringForColumn:@"CA_publishname"];
             model.pushtime = [set stringForColumn:@"CA_pushtime"];
             model.text = [set stringForColumn:@"CA_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    return array;
}
//删除动态
- (BOOL)deletePostListByPuid:(NSString *)puid
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from ca_allPost where CA_postid = ? ", puid];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 清除表
- (BOOL) clearPostList
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"ca_allPost"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
