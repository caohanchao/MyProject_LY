//
//  MessageDAO.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MessageDAO.h"

@interface MessageDAO()


@end

@implementation MessageDAO

+ (instancetype)messageDAO {
    MessageDAO *dao = [[MessageDAO alloc] init];
    return dao;
}

// 插入一条新的消息
- (BOOL)insertMessage:(ICometModel *)model {
    if ([self selectMessageByQid:model.qid] || [self selectMessageByMsgid:model.msGid]) {
        return NO;
    }
    
//    [[[DBManager sharedManager] uploadingSQ] deleteUploading:model.cuid];

//    if ([model.FIRE containsString:@"LOCK"]||[model.FIRE containsString:@"READ"]) {
//
//        if ([model.mtype isEqualToString:@"S"]||[model.mtype isEqualToString:@"P"]||[model.mtype isEqualToString:@"V"]) {
//            return NO;
//        }
//    }
    
    NSString *name = model.sname;
    if ([[LZXHelper isNullToString:name] isEqualToString:@""]) {
        name = model.cname;
    }
    
    if ([model.cmd isEqualToString:@"1"]) {
        if ([model.mtype isEqualToString:@"T"]) {
            NSString *str = [model.data transferredMeaningWithEnter];
            model.data = str;
        }
    }
    
    NSString *workname = @"";
    NSString *markDataId = @"";
    NSString *workid = @"";

    if ([model.cmd isEqualToString:@"5"]) {
        
        if ([model.mtype isEqualToString:@"N"]) {
            workname = model.taskNDataModel.workname;
            markDataId = model.taskNDataModel.dataid;
        }else if ([model.mtype isEqualToString:@"T"]) {
            workname = model.taskTDataModel.workname;
            markDataId = model.taskTDataModel.dataid;
        }else if ([model.mtype isEqualToString:@"F"]) {
            workname = model.taskFDataModel.workname;
            markDataId = model.taskFDataModel.dataid;
        }else if ([model.mtype isEqualToString:@"S"]) {
            workname = model.suspectSDataModel.suspectname;
            workid = model.suspectSDataModel.suspectid;
        }
       
    }
    

    
    __block BOOL ret;
        [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
            ret = [db executeUpdate:[NSString stringWithFormat:
                                          @"INSERT INTO 'tb_message'('me_sid', 'me_rid', 'me_qid', 'me_gps_h', 'me_gps_w', 'me_time', 'me_type', 'me_mtype', 'me_data', 'me_voicetime', 'me_videopic', 'me_cmd', 'me_headpic', 'me_sname', 'me_workname', 'me_markDataId', 'me_DEType', 'me_DEName', 'me_btime', 'me_msgid', 'me_workid','me_msgfire','me_timeStr','me_msgNotShow') values('%@', '%@', %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", model.sid, model.rid, model.qid, model.longitude, model.latitude, model.time, model.type, model.mtype, model.data, model.voicetime, model.videopic, model.cmd, model.headpic, name,workname,markDataId,model.DE_type,model.DE_name,model.beginTime,model.msGid,workid,model.FIRE,model.timeStr,@"NO"]];
        }];
       
        return ret;

}




// 根据me_qid查询消息
- (ICometModel *)selectMessageByQid:(NSInteger)qid {
    
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"select * from tb_message where me_qid = %ld", qid]];
        while (set && set.next) {
            
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"me_sid"];
            model.rid = [set stringForColumn:@"me_rid"];
            model.time = [set stringForColumn:@"me_time"];
            model.data = [set stringForColumn:@"me_data"];
            model.qid = [[set stringForColumn:@"me_qid"] integerValue];
            model.cmd = [set stringForColumn:@"me_cmd"];
            model.headpic = [set stringForColumn:@"me_headpic"];
            model.mtype = [set stringForColumn:@"me_mtype"];
            model.type = [set stringForColumn:@"me_type"];
            model.voicetime = [set stringForColumn:@"me_voicetime"];
            model.videopic = [set stringForColumn:@"me_videopic"];
            model.longitude = [set stringForColumn:@"me_gps_h"];
            model.latitude = [set stringForColumn:@"me_gps_w"];
            model.sname = [set stringForColumn:@"me_sname"];
            model.workname = [set stringForColumn:@"me_workname"];
            model.markdataId = [set stringForColumn:@"me_markDataId"];
            model.DE_type = [set stringForColumn:@"me_DEType"];
            model.DE_name = [set stringForColumn:@"me_DEName"];
            model.beginTime =[set stringForColumn:@"me_btime"];
            model.msGid = [set stringForColumn:@"me_msgid"];
            model.worId = [set stringForColumn:@"me_workid"];
            model.FIRE = [set stringForColumn:@"me_msgfire"];
            model.timeStr = [set stringForColumn:@"me_timeStr"];
            model.messageNotShow = [set stringForColumn:@"me_msgNotShow"];
            tempModel = model;
        }
        [set close];
    }];

    return tempModel;
}

