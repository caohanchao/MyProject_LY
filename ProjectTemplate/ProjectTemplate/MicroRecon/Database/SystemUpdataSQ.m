//
//  SystemUpdataSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SystemUpdataSQ.h"

@interface SystemUpdataSQ ()

@end

@implementation SystemUpdataSQ

+ (instancetype)systemUpdataSQ {
    SystemUpdataSQ *dao = [[SystemUpdataSQ alloc] init];
    
    return dao;
}
/*
 SU_id INTEGER PRIMARY KEY AUTOINCREMENT,SU_appVersion TEXT ,SU_jsVersion TEXT,SU_time TEXT,SU_jsUrl TEXT unique,SU_jsDetailedInf TEXT
 */
// 插入一条信息到消息列表
- (BOOL)insertSystemUpdatalist:(JsPatchModel *)model {
    __block BOOL ret;
      [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"insert into tb_systemUpdata(SU_appVersion,SU_jsVersion, SU_time, SU_jsUrl, SU_jsDetailedInf) values(?,?,?,?,?)",model.appVersion, model.jsVersion, model.time, model.jsUrl, model.jsDetailedInf];
      }];
        return ret;

}
// 查询所有的消息
- (NSMutableArray *)selectSystemUpdatalist {
    
   __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db)
     {
        FMResultSet *set = [db executeQuery:@"select * from tb_systemUpdata"];
        while (set.next) {
            JsPatchModel *model = [[JsPatchModel alloc] init];
            model.appVersion = [set stringForColumn:@"SU_appVersion"];
            model.jsVersion = [set stringForColumn:@"SU_jsVersion"];
            model.time = [set stringForColumn:@"SU_time"];
            model.jsUrl = [set stringForColumn:@"SU_jsUrl"];
            model.jsDetailedInf = [set stringForColumn:@"SU_jsDetailedInf"];
            [array addObject:model];
        }
          [set close];
        
     }];
    
    return array;

}
// 删除指定的消息
- (BOOL)deleteSystemUpdata:(NSString *)appVersion jsVersion:(NSString *)jsVersion {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db){
        ret = [db executeUpdate:@"delete from tb_systemUpdata where SU_appVersion = ? and SU_jsVersion = ?", appVersion,jsVersion];
      
    }];
        return ret;
    
    
    
}
@end
