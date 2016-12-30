//
//  TaskMarkSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TaskMarkSQ.h"

@interface TaskMarkSQ ()

@end

@implementation TaskMarkSQ

+ (instancetype)taskMarkSQ {
    
    TaskMarkSQ *dao = [[TaskMarkSQ alloc] init];
    
    return dao;
}

//@property (nonatomic, nonnull, copy) NSString *workname;
//@property (nonatomic, nonnull, copy) NSString *workid;
//@property (nonatomic, nonnull, copy) NSString *dataid;
//@property (nonatomic, nonnull, copy) NSString *content;
//@property (nonatomic, nonnull, copy) NSString *picture;
//@property (nonatomic, nonnull, copy) NSString *audio;
//@property (nonatomic, nonnull, copy) NSString *type;
//@property (nonatomic, nonnull, copy) NSString *video;
//@property (nonatomic, nonnull, copy) NSString *title;

- (BOOL)insertTaskMarkFormICometModel:(ICometModel *)model
{
    __block BOOL ret;
    if (![[LZXHelper isNullToString:model.worId] isEqualToString:@""]) {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into tm_taskmark(TM_workname,TM_workid,TM_content,TM_picture,TM_audio,TM_mode,TM_video,TM_title,TM_interid,TM_latitude,TM_longitude,TM_create_time,TM_alarm,TM_realname,TM_gid,TM_headpic,TM_type,TM_direction) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.taskNDataModel.workname,model.taskNDataModel.workid,model.taskNDataModel.content,model.taskNDataModel.picture,model.taskNDataModel.audio,model.taskNDataModel.type,model.taskNDataModel.video,model.taskNDataModel.title,model.taskNDataModel.dataid,model.latitude,model.longitude,model.beginTime,model.sid,model.sname,model.rid,model.headpic,model.taskNDataModel.markType,model.taskNDataModel.direction];
    }];
    }
    return ret;
}

- (BOOL)insertTaskMarkFormChatModel:(chatModel *)model
{
    __block BOOL ret;
    if (![[LZXHelper isNullToString:model.MSG.taskNDataModel.workid] isEqualToString:@""]) {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into tm_taskmark(TM_workname,TM_workid,TM_content,TM_picture,TM_audio,TM_mode,TM_video,TM_title,TM_interid,TM_latitude,TM_longitude,TM_create_time,TM_alarm,TM_realname,TM_gid,TM_headpic,TM_type,TM_direction) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.MSG.taskNDataModel.workname,model.MSG.taskNDataModel.workid,model.MSG.taskNDataModel.content,model.MSG.taskNDataModel.picture,model.MSG.taskNDataModel.audio,model.MSG.taskNDataModel.type,model.MSG.taskNDataModel.video,model.MSG.taskNDataModel.title,model.MSG.taskNDataModel.dataid,model.GPS.W,model.GPS.H,model.beginTime,model.SID,model.SNAME,model.RID,model.HEADPIC,model.MSG.taskNDataModel.markType,model.MSG.taskNDataModel.direction];
    }];
    }
    return ret;
}

- (GetrecordByGroupModel *)selectTaskMarkByInterid:(NSString *)interid {
    __block GetrecordByGroupModel *recordModel;
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from tm_taskmark where TM_interid = ?",interid];
         while (set.next) {
             GetrecordByGroupModel *model = [[GetrecordByGroupModel alloc] init];
             
             model.alarm = [set stringForColumn:@"TM_alarm"];
             model.content = [set stringForColumn:@"TM_content"];
             model.create_time = [set stringForColumn:@"TM_create_time"];
             model.department = [set stringForColumn:@"TM_department"];
             model.direction = [set stringForColumn:@"TM_direction"];
             model.gid = [set stringForColumn:@"TM_gid"];
             model.headpic = [set stringForColumn:@"TM_headpic"];
             model.interid = [set stringForColumn:@"TM_interid"];
             model.latitude = [set stringForColumn:@"TM_latitude"];
             model.longitude = [set stringForColumn:@"TM_longitude"];
             model.mode = [set stringForColumn:@"TM_mode"];
             model.orderid = [set stringForColumn:@"TM_orderid"];
             model.position = [set stringForColumn:@"TM_position"];
             model.realname = [set stringForColumn:@"TM_realname"];
             model.title = [set stringForColumn:@"TM_title"];
             model.type = [set stringForColumn:@"TM_type"];
             model.workid = [set stringForColumn:@"TM_workid"];
             model.workname = [set stringForColumn:@"workname"];
             model.video = [set stringForColumn:@"TM_video"];
             model.audio = [set stringForColumn:@"TM_audio"];
             model.picture = [set stringForColumn:@"TM_picture"];

             recordModel = model;
         }
         [set close];
         
     }];
    
    return recordModel;
    
    
}