- (NSMutableArray *)selectSystemMessageByPage:(NSInteger)page {

    __block NSMutableArray *array = [NSMutableArray array];
    
    __block NSInteger pagesize = 10;
    NSString *type = @"B";
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
         FMResultSet *set = [db executeQuery:@"select * from tb_message where me_type = ? order by me_btime desc limit ?,?", type,@((page-1)*pagesize),@(pagesize)];
         
         while (set && set.next) {
             ICometModel *model = [[ICometModel alloc] init];
             model.sid = [set stringForColumn:@"me_sid"];
             model.rid = [set stringForColumn:@"me_rid"];
             model.time = [set stringForColumn:@"me_time"];
             model.data = [set stringForColumn:@"me_data"];
             model.qid = [[set stringForColumn:@"me_qid"] integerValue];
             model.cmd = [set stringForColumn:@"me_cmd"];
             model.headpic = [set stringForColumn:@"me_headpic"];
             model.mtype = [set stringForColumn:@"me_mtype"];
             model.type = [set stringForColumn:@"me_type"];
             model.voicetime = [set stringForColumn:@"me_voicetime"];
             model.videopic = [set stringForColumn:@"me_videopic"];
             model.longitude = [set stringForColumn:@"me_gps_h"];
             model.latitude = [set stringForColumn:@"me_gps_w"];
             model.sname = [set stringForColumn:@"me_sname"];
             model.workname = [set stringForColumn:@"me_workname"];
             model.markdataId = [set stringForColumn:@"me_markDataId"];
             model.DE_type = [set stringForColumn:@"me_DEType"];
             model.DE_name = [set stringForColumn:@"me_DEName"];
             model.beginTime =[set stringForColumn:@"me_btime"];
             model.worId = [set stringForColumn:@"me_workid"];
             model.FIRE = [set stringForColumn:@"me_msgfire"];
             model.timeStr = [set stringForColumn:@"me_timeStr"];
             model.messageNotShow = [set stringForColumn:@"me_msgNotShow"];
             
             if (![model.messageNotShow boolValue]) {
                 [array addObject:model];
             }

         }
         [set close];
         
     }];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    NSMutableArray *arr = [NSMutableArray array];
    for (ICometModel *model in array) {
        // 消息过滤
        if ([@"G" isEqualToString:model.type]) {
            if ([[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:model.rid]) {
                [arr addObject:model];
            }
        }else if ([@"S" isEqualToString:model.type]) {
            if ([model.sid isEqualToString:alarm]) {
                [arr addObject:model];
            }else if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:model.sid]) {
                [arr addObject:model];
            }
        }else if ([@"B" isEqualToString:model.type]) {
            [arr addObject:model];
        }
    }
    array = nil;
    return arr;

}

