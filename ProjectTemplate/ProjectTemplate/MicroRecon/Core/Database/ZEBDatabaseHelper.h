//
//  ZEBDatabaseHelper.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEBDatabaseHelper : NSObject

@property (nonatomic ,retain) FMDatabaseQueue *queue;


+(ZEBDatabaseHelper*) sharedInstance;
-(void)inDatabase:(void(^)(FMDatabase *db))block;
-(void)inTransaction:(void(^)(FMDatabase *db, BOOL *rollback))block;
+(void) refreshDatabaseFile;
@end
