//
//  PostCommentSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PostCommentSQ.h"

@implementation PostCommentSQ

+ (instancetype)PostCommentSQ {
    
    PostCommentSQ *dao = [[PostCommentSQ alloc] init];
    
    return dao;
}


// 插入一条信息到动态列表
- (BOOL)insertPostComment:(CommentModel *)model
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into cm_comment(CM_alarm,CM_commentid,CM_postuser,CM_content, CM_department,CM_headpic,CM_mode,CM_pushtime,CM_name,CM_postid) values(?,?,?,?,?,?,?,?,?,?)",model.alarm, model.commentid, model.postuser, model.content, model.department, model.headpic,model.mode,model.pushtime,model.name,model.postid];
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

- (void)transactionInsertPostCommentModel:(NSArray *)array
{
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            CommentModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from cm_comment where CM_commentid = ?";
            if (![[LZXHelper isNullToString:model.commentid] isEqualToString:@""])
            {
                FMResultSet *rs = [db executeQuery:sql,model.commentid];
                if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                    
                    ret = YES;
                }else{
                    
                    ret = NO;
                }
                [rs close];
                
                if (ret) {
                    res = [db executeUpdate:@"update cm_comment set CM_alarm = ?,CM_commentid = ?,CM_postuser = ?,CM_content = ?, CM_department = ?,CM_headpic = ?,CM_mode = ?,CM_pushtime = ?,CM_name = ?,CM_postid = ?where CM_commentid = ?",model.alarm, model.commentid, model.postuser, model.content, model.department,model.headpic, model.mode,model.pushtime,model.name,model.postid,model.commentid];
                } else {
                    res = [db executeUpdate:@"insert into cm_comment(CM_alarm,CM_commentid,CM_postuser,CM_content, CM_department,CM_headpic,CM_mode,CM_pushtime,CM_name,CM_postid) values(?,?,?,?,?,?,?,?,?,?)",model.alarm, model.commentid, model.postuser, model.content, model.department, model.headpic,model.mode,model.pushtime,model.name,model.postid];
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
- (NSMutableArray *)selectPostCommentWithPostID:(NSString*)postID
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from cm_comment where CM_postid = ?  order by CM_pushtime desc",postID];
         while (set.next) {
             CommentModel *model = [[CommentModel alloc] init];
             model.alarm = [set stringForColumn:@"CM_alarm"];
             model.commentid = [set stringForColumn:@"CM_commentid"];
             model.postuser = [set stringForColumn:@"CM_postuser"];
             model.content = [set stringForColumn:@"CM_content"];
             model.department = [set stringForColumn:@"CM_department"];
             model.headpic = [set stringForColumn:@"CM_headpic"];
             model.mode = [set stringForColumn:@"CM_mode"];
             model.pushtime = [set stringForColumn:@"CM_pushtime"];
             model.name = [set stringForColumn:@"CM_name"];
             model.postid = [set stringForColumn:@"CM_postid"];

             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}


// 删除这条动态所有评论
- (BOOL)deletePostListByPuid:(NSString *)postID;
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from cm_comment where CM_postid = ? ", postID];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 清除表
- (BOOL) clearPostList
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"cm_comment"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
