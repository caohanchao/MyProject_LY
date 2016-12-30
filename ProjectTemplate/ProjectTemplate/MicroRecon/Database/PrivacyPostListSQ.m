//
//  PrivacyPostListSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PrivacyPostListSQ.h"

@implementation PrivacyPostListSQ

+ (instancetype)PrivacyPostListSQ {
    
    PrivacyPostListSQ *dao = [[PrivacyPostListSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertPrivacyPostList:(PostListModel *)model
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into pr_privacyPost(PR_alarm,PR_comment,PR_department,PR_headpic, PR_ispraise,PR_mode,PR_picture,PR_position,PR_postid,PR_posttype,PR_praisenum, PR_publishname, PR_pushtime,PR_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
    }];
    if (ret == YES) {
        ZEBLog(@"----------success");
    }
    else{
        ZEBLog(@"----------error");
    }
    return ret;
    
    
}
//更新数据库
- (BOOL)updataPrivacyPostList:(PostListModel*)model
{
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
       ret = [db executeUpdate:@"update pr_privacyPost set PR_alarm = ?,PR_comment = ?,PR_department = ?,PR_headpic = ?, PR_ispraise = ?,PR_mode = ?,PR_picture = ?,PR_position = ?,PR_postid = ?,PR_posttype = ?,PR_praisenum = ?, PR_publishname = ?, PR_pushtime = ? ,PR_text = ? where PR_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
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

//事务插入动态信息（处理大量数据）
- (void)transactionInsertPostListModel:(NSArray *)array {
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            PostListModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from pr_privacyPost where PR_postid = ?";
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
                    res = [db executeUpdate:@"update pr_privacyPost set PR_alarm = ?,PR_comment = ?,PR_department = ?,PR_headpic = ?, PR_ispraise = ?,PR_mode = ?,PR_picture = ?,PR_position = ?,PR_postid = ?,PR_posttype = ?,PR_praisenum = ?, PR_publishname = ?, PR_pushtime = ? ,PR_text = ? where PR_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
                } else {
                    res = [db executeUpdate:@"insert into pr_privacyPost(PR_alarm,PR_comment,PR_department,PR_headpic, PR_ispraise,PR_mode,PR_picture,PR_position,PR_postid,PR_posttype,PR_praisenum, PR_publishname, PR_pushtime,PR_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
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
//查询根据id
- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from pr_privacyPost where PR_postid = ?",postid];
         while (set.next) {
             PostListModel *model = [[PostListModel alloc] init];
             model.alarm = [set stringForColumn:@"PR_alarm"];
             model.comment = [set stringForColumn:@"PR_comment"];
             model.department = [set stringForColumn:@"PR_department"];
             model.headpic = [set stringForColumn:@"PR_headpic"];
             model.ispraise = [set stringForColumn:@"PR_ispraise"];
             model.mode = [set stringForColumn:@"PR_mode"];
             model.picture = [set stringForColumn:@"PR_picture"];
             model.position = [set stringForColumn:@"PR_position"];
             model.postid = [set stringForColumn:@"PR_postid"];
             model.posttype = [set stringForColumn:@"PR_posttype"];
             model.praisenum = [set stringForColumn:@"PR_praisenum"];
             model.publishname = [set stringForColumn:@"PR_publishname"];
             model.pushtime = [set stringForColumn:@"PR_pushtime"];
             model.text = [set stringForColumn:@"PR_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    return array;
}

// 查询动态
- (NSMutableArray *)selectPrivacyPostList
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from pr_privacyPost order by PR_pushtime desc"];
         while (set.next) {
             PostListModel *model = [[PostListModel alloc] init];
             model.alarm = [set stringForColumn:@"PR_alarm"];
             model.comment = [set stringForColumn:@"PR_comment"];
             model.department = [set stringForColumn:@"PR_department"];
             model.headpic = [set stringForColumn:@"PR_headpic"];
             model.ispraise = [set stringForColumn:@"PR_ispraise"];
             model.mode = [set stringForColumn:@"PR_mode"];
             model.picture = [set stringForColumn:@"PR_picture"];
             model.position = [set stringForColumn:@"PR_position"];
             model.postid = [set stringForColumn:@"PR_postid"];
             model.posttype = [set stringForColumn:@"PR_posttype"];
             model.praisenum = [set stringForColumn:@"PR_praisenum"];
             model.publishname = [set stringForColumn:@"PR_publishname"];
             model.pushtime = [set stringForColumn:@"PR_pushtime"];
             model.text = [set stringForColumn:@"PR_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//删除动态
- (BOOL)deletePrivacyPostListByPPuid:(NSString *)puid
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from pr_privacyPost where PR_postid = ? ", puid];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}


// 清除表
- (BOOL) clearPrivacyPostPost
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"pr_privacyPost"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
