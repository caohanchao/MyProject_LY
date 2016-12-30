//
//  FollowPostListSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FollowPostListSQ.h"

@implementation FollowPostListSQ

+ (instancetype)FollowPostListSQ {
    
    FollowPostListSQ *dao = [[FollowPostListSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertFollowPostList:(PostListModel *)model
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
       ret = [db executeUpdate:@"insert into at_followPost(AT_alarm,AT_comment,AT_department,AT_headpic, AT_ispraise,AT_mode,AT_picture,AT_position,AT_postid,AT_posttype,AT_praisenum, AT_publishname, AT_pushtime,AT_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
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
            NSString *sql = @"select * from at_followPost where AT_postid = ?";
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
                    res = [db executeUpdate:@"update at_followPost set AT_alarm = ?,AT_comment = ?,AT_department = ?,AT_headpic = ?, AT_ispraise = ?,AT_mode = ?,AT_picture = ?,AT_position = ?,AT_postid = ?,AT_posttype = ?,AT_praisenum = ?, AT_publishname = ?, AT_pushtime = ? ,AT_text = ? where AT_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
                } else {
                    res = [db executeUpdate:@"insert into at_followPost(AT_alarm,AT_comment,AT_department,AT_headpic, AT_ispraise,AT_mode,AT_picture,AT_position,AT_postid,AT_posttype,AT_praisenum, AT_publishname, AT_pushtime,AT_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
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
- (BOOL)updataFollowPostList:(PostListModel*)model
{
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update at_followPost set AT_alarm = ?,AT_comment = ?,AT_department = ?,AT_headpic = ?, AT_ispraise = ?,AT_mode = ?,AT_picture = ?,AT_position = ?,AT_postid = ?,AT_posttype = ?,AT_praisenum = ?, AT_publishname = ?, AT_pushtime = ? ,AT_text = ? where AT_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
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
//查询根据id
- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from at_followPost where AT_postid = ?",postid];
         while (set.next) {
             PostListModel *model = [[PostListModel alloc] init];
             model.alarm = [set stringForColumn:@"AT_alarm"];
             model.comment = [set stringForColumn:@"AT_comment"];
             model.department = [set stringForColumn:@"AT_department"];
             model.headpic = [set stringForColumn:@"AT_headpic"];
             model.ispraise = [set stringForColumn:@"AT_ispraise"];
             model.mode = [set stringForColumn:@"AT_mode"];
             model.picture = [set stringForColumn:@"AT_picture"];
             model.position = [set stringForColumn:@"AT_position"];
             model.postid = [set stringForColumn:@"AT_postid"];
             model.posttype = [set stringForColumn:@"AT_posttype"];
             model.praisenum = [set stringForColumn:@"AT_praisenum"];
             model.publishname = [set stringForColumn:@"AT_publishname"];
             model.pushtime = [set stringForColumn:@"AT_pushtime"];
             model.text = [set stringForColumn:@"AT_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    return array;
}

// 查询动态
- (NSMutableArray *)selectFollowPostList
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from at_followPost order by AT_pushtime desc"];
         while (set.next) {
             PostListModel *model = [[PostListModel alloc] init];
             model.alarm = [set stringForColumn:@"AT_alarm"];
             model.comment = [set stringForColumn:@"AT_comment"];
             model.department = [set stringForColumn:@"AT_department"];
             model.headpic = [set stringForColumn:@"AT_headpic"];
             model.ispraise = [set stringForColumn:@"AT_ispraise"];
             model.mode = [set stringForColumn:@"AT_mode"];
             model.picture = [set stringForColumn:@"AT_picture"];
             model.position = [set stringForColumn:@"AT_position"];
             model.postid = [set stringForColumn:@"AT_postid"];
             model.posttype = [set stringForColumn:@"AT_posttype"];
             model.praisenum = [set stringForColumn:@"AT_praisenum"];
             model.publishname = [set stringForColumn:@"AT_publishname"];
             model.pushtime = [set stringForColumn:@"AT_pushtime"];
             model.text = [set stringForColumn:@"AT_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//删除动态
- (BOOL)deleteFollowPostListByPFuid:(NSString *)puid
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from at_followPost where AT_postid = ? ", puid];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}


// 清除表
- (BOOL) clearFollowPost
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"at_followPost"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
