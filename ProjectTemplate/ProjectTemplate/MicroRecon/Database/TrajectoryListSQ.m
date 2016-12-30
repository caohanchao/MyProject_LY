//
//  TrajectoryListSQ.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TrajectoryListSQ.h"
#import "NSString+JSONCategories.h"

@implementation TrajectoryListSQ

+ (instancetype)trajectoryListSQ {
    
    TrajectoryListSQ *dao = [[TrajectoryListSQ alloc] init];
    
    return dao;
}


- (BOOL)insertTrajectoryList:(GetPathModel *)model {
    
    __block BOOL ret;
    NSString *JSONStr_location;
    
    if (model.location_list.count >0) {
        
        JSONStr_location = [LZXHelper toJSONString:model.location_list];
    }

    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into tb_trajectoryList('TL_alarm', 'TL_end_latitude','TL_end_longitude','TL_end_posi','TL_end_time','TL_head_pic','TL_position','TL_route_id','TL_route_title','TL_start_latitude','TL_start_longitude', 'TL_start_posi', 'TL_start_time', 'TL_task_id', 'TL_token', 'TL_type','TL_location_list', 'TL_gid','TL_cuid','TL_createtime','TL_describetion') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.alarm, model.end_latitude, model.end_longitude, model.end_posi, model.end_time, model.head_pic,model.position,model.route_id,model.route_title,model.start_latitude,model.start_longitude,model.start_posi, model.start_time, model.task_id, model.token, model.type,JSONStr_location,model.gid,model.cuid,model.createTime,model.describetion];
        ZEBLog(@"-------error=%@",[db.lastError description]);
    }];
    if (ret == YES) {
        ZEBLog(@"----------success");
    }
    else{
        ZEBLog(@"----------error");
    }
    return ret;
    
    
    
}

- (NSMutableArray *)selectTrajectoryList:(NSString *)gid {
    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from tb_trajectoryList where TL_gid = ?",gid];
         while (set.next) {
             GetPathModel *model = [[GetPathModel alloc] init];
             model.alarm = [set stringForColumn:@"TL_alarm"];
             model.end_latitude = [set stringForColumn:@"TL_end_latitude"];
             model.end_longitude = [set stringForColumn:@"TL_end_longitude"];
             model.end_posi = [set stringForColumn:@"TL_end_posi"];
             model.end_time = [set stringForColumn:@"TL_end_time"];
             model.head_pic = [set stringForColumn:@"TL_head_pic"];
             model.position = [set stringForColumn:@"TL_position"];
             model.route_id = [set stringForColumn:@"TL_route_id"];
             model.route_title = [set stringForColumn:@"TL_route_title"];
             model.start_latitude = [set stringForColumn:@"TL_start_latitude"];
             model.start_longitude = [set stringForColumn:@"TL_start_longitude"];
             model.start_posi = [set stringForColumn:@"TL_start_posi"];
             model.start_time = [set stringForColumn:@"TL_start_time"];
             model.task_id = [set stringForColumn:@"TL_task_id"];
             model.token = [set stringForColumn:@"TL_token"];
             model.type = [set stringForColumn:@"TL_type"];
             NSString *jsonStr = [set stringForColumn:@"TL_location_list"];
             model.location_list = [jsonStr toArrayOrNSDictionary];
             model.gid = [set stringForColumn:@"TL_gid"];
             model.cuid = [set stringForColumn:@"TL_cuid"];
             model.createTime = [set stringForColumn:@"TL_createtime"];
             model.describetion = [set stringForColumn:@"TL_describetion"];
             [array addObject:model];
         }
         [set close];
         
     }];
    
    return array;
}

- (BOOL)deleteTrajectoryListByCuid:(NSString *)cuid {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from tb_trajectoryList where TL_cuid = ? ", cuid];
    }];
    return ret;
    ZEBLog(@"%d",ret);
}
/*
 'TL_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'TL_alarm' TEXT , 'TL_end_latitude' TEXT,'TL_end_longitude' TEXT, 'TL_end_posi' TEXT,'TL_end_time' TEXT,'TL_head_pic' TEXT,'TL_position' TEXT,'TL_route_id' TEXT,'TL_route_title' TEXT,'TL_start_latitude' TEXT,'TL_start_longitude' TEXT, 'TL_start_posi' TEXT, 'TL_start_time' TEXT, 'TL_task_id' TEXT, 'TL_token' TEXT, 'TL_type' TEXT,'TL_location_list' TEXT, 'TL_gid' TEXT, 'TL_cuid' TEXT unique,'TL_createtime' TEXT, 'TL_describetion' TEXT
 */
- (BOOL)updataTrajectoryList:(GetPathModel*)model {
    __block BOOL ret;
    NSString *JSONStr_location;
    if (model.location_list.count >0) {
        JSONStr_location = [LZXHelper toJSONString:model.location_list];
    }
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_trajectoryList set TL_alarm = ?,TL_end_latitude = ?,TL_end_longitude = ?, TL_end_posi = ?,TL_end_time = ?,TL_head_pic = ?,TL_position = ?,TL_route_id = ?,TL_route_title = ?, TL_start_latitude = ?, TL_start_longitude = ?,TL_start_posi = ?,TL_start_time = ?,TL_task_id = ?,TL_token = ?,TL_type = ?,TL_location_list = ?, TL_gid = ?,TL_describetion = ? where TL_cuid = ?",model.alarm,model.end_latitude, model.end_longitude, model.end_posi, model.end_time, model.head_pic,model.position,model.route_id,model.route_title,model.start_latitude,model.start_longitude,model.start_posi, model.start_time, model.task_id, model.token, model.type,JSONStr_location,model.gid,model.describetion,model.cuid];
        ZEBLog(@"-------error=%@",[db.lastError description]);
    }];
    if (ret == YES) {
        ZEBLog(@"----------success");
    }
    else{
        ZEBLog(@"----------error");
    }
    return ret;
}

@end
