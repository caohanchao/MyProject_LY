//
//  UpdataFMDBManager.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  该类作为版本升级数据库表结构更新类
//  获取该版本号添加新字段

#import "UpdataFMDBManager.h"
#import "FMDatabaseAdditions.h"

@implementation UpdataFMDBManager

+(UpdataFMDBManager*) sharedInstance
{
    __strong static id _sharedObject = nil;
    @synchronized(self) {//同步 执行 防止多线程操作
        if (_sharedObject == nil) {
            _sharedObject = [[self alloc] init];
        }
    }
    return _sharedObject;
}
- (void)updataFMDB {
    // 升级操作
    NSString *versionStr=[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    if ([versionStr isEqualToString:FMDBVersion1]) {
        [self versionStr104beta];
    }else if ([versionStr isEqualToString:FMDBVersion2]) {
        [self versionStr104beta];
        [self versionStr105beta];
    }else if ([versionStr isEqualToString:FMDBVersion3]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }else if ([versionStr isEqualToString:FMDBVersion4]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }else if ([versionStr isEqualToString:FMDBVersion5]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }else if ([versionStr isEqualToString:FMDBVersion6]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }else if ([versionStr isEqualToString:FMDBVersion7]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }else if ([versionStr isEqualToString:FMDBVersion8]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }else if ([versionStr isEqualToString:FMDBVersion2_0]) {
        [self versionStr104beta];
        [self versionStr105beta];
        [self versionStr107beta];
    }
}
- (void)versionStr104beta {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db columnExists:@"me_msgid" inTableWithName:@"tb_message"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"tb_message",@"me_msgid"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
      //  [db executeUpdate:@"CREATE UNIQUE INDEX index_msgid ON tb_message (me_msgid)"];
    }];
}
- (void)versionStr105beta {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db columnExists:@"me_workid" inTableWithName:@"tb_message"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"tb_message",@"me_workid"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
        if (![db columnExists:@"PS_postid" inTableWithName:@"ps_praiseUser"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"ps_praiseUser",@"PS_postid"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }

        }];
}

- (void)versionStr107beta {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db columnExists:@"me_msgfire" inTableWithName:@"tb_message"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"tb_message",@"me_msgfire"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
        
        if (![db columnExists:@"me_timeStr" inTableWithName:@"tb_message"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"tb_message",@"me_timeStr"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
        
        if (![db columnExists:@"UP_msgfire" inTableWithName:@"tb_uploading"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"tb_uploading",@"UP_msgfire"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
        if (![db columnExists:@"mr_msgfire" inTableWithName:@"tb_messageResend"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"tb_messageResend",@"mr_msgfire"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
        if (![db columnExists:@"me_msgNotShow" inTableWithName:@"tb_message"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"tb_message",@"me_msgNotShow"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
    }];
}


@end
