//
//  MessageResendSQ.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MessageResendSQ.h"

@implementation MessageResendSQ

+ (instancetype)messageResendSQ {
    MessageResendSQ *dao = [[MessageResendSQ alloc] init];
    return dao;
}


- (BOOL)insertMessage:(ICometModel *)model {
    
    if ([self selectMessageByCuid:model.cuid]) {
        return NO;
    }
    
    NSString *name = model.sname;
    if ([[LZXHelper isNullToString:name] isEqualToString:@""]) {
        name = model.cname;
    }
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:[NSString stringWithFormat:
                                 @"INSERT INTO tb_messageResend('mr_sid', 'mr_rid', 'mr_qid', 'mr_gps_h', 'mr_gps_w', 'mr_time', 'mr_type', 'mr_mtype', 'mr_data', 'mr_voicetime', 'mr_videopic', 'mr_cmd', 'mr_headpic', 'mr_sname', 'mr_DEType', 'mr_DEName', 'mr_btime','mr_msgstate', 'mr_msgid', 'mr_cuid','mr_msgfire') values('%@', '%@', %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@','%@','%@','%@','%@','%@')", model.sid, model.rid, model.qid, model.longitude, model.latitude, model.time, model.type, model.mtype, model.data, model.voicetime, model.videopic, model.cmd, model.headpic, name,model.DE_type,model.DE_name,model.beginTime,model.messageState,model.msGid,model.cuid,model.FIRE]];
        
        
        if (!ret) {
            ZEBLog(@"插入失败----%@",db.lastError);
        }
    }];
    
    
    
    return ret;

}

- (ICometModel *)selectMessageByCuid:(NSString *)cuid{
    
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"select * from tb_messageResend where mr_cuid = %@", cuid]];
        while (set && set.next) {
            
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"mr_sid"];
            model.rid = [set stringForColumn:@"mr_rid"];
            model.time = [set stringForColumn:@"mr_time"];
            model.data = [set stringForColumn:@"mr_data"];
            model.qid = [[set stringForColumn:@"mr_qid"] integerValue];
            model.cmd = [set stringForColumn:@"mr_cmd"];
            model.headpic = [set stringForColumn:@"mr_headpic"];
            model.mtype = [set stringForColumn:@"mr_mtype"];
            model.type = [set stringForColumn:@"mr_type"];
            model.voicetime = [set stringForColumn:@"mr_voicetime"];
            model.videopic = [set stringForColumn:@"mr_videopic"];
            model.longitude = [set stringForColumn:@"mr_gps_h"];
            model.latitude = [set stringForColumn:@"mr_gps_w"];
            model.sname = [set stringForColumn:@"mr_sname"];
            model.DE_type = [set stringForColumn:@"mr_DEType"];
            model.DE_name = [set stringForColumn:@"mr_DEName"];
            model.beginTime =[set stringForColumn:@"mr_btime"];
            model.msGid = [set stringForColumn:@"mr_msgid"];
            model.cuid = [set stringForColumn:@"mr_cuid"];
            model.messageState = [set stringForColumn:@"mr_msgstate"];
            model.FIRE = [set stringForColumn:@"mr_msgfire"];
            tempModel = model;
            
        }
        [set close];
    }];
    
    return tempModel;
}

// 查询所有的消息
- (NSMutableArray *)selectMessage {
    
    __block NSMutableArray *array = [NSMutableArray array];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from tb_messageResend order by mr_time desc"];
        
        while (set.next) {
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"mr_sid"];
            model.rid = [set stringForColumn:@"mr_rid"];
            model.time = [set stringForColumn:@"mr_time"];
            model.data = [set stringForColumn:@"mr_data"];
            model.qid = [[set stringForColumn:@"mr_qid"] integerValue];
            model.cmd = [set stringForColumn:@"mr_cmd"];
            model.headpic = [set stringForColumn:@"mr_headpic"];
            model.mtype = [set stringForColumn:@"mr_mtype"];
            model.type = [set stringForColumn:@"mr_type"];
            model.voicetime = [set stringForColumn:@"mr_voicetime"];
            model.videopic = [set stringForColumn:@"mr_videopic"];
            model.longitude = [set stringForColumn:@"mr_gps_h"];
            model.latitude = [set stringForColumn:@"mr_gps_w"];
            model.sname = [set stringForColumn:@"mr_sname"];
            model.DE_type = [set stringForColumn:@"mr_DEType"];
            model.DE_name = [set stringForColumn:@"mr_DEName"];
            model.beginTime =[set stringForColumn:@"mr_btime"];
            model.msGid = [set stringForColumn:@"mr_msgid"];
            model.cuid = [set stringForColumn:@"mr_cuid"];
            model.messageState = [set stringForColumn:@"mr_msgstate"];
            model.FIRE = [set stringForColumn:@"mr_msgfire"];
            
            [array addObject:model];
            
        }
        
        [set close];
    }];
    
    
    return array;
}

// 根据Msgid删除消息
- (BOOL)deleteMessageByCuid:(NSString *)cuid {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"delete from tb_messageResend where mr_cuid = ?", cuid];
    }];
    return ret;
}


@end
