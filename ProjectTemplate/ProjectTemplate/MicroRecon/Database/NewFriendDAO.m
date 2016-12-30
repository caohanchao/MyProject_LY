//
//  NewFriendlistSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "NewFriendDAO.h"
#import "FriendsListModel.h"

@interface NewFriendDAO()



@end

@implementation NewFriendDAO

//根据FMDatabase获取NewFriendlistSQ对象
+ (instancetype)newFriendDAO {
    NewFriendDAO *dao = [NewFriendDAO new];
   
    return dao;
}

// 添加新朋友信息
- (BOOL)insertNewFriend:(NewFriendModel *)model {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    
         ret = [db executeUpdate:@"insert into tb_newfriend(nf_fid,nf_mtype,nf_data,nf_isactive,nf_ptime) values(?,?,?,?,?)",model.nf_fid, model.nf_mtype, model.nf_data, model.nf_isactive, model.nf_ptime];
    }];

        return ret;

}

// 查询指定警号的新朋友信息
- (NewFriendModel *)selectNewFriendByAlarm:(NSString *)alarm {
    
    __block NewFriendModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_newfriend where nf_fid = ?", alarm];
        while (set && set.next) {
            NewFriendModel *model = [[NewFriendModel alloc] init];
            model.nf_fid = [set stringForColumn:@"nf_fid"];
            model.nf_data = [set stringForColumn:@"nf_data"];
            model.nf_ptime = [set stringForColumn:@"nf_ptime"];
            model.nf_isactive = [set stringForColumn:@"nf_isactive"];
            model.nf_mtype = [set stringForColumn:@"nf_mtype"];
            tempModel = model;
        }
        [set close];
    }];

    return tempModel;
}

// 获取新朋友列表
- (NSArray *)selectNewFriends {
    __block NSMutableArray *array = [NSMutableArray array];
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_newfriend order by nf_ptime desc"];
        while (set && set.next) {
            NewFriendModel *model = [[NewFriendModel alloc] init];
            model.nf_fid = [set stringForColumn:@"nf_fid"];
            model.nf_data = [set stringForColumn:@"nf_data"];
            model.nf_ptime = [set stringForColumn:@"nf_ptime"];
            model.nf_isactive = [set stringForColumn:@"nf_isactive"];
            model.nf_mtype = [set stringForColumn:@"nf_mtype"];
            [array addObject:model];
            
        }
        [set close];
    
    }];

    
    return array;
}

// 更新新朋友信息
- (BOOL)updateNewFriend:(NewFriendModel *)model {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"update tb_newfriend set nf_mtype = ?,nf_data = ?,nf_isactive = ?,nf_ptime = ? where nf_fid = ?", model.nf_mtype, model.nf_data, model.nf_isactive, model.nf_ptime, model.nf_fid];
    }];

        return ret;

}

// 删除新朋友信息
- (BOOL)deleteNewFriend:(NSString *)fid {
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"delete from tb_newfriend where nf_fid = ?", fid];
    }];

        return ret;

}

// 插入或更新新朋友数据
- (BOOL)insertOrUpdateNewFriend:(NewFriendModel *)model {
    
        if ([self selectNewFriendByAlarm:model.nf_fid]) {
            return [self updateNewFriend:model];
        } else {
            return [self insertNewFriend:model];
        }
}

// 添加新朋友
- (BOOL)addNewFriend:(ICometModel *)model {
    NewFriendModel *nfModel = [[NewFriendModel alloc] init];
    nfModel.nf_fid = model.sid;
    nfModel.nf_isactive = @"notactive"; // 被请求
    nfModel.nf_data = model.data;
    nfModel.nf_ptime = model.time;
    nfModel.nf_mtype = model.mtype;
    
    if ([model.sid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]]) {
        nfModel.nf_fid = model.rid;
        nfModel.nf_isactive = @"isactive"; // 请求
    }

    return [self insertOrUpdateNewFriend:nfModel];
}

// 同意添加好友请求 
- (BOOL)agree:(ICometModel *)model {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    BOOL isCome = [model.sid isEqualToString:alarm];
    NewFriendModel *nfModel = [[NewFriendModel alloc] init];
    nfModel.nf_fid = isCome ? model.rid : model.sid;
    
    nfModel.nf_isactive = @"";
    nfModel.nf_data = model.data;
    nfModel.nf_ptime = model.time;
    nfModel.nf_mtype = model.mtype;
    // 更新新朋友表
    [self insertOrUpdateNewFriend:nfModel];
    // 将新好友的信息插入好友表中
    UserAllModel *member = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:nfModel.nf_fid];
    FriendsListModel *fModel = [[FriendsListModel alloc] init];
    fModel.headpic = member.RE_headpic;
    fModel.name = member.RE_name;
    fModel.nickname = member.RE_nickname;
    fModel.alarm = member.RE_alarmNum;
    fModel.phone = member.RE_phonenum;
    [[[DBManager sharedManager] personnelInformationSQ] insertOrUpdateNewPersonnelInformationOfFriendsListModel:fModel];
    // 将信息插入消息列表中
    model.data = @"我们现在已经是好友，可以开始聊天了";
    [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
    // 将信息插入聊天记录表中
    [[[DBManager sharedManager] MessageDAO] insertMessage:model];
    return NO;
}

@end