// 根据msgid查询消息
- (ICometModel *)selectMessageByMsgid:(NSString *)msgid {
    
    __block ICometModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"select * from tb_message where me_msgid = %@", msgid]];
        while (set && set.next) {
            
            ICometModel *model = [[ICometModel alloc] init];
            model.sid = [set stringForColumn:@"me_sid"];
            model.rid = [set stringForColumn:@"me_rid"];
            model.time = [set stringForColumn:@"me_time"];
            model.data = [set stringForColumn:@"me_data"];
            model.qid = [[set stringForColumn:@"me_qid"] integerValue];
            model.cmd = [set stringForColumn:@"me_cmd"];
            model.headpic = [set stringForColumn:@"me_headpic"];
            model.mtype = [set stringForColumn:@"me_mtype"];
            model.type = [set stringForColumn:@"me_type"];
            model.voicetime = [set stringForColumn:@"me_voicetime"];
            model.videopic = [set stringForColumn:@"me_videopic"];
            model.longitude = [set stringForColumn:@"me_gps_h"];
            model.latitude = [set stringForColumn:@"me_gps_w"];
            model.sname = [set stringForColumn:@"me_sname"];
            model.workname = [set stringForColumn:@"me_workname"];
            model.markdataId = [set stringForColumn:@"me_markDataId"];
            model.DE_type = [set stringForColumn:@"me_DEType"];
            model.DE_name = [set stringForColumn:@"me_DEName"];
            model.beginTime =[set stringForColumn:@"me_btime"];
            model.msGid = [set stringForColumn:@"me_msgid"];
            model.worId = [set stringForColumn:@"me_workid"];
            model.FIRE = [set stringForColumn:@"me_msgfire"];
            model.timeStr = [set stringForColumn:@"me_timeStr"];
            model.messageNotShow = [set stringForColumn:@"me_msgNotShow"];
            tempModel = model;
            
        }
        [set close];
    }];
    
    return tempModel;
}

// 获取指定页码的消息列表
- (NSArray *)selectMessages:(NSString *)chatType maxQid:(NSInteger)maxQid page:(NSInteger)page {
    __block NSMutableArray *array = [NSMutableArray array];
    
    __block NSInteger pagesize = 10;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    __block NSString *alarm = [user objectForKey:@"alarm"];
    __block NSString *chatId = [user objectForKey:@"chatId"];
    
    __block FMResultSet *set = nil;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([@"S" isEqualToString:chatType]) {
            //select count(*) from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?)
            set = [db executeQuery:@"select * from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?) order by me_btime desc limit ?,?", alarm, chatId, chatId, alarm,@((page-1)*pagesize),@(pagesize)];
        } else if ([@"G" isEqualToString:chatType]) {
            set = [db executeQuery:@"select * from tb_message where me_rid = ? order by me_btime desc limit ?,?",chatId,@((page-1)*pagesize),@(pagesize)];
        }
        
        while (set && set.next) {
            ICometModel *model = [[ICometModel alloc] init];
            
            //[set intForColumn:@"count(*)"];
            model.sid = [set stringForColumn:@"me_sid"];
            model.rid = [set stringForColumn:@"me_rid"];
            model.time = [set stringForColumn:@"me_time"];
            model.data = [set stringForColumn:@"me_data"];
            model.qid = [[set stringForColumn:@"me_qid"] integerValue];
            model.cmd = [set stringForColumn:@"me_cmd"];
            model.headpic = [set stringForColumn:@"me_headpic"];
            model.mtype = [set stringForColumn:@"me_mtype"];
            model.type = [set stringForColumn:@"me_type"];
            model.voicetime = [set stringForColumn:@"me_voicetime"];
            model.videopic = [set stringForColumn:@"me_videopic"];
            model.longitude = [set stringForColumn:@"me_gps_h"];
            model.latitude = [set stringForColumn:@"me_gps_w"];
            model.sname = [set stringForColumn:@"me_sname"];
            model.workname = [set stringForColumn:@"me_workname"];
            model.markdataId = [set stringForColumn:@"me_markDataId"];
            model.DE_type = [set stringForColumn:@"me_DEType"];
            model.DE_name = [set stringForColumn:@"me_DEName"];
            model.beginTime =[set stringForColumn:@"me_btime"];
            model.msGid = [set stringForColumn:@"me_msgid"];
            model.worId = [set stringForColumn:@"me_workid"];
            model.FIRE = [set stringForColumn:@"me_msgfire"];
            model.timeStr = [set stringForColumn:@"me_timeStr"];
            model.messageNotShow = [set stringForColumn:@"me_msgNotShow"];
            if (![model.messageNotShow boolValue]) {
                [array addObject:model];
            }
            
        }
        
        [set close];
        
    }];
    NSMutableArray *arr = [NSMutableArray array];
    for (ICometModel *model in array) {
        // 消息过滤
        if ([@"G" isEqualToString:model.type]) {
            if ([[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:model.rid]) {
                [arr addObject:model];
            }
        }else if ([@"S" isEqualToString:model.type]) {
            if ([model.sid isEqualToString:alarm]) {
                [arr addObject:model];
            }else if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:model.sid]) {
                [arr addObject:model];
            }
        }else if ([@"B" isEqualToString:model.type]) {
            [arr addObject:model];
        }
    }
    array = nil;
    return arr;
}

