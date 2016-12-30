//
//  UploadingSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UploadingSQ.h"


@interface UploadingSQ()


@end

@implementation UploadingSQ

+ (instancetype)uploadingDAO {
    
    UploadingSQ *dao = [[UploadingSQ alloc] init];
    
    return dao;
    
}
/*
 CREATE TABLE IF NOT EXISTS tb_uploading(UP_id INTEGER PRIMARY KEY AUTOINCREMENT,'UP_sid' TEXT , 'UP_rid' TEXT, 'UP_qid' INTEGER ,'UP_gps_h' TEXT,'UP_gps_w' TEXT,'UP_remote_mark_id' TEXT,'UP_time' TEXT unique,'UP_type' TEXT,'UP_mtype' TEXT,'UP_data' TEXT, 'UP_ptime' TEXT, 'UP_voicetime' TEXT, 'UP_videopic' TEXT, 'UP_cmd' TEXT, 'UP_workname' TEXT, 'UP_headpic' TEXT, 'UP_sname' TEXT);
 */
// 插入一条信息到列表
- (BOOL)insertUploading:(ICometModel *)model {

    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:[NSString stringWithFormat:
                                      @"INSERT INTO 'tb_uploading'('UP_sid', 'UP_rid', 'UP_qid','UP_cuid', 'UP_gps_h', 'UP_gps_w', 'UP_time', 'UP_type', 'UP_mtype', 'UP_data', 'UP_voicetime', 'UP_videopic', 'UP_cmd', 'UP_headpic', 'UP_sname','UP_msgfire') values('%@', '%@', %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@')", model.sid, model.rid, model.qid,model.cuid, model.longitude, model.latitude, model.time, model.type, model.mtype, model.data, model.voicetime, model.videopic, model.cmd, model.headpic, model.sname,model.FIRE]];
        if (!ret) {
            ZEBLog(@"dbp------%@",[db lastError]);
        }
    }];
    
      
        return ret;

}
// 删除指定cuid的消息
- (BOOL)deleteUploading:(NSString *)cuid {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
    ret = [db executeUpdate:@"delete from tb_uploading where UP_cuid = ? ", cuid];
            
    
    }];
   return ret;


}
// 根据cuid查询在消息列表对应的信息
- (ICometModel *)selectUploading:(NSString *)cuid {
    
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    
        FMResultSet *set = [db executeQuery:@"select * from tb_uploading where UP_cuid = ?", cuid];
        if (set.next) {
            
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"UP_sid"];
            model.rid = [set stringForColumn:@"UP_rid"];
            model.cuid = [set stringForColumn:@"UP_cuid"];
            model.time = [set stringForColumn:@"UP_time"];
            model.data = [set stringForColumn:@"UP_data"];
            model.qid = [[set stringForColumn:@"UP_qid"] integerValue];
            model.cmd = [set stringForColumn:@"UP_cmd"];
            model.headpic = [set stringForColumn:@"UP_headpic"];
            model.mtype = [set stringForColumn:@"UP_mtype"];
            model.type = [set stringForColumn:@"UP_type"];
            model.voicetime = [set stringForColumn:@"UP_voicetime"];
            model.videopic = [set stringForColumn:@"UP_videopic"];
            model.longitude = [set stringForColumn:@"UP_gps_h"];
            model.latitude = [set stringForColumn:@"UP_gps_w"];
            model.sname = [set stringForColumn:@"UP_sname"];
            model.FIRE = [set stringForColumn:@"UP_msgfire"];
            
            tempModel = model;
        }
        
        [set close];
    }];

    
    return tempModel;

}
// 查询所有的消息
- (NSMutableArray *)selectUploading {
   
    __block NSMutableArray *array = [NSMutableArray array];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from tb_uploading order by UP_time desc"];
        
        while (set.next) {
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"UP_sid"];
            model.rid = [set stringForColumn:@"UP_rid"];
            model.time = [set stringForColumn:@"UP_time"];
            model.data = [set stringForColumn:@"UP_data"];
            model.qid = [[set stringForColumn:@"UP_qid"] integerValue];
            model.cmd = [set stringForColumn:@"UP_cmd"];
            model.headpic = [set stringForColumn:@"UP_headpic"];
            model.mtype = [set stringForColumn:@"UP_mtype"];
            model.type = [set stringForColumn:@"UP_type"];
            model.voicetime = [set stringForColumn:@"UP_voicetime"];
            model.videopic = [set stringForColumn:@"UP_videopic"];
            model.longitude = [set stringForColumn:@"UP_gps_h"];
            model.latitude = [set stringForColumn:@"UP_gps_w"];
            model.sname = [set stringForColumn:@"UP_sname"];
            model.FIRE = [set stringForColumn:@"UP_msgfire"];
            
            [array addObject:model];
            
        }

        [set close];
    }];
    
    
    return array;
}

@end
