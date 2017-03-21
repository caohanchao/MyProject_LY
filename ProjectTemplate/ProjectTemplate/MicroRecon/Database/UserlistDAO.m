//
//  UserlistDAO.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserlistDAO.h"
@interface UserlistDAO()



@end

@implementation UserlistDAO

+ (instancetype)userlistDAO {
    UserlistDAO *dao = [[UserlistDAO alloc] init];
   
    return dao;
}

// 插入一条信息到消息列表
- (BOOL)insertUserlist:(ICometModel *)model {
    
//    if ([model.FIRE containsString:@"LOCK"]) {
//        if ([model.mtype isEqualToString:@"S"]||[model.mtype isEqualToString:@"P"]||[model.mtype isEqualToString:@"V"]) {
//            return NO;
//        }
//    }
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        NSString *msgCount = [model.sid isEqualToString:alarm] ? @"0" : @"1";
        
        NSString *name = model.sname;
        NSString *data = model.data;
        
        if ([[LZXHelper isNullToString:name] isEqualToString:@""]) {
            name = model.cname;
        }
       
        if ([self isAtMe:model.atAlarm]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"@%@",model.rid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([model.data rangeOfString:@"[img]file:///storage/emulated/0/MicroRecon/Emoticons/"].location != NSNotFound) {
            data = @"[动画表情]";
        }
        ret = [db executeUpdate:@"insert into tb_userlist(ut_cmd,ut_sendid, ut_alarm, ut_headpic, ut_fire,ut_name, ut_type, ut_mtype, ut_message, ut_time, ut_newmsgcount) values(?,?,?,?,?,?,?,?,?,?,?)",model.cmd, model.sid, model.rid, model.headpic,model.FIRE, name, model.type, model.mtype, data, model.beginTime, msgCount];
       
        }];
        return ret;
  
}

//- (BOOL)insertUserlistWithChatModel:(chatModel *)model {
//    __block BOOL ret;
//    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
//        
//        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
//        NSString *msgCount = [model.SID isEqualToString:alarm] ? @"0" : @"1";
//        
//        NSString *name = model.SNAME;
////        if ([[LZXHelper isNullToString:name] isEqualToString:@""]) {
////            name = model.cname;
////        }
//        
//        if ([self isAtMe:model.atAlarm]) {
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"@%@",model.rid]];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        ret = [db executeUpdate:@"insert into tb_userlist(ut_cmd,ut_sendid, ut_alarm, ut_headpic, ut_fire,ut_name, ut_type, ut_mtype, ut_message, ut_time, ut_newmsgcount) values(?,?,?,?,?,?,?,?,?,?,?)",model.cmd, model.sid, model.rid, model.headpic,model.FIRE, name, model.type, model.mtype, model.data, model.beginTime, msgCount];
//        
//    }];
//    return ret;
//}

// 更新消息列表信息
- (BOOL)updateUserlist:(ICometModel *)model {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        NSInteger count = 0 ;
        FMResultSet *set = [db executeQuery:@"select ut_newmsgcount from tb_userlist where ut_alarm = ?", model.rid];
        while (set && set.next) {
            
            count = [[set stringForColumn:@"ut_newmsgcount"] integerValue];
        }
        [set close];
        
        NSInteger msgCount = count;
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        if (![model.sid isEqualToString:alarm]) {
            msgCount++;
        }
        NSString *name = model.sname;
        NSString *data = model.data;
        if ([[LZXHelper isNullToString:name] isEqualToString:@""]) {
            name = model.cname;
        }
       
        if ([self isAtMe:model.atAlarm]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"@%@",model.rid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        if ([model.data rangeOfString:@"[img]file:///storage/emulated/0/MicroRecon/Emoticons/"].location != NSNotFound) {
            data = @"[动画表情]";
        }
        NSString *newMsgCount = [NSString stringWithFormat:@"%ld", msgCount];
        ret = [db executeUpdate:@"update tb_userlist set ut_cmd = ?,ut_sendid = ?,ut_headpic = ?, ut_fire = ?, ut_name = ?, ut_mtype = ?, ut_message = ?, ut_time = ?, ut_newmsgcount = ? where ut_alarm = ?",model.cmd, model.sid, model.headpic,model.FIRE, name, model.mtype, data, model.beginTime, newMsgCount, model.rid];
       
    }];
        return ret;
        
    
    
    
}

// 根据id查询在消息列表对应的消息
- (UserlistModel *)selectUserlistById:(NSString *)chatId {
    
    __block UserlistModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {

        FMResultSet *set = [db executeQuery:@"select * from tb_userlist where ut_alarm = ?", chatId];
        if (set.next) {
            UserlistModel *model = [[UserlistModel alloc] init];
            model.ut_id = [[set stringForColumn:@"ut_id"] integerValue];
            model.ut_cmd = [set stringForColumn:@"ut_cmd"];
            model.ut_sendid = [set stringForColumn:@"ut_sendid"];
            model.ut_alarm = [set stringForColumn:@"ut_alarm"];
            model.ut_headpic = [set stringForColumn:@"ut_headpic"];
            model.ut_name = [set stringForColumn:@"ut_name"];
            model.ut_fire = [set stringForColumn:@"ut_fire"];
            model.ut_mode = [set stringForColumn:@"ut_mode"];
            model.ut_type = [set stringForColumn:@"ut_type"];
            model.ut_mtype = [set stringForColumn:@"ut_mtype"];
            model.ut_draft = [set stringForColumn:@"ut_draft"];
            model.ut_message = [set stringForColumn:@"ut_message"];
            model.ut_time = [set stringForColumn:@"ut_time"];
            model.ut_newmsgcount = [set stringForColumn:@"ut_newmsgcount"];
            tempModel = model;
        }
        
        [set close];
        
         }];
            return tempModel;
        
   
    
   
}