- (BOOL)insertTaskMark:(GetrecordByGroupModel *)model {
    __block BOOL ret;
    if (![[LZXHelper isNullToString:model.workid] isEqualToString:@""]) {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into tm_taskmark(TM_alarm,TM_content,TM_create_time, TM_department,TM_direction,TM_gid,TM_headpic,TM_interid,TM_latitude,TM_longitude, TM_mode, TM_orderid,TM_position,TM_realname,TM_title,TM_type,TM_workid,TM_video, TM_audio,TM_picture) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.content, model.create_time, model.department, model.direction,model.gid,model.headpic,model.interid,model.latitude,model.longitude,model.mode, model.orderid, model.position, model.realname, model.title,model.type,model.workid,model.video,model.audio,model.picture];
    }];
    }
    return ret;
}

- (void)transactionInsertTaskMark:(NSArray *)array {

    __block BOOL res;
    __block NSInteger count = array.count;
   [[ZEBDatabaseHelper sharedInstance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
    
        for (int i = 0; i < count; i++) {
            GetrecordByGroupModel *model = array[i];
            BOOL ret ;
            NSString *sql = @"select * from tm_taskmark where TM_interid = ?";
            FMResultSet *rs = [db executeQuery:sql,model.interid];
            if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                
                ret = YES;
            }else{
                
                ret = NO;
            }
            [rs close];
            if (![[LZXHelper isNullToString:model.workid] isEqualToString:@""]) {
                if (ret) {
                    res = [db executeUpdate:@"update tm_taskmark set TM_alarm = ?,TM_content = ?,TM_create_time = ?, TM_department = ?,TM_direction = ?,TM_gid = ?,TM_headpic = ?,TM_latitude = ?,TM_longitude = ?, TM_mode = ?, TM_orderid = ?,TM_position = ?,TM_realname = ?,TM_title = ?,TM_type = ?,TM_workid = ?,TM_video = ?, TM_audio = ?,TM_picture = ? where TM_interid = ?",model.alarm, model.content, model.create_time, model.department, model.direction,model.gid,model.headpic,model.latitude,model.longitude,model.mode, model.orderid, model.position, model.realname, model.title,model.type,model.workid,model.video,model.audio,model.picture,model.interid];
                }else {
                    res = [db executeUpdate:@"insert into tm_taskmark(TM_alarm,TM_content,TM_create_time, TM_department,TM_direction,TM_gid,TM_headpic,TM_interid,TM_latitude,TM_longitude, TM_mode, TM_orderid,TM_position,TM_realname,TM_title,TM_type,TM_workid,TM_video, TM_audio,TM_picture) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.content, model.create_time, model.department, model.direction,model.gid,model.headpic,model.interid,model.latitude,model.longitude,model.mode, model.orderid, model.position, model.realname, model.title,model.type,model.workid,model.video,model.audio,model.picture];
                }
 
            }
            if (!res) {
                NSLog(@"break");
                *rollback = YES;
                return;
            }
            
        }
        
    }];
}
/*
 TM_alarm TEXT ,TM_content TEXT,TM_create_time TEXT,TM_department TEXT,TM_direction TEXT,TM_gid TEXT,TM_headpic TEXT,TM_interid TEXT,TM_latitude TEXT,TM_longitude TEXT,TM_mode TEXT,TM_orderid TEXT,TM_position TEXT,TM_realname TEXT,TM_title TEXT,TM_type TEXT,TM_workid TEXT,TM_video TEXT,TM_audio TEXT,TM_picture TEXT
 */
- (NSMutableArray *)selectTaskMarkByGid:(NSString *)gid {
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from tm_taskmark where TM_gid = ?",gid];
         while (set.next) {
             GetrecordByGroupModel *model = [[GetrecordByGroupModel alloc] init];
             model.alarm = [set stringForColumn:@"TM_alarm"];
             model.content = [set stringForColumn:@"TM_content"];
             model.create_time = [set stringForColumn:@"TM_create_time"];
             model.department = [set stringForColumn:@"TM_department"];
             model.direction = [set stringForColumn:@"TM_direction"];
             model.gid = [set stringForColumn:@"TM_gid"];
             model.headpic = [set stringForColumn:@"TM_headpic"];
             model.interid = [set stringForColumn:@"TM_interid"];
             model.latitude = [set stringForColumn:@"TM_latitude"];
             model.longitude = [set stringForColumn:@"TM_longitude"];
             model.mode = [set stringForColumn:@"TM_mode"];
             model.orderid = [set stringForColumn:@"TM_orderid"];
             model.position = [set stringForColumn:@"TM_position"];
             model.realname = [set stringForColumn:@"TM_realname"];
             model.title = [set stringForColumn:@"TM_title"];
             model.type = [set stringForColumn:@"TM_type"];
             model.workid = [set stringForColumn:@"TM_workid"];
             model.video = [set stringForColumn:@"TM_video"];
             model.audio = [set stringForColumn:@"TM_audio"];
             model.picture = [set stringForColumn:@"TM_picture"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;

    
}
@end
