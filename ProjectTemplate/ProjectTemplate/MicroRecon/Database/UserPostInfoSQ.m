//
//  UserPostInfoSQ.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserPostInfoSQ.h"

@implementation UserPostInfoSQ

+ (instancetype)UserPostInfoSQ {
    
    UserPostInfoSQ *dao = [[UserPostInfoSQ alloc] init];
    
    return dao;
}

//事务插入动态信息（处理大量数据）
- (void)transactionInsertUserPostInfoModel:(NSArray *)array {
    
    NSInteger count = array.count;
    __block BOOL res;
    [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < count; i++) {
            
            CardPostInfoModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from hm_cardPost where HM_postid = ?";
            
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
                    res = [db executeUpdate:@"update hm_cardPost set HM_alarm = ?,HM_comment = ?,HM_department = ?,HM_headpic = ?, HM_ispraise = ?,HM_mode = ?,HM_picture = ?,HM_position = ?,HM_postid = ?,HM_posttype = ?,HM_praisenum = ?, HM_publishname = ?, HM_pushtime = ? ,HM_text = ? where HM_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
                } else {
                    res = [db executeUpdate:@"insert into hm_cardPost(HM_alarm,HM_comment,HM_department,HM_headpic, HM_ispraise,HM_mode,HM_picture,HM_position,HM_postid,HM_posttype,HM_praisenum, HM_publishname, HM_pushtime,HM_text) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.comment, model.department, model.headpic, model.ispraise, model.mode,model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text];
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
         FMResultSet *set = [db executeQuery:@"select * from hm_cardPost where HM_postid = ?",postid];
         while (set.next) {
             CardPostInfoModel *model = [[CardPostInfoModel alloc] init];
             model.alarm = [set stringForColumn:@"HM_alarm"];
             model.comment = [set stringForColumn:@"HM_comment"];
             model.department = [set stringForColumn:@"HM_department"];
             model.headpic = [set stringForColumn:@"HM_headpic"];
             model.ispraise = [set stringForColumn:@"HM_ispraise"];
             model.mode = [set stringForColumn:@"HM_mode"];
             model.picture = [set stringForColumn:@"HM_picture"];
             model.position = [set stringForColumn:@"HM_position"];
             model.postid = [set stringForColumn:@"HM_postid"];
             model.posttype = [set stringForColumn:@"HM_posttype"];
             model.praisenum = [set stringForColumn:@"HM_praisenum"];
             model.publishname = [set stringForColumn:@"HM_publishname"];
             model.pushtime = [set stringForColumn:@"HM_pushtime"];
             model.text = [set stringForColumn:@"HM_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    return array;
}

//更新数据库
- (BOOL)updataUserPostInfo:(CardPostInfoModel*)model
{
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update hm_cardPost set HM_alarm = ?,HM_comment = ?,HM_department = ?,HM_headpic = ?, HM_ispraise = ?,HM_mode = ?,HM_picture = ?,HM_position = ?,HM_postid = ?,HM_posttype = ?,HM_praisenum = ?, HM_publishname = ?, HM_pushtime = ? ,HM_text = ? where HM_postid = ?",model.alarm, model.comment, model.department, model.headpic, model.ispraise,model.mode, model.picture,model.position,model.postid,model.posttype,model.praisenum,model.publishname,model.pushtime,model.text,model.postid];
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
- (NSMutableArray *)selectUserPostInfoWithAlarm:(NSString*)alarm
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from hm_cardPost where HM_alarm = ?order by HM_pushtime desc",alarm];
         while (set.next) {
             CardPostInfoModel *model = [[CardPostInfoModel alloc] init];
             model.alarm = [set stringForColumn:@"HM_alarm"];
             model.comment = [set stringForColumn:@"HM_comment"];
             model.department = [set stringForColumn:@"HM_department"];
             model.headpic = [set stringForColumn:@"HM_headpic"];
             model.ispraise = [set stringForColumn:@"HM_ispraise"];
             model.mode = [set stringForColumn:@"HM_mode"];
             model.picture = [set stringForColumn:@"HM_picture"];
             model.position = [set stringForColumn:@"HM_position"];
             model.postid = [set stringForColumn:@"HM_postid"];
             model.posttype = [set stringForColumn:@"HM_posttype"];
             model.praisenum = [set stringForColumn:@"HM_praisenum"];
             model.publishname = [set stringForColumn:@"HM_publishname"];
             model.pushtime = [set stringForColumn:@"HM_pushtime"];
             model.text = [set stringForColumn:@"HM_text"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}
////查询根据id
//- (NSMutableArray *)selectPostListWithPostID:(NSString*)postid
//{
//    __block NSMutableArray *array = [NSMutableArray array];
//    
//    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
//     {
//         FMResultSet *set = [db executeQuery:@"select * from hm_cardPost where HM_postid = ?",postid];
//         while (set.next) {
//             PostListModel *model = [[PostListModel alloc] init];
//             model.alarm = [set stringForColumn:@"HM_alarm"];
//             model.comment = [set stringForColumn:@"HM_comment"];
//             model.department = [set stringForColumn:@"HM_department"];
//             model.headpic = [set stringForColumn:@"HM_headpic"];
//             model.ispraise = [set stringForColumn:@"HM_ispraise"];
//             model.mode = [set stringForColumn:@"HM_mode"];
//             model.picture = [set stringForColumn:@"HM_picture"];
//             model.position = [set stringForColumn:@"HM_position"];
//             model.postid = [set stringForColumn:@"HM_postid"];
//             model.posttype = [set stringForColumn:@"HM_posttype"];
//             model.praisenum = [set stringForColumn:@"HM_praisenum"];
//             model.publishname = [set stringForColumn:@"HM_publishname"];
//             model.pushtime = [set stringForColumn:@"HM_pushtime"];
//             model.text = [set stringForColumn:@"HM_text"];
//             [array addObject:model];
//         }
//         [set close];
//         
//     }];
//    return array;
//}
//删除动态
- (BOOL)deleteUserPostInfoByPuid:(NSString *)puid
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from hm_cardPost where HM_postid = ? ", puid];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

//删除某个人所有动态动态
- (BOOL)deleteUserPostInfoByAlarm:(NSString *)alarm
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from hm_cardPost where HM_alarm = ? ", alarm];
    }];
    return ret;
    ZEBLog(@"%d",ret);
    
}

// 清除表
- (BOOL) clearUserPostInfo
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"hm_cardPost"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}

@end
