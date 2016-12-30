//
//  ZEBDatabaseHelper.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBDatabaseHelper.h"

@implementation ZEBDatabaseHelper

-(id) init
{
    self = [super init];
    if(self){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *alarm = [user objectForKey:UIUseralarm];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbFilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", alarm]];
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    }
    return self;
}
+(ZEBDatabaseHelper*) sharedInstance
{
    __strong static id _sharedObject = nil;
     @synchronized(self) {//同步 执行 防止多线程操作
         if (_sharedObject == nil) {
             _sharedObject = [[self alloc] init];
         }
     }
    return _sharedObject;
}

-(void)inDatabase:(void(^)(FMDatabase *db))block
{
    [_queue inDatabase:^(FMDatabase *db){
        block(db);
    }];
}
-(void)inTransaction:(void(^)(FMDatabase *db, BOOL *rollback))block {
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        block(db,rollback);
    }];
}
+(void) refreshDatabaseFile
{
    ZEBDatabaseHelper *instance = [self sharedInstance];
    [instance doRefresh];
}
-(void) doRefresh
{
    [_queue close];
    _queue = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:UIUseralarm];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", alarm]];
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
}
@end
