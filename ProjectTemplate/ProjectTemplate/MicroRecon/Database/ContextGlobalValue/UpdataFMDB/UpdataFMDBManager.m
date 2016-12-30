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

    if ([versionStr isEqualToString:@"1.04 beta"]) {
      //  [self versionStr104beta];
    }else if ([versionStr isEqualToString:@"1.05 beta"]) {
//        [self versionStr104beta];
//        [self versionStr105beta];
    }
}
- (void)versionStr104beta {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db columnExists:@"beta" inTableWithName:@"tb_newfriend"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"tb_newfriend",@"beta"];
            BOOL worked = [db executeUpdate:alertStr];
            if(worked){
                ZEBLog(@"插入成功");
            }else{
                ZEBLog(@"插入失败");
            }
        }
    }];
}
- (void)versionStr105beta {
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        if (![db columnExists:@"beta1" inTableWithName:@"tb_newfriend"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"tb_newfriend",@"beta1"];
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