// 获取最大Qid
- (NSInteger)getMaxQid {
    
    __block NSInteger maxQid = 0;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select max(me_qid) from tb_message"];
        
        while (set.next) {
            maxQid = [[set stringForColumn:@"max(me_qid)"] integerValue];
        }
        
        [set close];
    
    }];
    return maxQid;
}
// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateUserlist:(ICometModel *)model {
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *alarm = [user objectForKey:@"alarm"];
        
        if ([@"S" isEqualToString:model.type] && [alarm isEqualToString:model.rid]) {
            model.rid = model.sid;
        }
        
        if ([self selectMessageByQid:model.qid]) {
          //  return [self updateUserlist:model];
        } else {
            return [self insertMessage:model];
        }
    
    
    return NO;
}
// 更新消息信息
- (BOOL)updateQidfireUserlist:(NSString *)qid fire:(NSString *)fire  {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_message set me_msgfire = ? where me_qid = ?",fire,qid];
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
- (BOOL)updateMsgfireUserlist:(NSString *)msgid fire:(NSString *)fire  {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_message set me_msgfire = ? where me_msgid = ?",fire,msgid];
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

- (BOOL)updateMsgTimeUserlist:(NSString *)msgid fire:(NSString *)timerStr  {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_message set me_timeStr = ? where me_msgid = ?",timerStr,msgid];
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

- (NSInteger)getMaxQidSingle {
    __block NSInteger maxQid = 0;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    __block NSString *alarm = [user objectForKey:@"alarm"];
    __block NSString *chatId = [user objectForKey:@"chatId"];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select max(me_qid) from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?)", alarm, chatId, chatId, alarm];
        
        while (set.next) {
            maxQid = [[set stringForColumn:@"max(me_qid)"] integerValue];
        }
        
        [set close];
    
    }];
    

    return maxQid;
}
- (NSInteger)getMaxQidSingleByChatId:(NSString *)chatId {
    __block NSInteger maxQid = 0;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    __block NSString *alarm = [user objectForKey:@"alarm"];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select max(me_qid) from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?)", alarm, chatId, chatId, alarm];
        
        while (set.next) {
            maxQid = [[set stringForColumn:@"max(me_qid)"] integerValue];
        }
        
        [set close];
        
    }];
    
    
    return maxQid;
}
// 获取最小Qid
- (NSInteger)getMinQidSingle {
    __block NSInteger minQid = 0;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    __block NSString *alarm = [user objectForKey:@"alarm"];
    __block NSString *chatId = [user objectForKey:@"chatId"];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select min(me_qid) from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?)", alarm, chatId, chatId, alarm];
        
        while (set.next) {
            minQid = [[set stringForColumn:@"min(me_qid)"] integerValue];
        }
        
        [set close];
    }];
    
    return minQid;
}
// 获取最大Qid
- (NSInteger)getMaxQidGroup {
    __block NSInteger maxQid = 0;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    __block NSString *qid = [user objectForKey:@"chatId"];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select max(me_qid) from tb_message where me_rid = ?", qid];
        
        while (set.next) {
            maxQid = [[set stringForColumn:@"max(me_qid)"] integerValue];
        }
        
        [set close];
    }];
    
    
    return maxQid;
}
// 获取最大Qid
- (NSInteger)getMaxQidGroupByChatId:(NSString *)chatId {
    __block NSInteger maxQid = 0;

    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select max(me_qid) from tb_message where me_rid = ?", chatId];
        
        while (set.next) {
            maxQid = [[set stringForColumn:@"max(me_qid)"] integerValue];
        }
        
        [set close];
    }];
    
    
    return maxQid;
}
// 获取最小Qid
- (NSInteger)getMinQidGroup {
       __block NSInteger minQid = 0;
   
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        __block NSString *qid = [user objectForKey:@"chatId"];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //得到结果集
        FMResultSet *set = [db executeQuery:@"select min(me_qid) from tb_message where me_rid = ?", qid];
        
        while (set.next) {
            minQid = [[set stringForColumn:@"min(me_qid)"] integerValue];
        }
        
        [set close];
    
    }];
    
    
    return minQid;
}
//删除指定的应用数据 根据指定的ID
- (BOOL)clearGroupMessage:(NSString *)_id {
    
    __block BOOL isSuccess;
   [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
       NSString *sql = @"delete from tb_message where me_rid = ?";
       isSuccess = [db executeUpdate:sql, _id];
       if (!isSuccess) {
           NSLog(@"delete error:%@",db.lastErrorMessage);
       }

   }];
    return isSuccess;
}

