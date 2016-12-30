//
//  DraftsListSQ.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DraftsListSQ.h"

@implementation DraftsListSQ

+ (instancetype)draftsListSQ {
    
    DraftsListSQ *dao = [[DraftsListSQ alloc] init];
    
    return dao;
}


// 插入一条信息到草稿箱列表
- (BOOL)insertDraftsList:(WorkAllTempModel *)model;
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into tb_DraftsList(Dr_alarm,Dr_audio,Dr_content,Dr_create_time, Dr_department,Dr_direction,Dr_gid,Dr_headpic,Dr_interid,Dr_latitude,Dr_longitude, Dr_mode, Dr_orderid,Dr_position,Dr_realname,Dr_title,Dr_type,Dr_workid,Dr_video, Dr_picture,Dr_cuid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.audio, model.content, model.create_time, model.department, model.direction,model.gid,model.headpic,model.interid,model.latitude,model.longitude,model.mode, model.orderid, model.position, model.realname, model.title,model.type,model.workId,model.video,model.picture,model.cuid];
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
- (BOOL)updataDraftsList:(WorkAllTempModel*)model {
   
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_DraftsList set Dr_alarm = ?,Dr_audio = ?,Dr_content = ?,Dr_create_time = ?, Dr_department = ?,Dr_direction = ?,Dr_gid = ?,Dr_headpic = ?,Dr_interid = ?,Dr_latitude = ?,Dr_longitude = ?, Dr_mode = ?, Dr_orderid = ?,Dr_position = ?,Dr_realname = ?,Dr_title = ?,Dr_type = ?,Dr_workid = ?,Dr_video = ?, Dr_picture = ? where Dr_cuid = ?",model.alarm, model.audio, model.content, model.create_time, model.department, model.direction,model.gid,model.headpic,model.interid,model.latitude,model.longitude,model.mode, model.orderid, model.position, model.realname, model.title,model.type,model.workId,model.video,model.picture,model.cuid];
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
// 查询草稿
- (NSMutableArray *)selectDraftsList:(NSString *)gid
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from tb_DraftsList where Dr_gid = ? order by Dr_create_time desc",gid];
         while (set.next) {
             WorkAllTempModel *model = [[WorkAllTempModel alloc] init];
             model.alarm = [set stringForColumn:@"Dr_alarm"];
             model.content = [set stringForColumn:@"Dr_content"];
             model.create_time = [set stringForColumn:@"Dr_create_time"];
             model.department = [set stringForColumn:@"Dr_department"];
             model.direction = [set stringForColumn:@"Dr_direction"];
             model.gid = [set stringForColumn:@"Dr_gid"];
             model.headpic = [set stringForColumn:@"Dr_headpic"];
             model.interid = [set stringForColumn:@"Dr_interid"];
             model.latitude = [set stringForColumn:@"Dr_latitude"];
             model.longitude = [set stringForColumn:@"Dr_longitude"];
             model.mode = [set stringForColumn:@"Dr_mode"];
             model.orderid = [set stringForColumn:@"Dr_orderid"];
             model.position = [set stringForColumn:@"Dr_position"];
             model.realname = [set stringForColumn:@"Dr_realname"];
             model.title = [set stringForColumn:@"Dr_title"];
             model.type = [set stringForColumn:@"Dr_type"];
             model.workId = [set stringForColumn:@"Dr_workid"];
             model.video = [set stringForColumn:@"Dr_video"];
             model.audio = [set stringForColumn:@"Dr_audio"];
             model.picture = [set stringForColumn:@"Dr_picture"];
             model.cuid = [set stringForColumn:@"Dr_cuid"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

//删除草稿
- (BOOL)deleteDraftsListByCuid:(NSString *)cuid
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from tb_DraftsList where Dr_cuid = ? ", cuid];
    }];
    return ret;
    ZEBLog(@"%d",ret);

}

@end