// 插入或更新消息，首先会先查一遍，如果不存在，就插入，否则更新
- (BOOL)insertOrUpdateUserlist:(ICometModel *)model {
    
//    if ([model.FIRE containsString:@"LOCK"]||[model.FIRE containsString:@"READ"]) {
//        if ([model.mtype isEqualToString:@"S"]||[model.mtype isEqualToString:@"P"]||[model.mtype isEqualToString:@"V"]) {
//            return NO;
//        }
//    }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *alarm = [user objectForKey:@"alarm"];
    

        ICometModel *listModel = [model copy];
        if ([@"S" isEqualToString:listModel.type] && [alarm isEqualToString:listModel.rid]) {
            listModel.rid = listModel.sid;
        }
        
        if ([self selectUserlistById:listModel.rid]) {
            return [self updateUserlist:listModel];
        } else {
            return [self insertUserlist:listModel];
        }
}

// 删除指定id的消息
- (BOOL)deleteUserlist:(NSString *)chatId {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from tb_userlist where ut_alarm = ? ", chatId];
    }];
        return ret;
    
    
}

// 查询所有的消息
- (NSMutableArray *)selectUserlists {
    NSMutableArray *array = [NSMutableArray array];
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        FMResultSet *set = [db executeQuery:@"select * from tb_userlist order by ut_time desc"];
        while (set.next) {
            UserlistModel *model = [[UserlistModel alloc] init];
            model.ut_id = [[set stringForColumn:@"ut_id"] integerValue];
            model.ut_cmd = [set stringForColumn:@"ut_cmd"];
            model.ut_sendid = [set stringForColumn:@"ut_sendid"];
            model.ut_alarm = [set stringForColumn:@"ut_alarm"];
            model.ut_headpic = [set stringForColumn:@"ut_headpic"];
            model.ut_name = [set stringForColumn:@"ut_name"];
            model.ut_fire = [set stringForColumn:@"ut_fire"];
            model.ut_mode = [set stringForColumn:@"ut_mode"];
            model.ut_type = [set stringForColumn:@"ut_type"];
            model.ut_mtype = [set stringForColumn:@"ut_mtype"];
            model.ut_draft = [set stringForColumn:@"ut_draft"];
            model.ut_message = [set stringForColumn:@"ut_message"];
            model.ut_time = [set stringForColumn:@"ut_time"];
            model.ut_newmsgcount = [set stringForColumn:@"ut_newmsgcount"];
            [array addObject:model];
            
        }
        [set close];
       
    }];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    for (UserlistModel *model in array) {
        // 消息过滤
        if ([@"G" isEqualToString:model.ut_type]) {
            if ([[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:model.ut_alarm]) {
                [arr addObject:model];
            }
        }else if ([@"S" isEqualToString:model.ut_type]) {
            if ([model.ut_sendid isEqualToString:alarm]) {
                [arr addObject:model];
            }else if ([[[DBManager sharedManager] personnelInformationSQ] isFriendExistForAlarm:model.ut_sendid]) {
                [arr addObject:model];
            }
        }else if ([@"B" isEqualToString:model.ut_type]) {
            [arr addObject:model];
        }
    }
    array = nil;
    return arr;
}

// 清除新消息数量
- (BOOL)clearNewMsgCout:(NSString *)chatId {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"update tb_userlist set ut_newmsgcount = 0 where ut_alarm = ?", chatId];
      }];
        return ret;
    
   
}
// 清除@我的消息
- (void)clearAtAlarmMsg:(NSString *)chatId {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"@%@",chatId]];
    
}
// 根据id获取对应的新消息数量
- (NSInteger)selectNewMsgCountById:(NSString *)chatId {
    __block NSInteger count;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        FMResultSet *set = [db executeQuery:@"select ut_newmsgcount from tb_userlist where ut_alarm = ?", chatId];
        while (set && set.next) {
            
            count = [[set stringForColumn:@"ut_newmsgcount"] integerValue];
        }
        [set close];
        
        }];
        return count;
        
        
   
}
/**
 *  判断是否@自己
 *
 *  @param atAlarm 传入的字符串
 *
 *  @return 是否@自己
 */
- (BOOL)isAtMe:(NSString *)atAlarm {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    BOOL isatme;
    if ([[LZXHelper isNullToString:atAlarm] isEqualToString:@""]) {
        atAlarm = @"";
    }
    
    if ([atAlarm rangeOfString:alarm].location != NSNotFound) {
        isatme = YES;
    }else {
        isatme = NO;
    }
    return isatme;
}
// 清除表
- (BOOL) clearUserlist
{
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", @"tb_userlist"];
        if (ret != [db executeUpdate:sqlstr])
        {
            ZEBLog(@"Erase table error!");
            
        }
        
    }];
    return ret;
}
@end