//查询与聊天人的消息缓存

// 获取消息列表分页数
- (int)getSelectMessagesCount:(NSString *)chatType{
    __block NSMutableArray *array = [NSMutableArray array];

    __block NSInteger pagesize = 10;
      __block  int count=0;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    __block NSString *alarm = [user objectForKey:@"alarm"];
    __block NSString *chatId = [user objectForKey:@"chatId"];
    __block FMResultSet *set = nil;
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if ([@"S" isEqualToString:chatType]) {
            //select count(*) from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?)
            set = [db executeQuery:@"select count(*) from tb_message where (me_sid = ? and me_rid = ?) or (me_sid = ? and me_rid = ?)", alarm, chatId, chatId, alarm];
        } else if ([@"G" isEqualToString:chatType]) {
            set = [db executeQuery:@"select count(*) from tb_message where me_rid = ?",chatId];
        }
        
        while (set && set.next) {
            //        ICometModel *model = [[ICometModel alloc] init];
            
            count=[set intForColumn:@"count(*)"];
            
            
        }
        [set close];
    
    }];
     int sum=count%pagesize==0?count/pagesize:count/pagesize+1;
    
        return sum;
}
// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateUserlistOfchatModel:(chatModel *)model {
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *alarm = [user objectForKey:@"alarm"];
        
        if ([@"S" isEqualToString:model.TYPE] && [alarm isEqualToString:model.RID]) {
            model.RID = model.SID;
        }
        
        if (![self selectMessageByQid:model.QID]) {
            return [self insertMessageOfchatModell:model];
        } else {
           
        }
    
    return NO;
}
// 插入一条新的消息
- (BOOL)insertMessageOfchatModell:(chatModel *)model {
   
    if ([self selectMessageByQid:model.QID] || [self selectMessageByMsgid:model.MSGID]) {
        return NO;
    }
    
    if ([model.MSG.FIRE containsString:@"LOCK"]||[model.MSG.FIRE containsString:@"READ"]) {
        if ([model.MSG.MTYPE isEqualToString:@"S"]||[model.MSG.MTYPE isEqualToString:@"P"]||[model.MSG.MTYPE isEqualToString:@"V"]) {
            return NO;
        }
    }
    
    if ([model.CMD isEqualToString:@"1"]) {
        if ([model.MSG.MTYPE isEqualToString:@"T"]) {
            NSString *str = [model.MSG.DATA transferredMeaningWithEnter];
            model.MSG.DATA = str;
        }
    }
    NSString *workname = @"";
    NSString *markDataId =@"";
    NSString *workid = @"";
    if ([model.CMD isEqualToString:@"5"]) {
        
        if ([model.MSG.MTYPE isEqualToString:@"N"]) {
            workname = model.MSG.taskNDataModel.workname;
            markDataId = model.MSG.taskNDataModel.dataid;
        }else if ([model.MSG.MTYPE isEqualToString:@"T"]) {
            workname = model.MSG.taskTDataModel.workname;
            markDataId = model.MSG.taskTDataModel.dataid;
        }else if ([model.MSG.MTYPE isEqualToString:@"F"]) {
            workname = model.MSG.taskFDataModel.workname;
            markDataId = model.MSG.taskFDataModel.dataid;
        }else if ([model.MSG.MTYPE isEqualToString:@"S"]) {
            workname = model.MSG.suspectSDataModel.suspectname;
            workid = model.MSG.suspectSDataModel.suspectid;
        }
        
    }
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    
        ret = [db executeUpdate:[NSString stringWithFormat:
                                      @"INSERT INTO 'tb_message'('me_sid', 'me_rid', 'me_qid', 'me_gps_h', 'me_gps_w', 'me_time','me_btime', 'me_type', 'me_mtype', 'me_data', 'me_voicetime', 'me_videopic', 'me_cmd', 'me_headpic', 'me_sname','me_workname','me_markDataId', 'me_msgid','me_workid','me_msgfire','me_timeStr','me_msgNotShow') values('%@', '%@', %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@')", model.SID, model.RID, model.QID, model.GPS.H, model.GPS.W, model.TIME,model.beginTime, model.TYPE, model.MSG.MTYPE, model.MSG.DATA, model.MSG.VOICETIME, model.MSG.VIDEOPIC, model.CMD, model.HEADPIC,model.SNAME,workname,markDataId, model.MSGID,workid,model.MSG.FIRE,model.timeStr,@"NO"]];
        if (!ret) {
            ZEBLog(@"插入失败----%@",db.lastError);
        }
        

    }];
       
        
     return ret;
   

}
// 更新消息信息
- (BOOL)updateUserlistOfchatModel:(chatModel *)model {

    __block BOOL ret;
   [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
   ret = [db executeUpdate:@"update tb_message set me_sid = ?,me_rid = ?, me_gps_h = ?, me_gps_w = ?, me_time = ?, me_btime = ?, me_type = ?, me_mtype = ?, me_data = ?, me_voicetime = ?, me_videopic = ?, me_cmd = ?, me_headpic = ?, me_sname = ?, me_msgid = ?, me_msgfire = ? ,me_timeStr = ? where me_qid = ?",model.SID,model.RID,model.GPS.H,model.GPS.W,model.TIME,model.beginTime,model.TYPE,model.MSG.MTYPE,model.MSG.DATA,model.MSG.VOICETIME, model.MSG.VIDEOPIC,model.CMD,model.HEADPIC,model.SNAME,model.MSGID,model.MSG.FIRE,model.timeStr,model.QID];
   }];
       
        return ret;
        
}
// 根据qid删除消息信息
- (BOOL)deleteMessageForQid:(NSInteger)qid {
    ICometModel *model = [self selectMessageByQid:qid];
    if (!model.messageNotShow) {
        return NO;
    }
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"update tb_message set me_msgNotShow = ? where me_qid = ?",@"YES",[NSString stringWithFormat:@"%ld",qid]];
    }];
    
    return ret;
    
}
// 根据Msgid删除消息
- (BOOL)deleteMessageForMsgid:(NSString *)msgid{
    
     __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"delete from tb_message where me_msgid = ?", msgid];
    }];
    return ret;
}

// 根据msgid查询消息
- (chatModel *)selectChatMessageByMsgid:(NSString *)msgid {
    
    __block chatModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"select * from tb_message where me_msgid = %@", msgid]];
        while (set && set.next) {
            
            chatModel *model = [[chatModel alloc] init];
            model.SID = [set stringForColumn:@"me_sid"];
            model.RID = [set stringForColumn:@"me_rid"];
            model.TIME = [set stringForColumn:@"me_time"];
            model.MSG.DATA = [set stringForColumn:@"me_data"];
            model.QID = [[set stringForColumn:@"me_qid"] integerValue];
            model.CMD = [set stringForColumn:@"me_cmd"];
            model.HEADPIC = [set stringForColumn:@"me_headpic"];
            model.MSG.MTYPE = [set stringForColumn:@"me_mtype"];
            model.TYPE = [set stringForColumn:@"me_type"];
            model.MSG.VOICETIME = [set stringForColumn:@"me_voicetime"];
            model.MSG.VIDEOPIC = [set stringForColumn:@"me_videopic"];
            model.GPS.H = [set stringForColumn:@"me_gps_h"];
            model.GPS.W = [set stringForColumn:@"me_gps_w"];
            model.SNAME = [set stringForColumn:@"me_sname"];
            model.beginTime =[set stringForColumn:@"me_btime"];
            model.MSGID = [set stringForColumn:@"me_msgid"];
            model.MSG.FIRE = [set stringForColumn:@"me_msgfire"];
            model.timeStr = [set stringForColumn:@"me_timeStr"];
            tempModel = model;
            
        }
        [set close];
    }];
    
    return tempModel;
}
// 清除表
- (BOOL) clearMessage
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"tb_message"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}
@end
