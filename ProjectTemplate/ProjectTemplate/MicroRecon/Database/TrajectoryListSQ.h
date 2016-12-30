//
//  TrajectoryListSQ.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetPathModel.h"
@interface TrajectoryListSQ : NSObject

+ (instancetype)trajectoryListSQ;


- (BOOL)insertTrajectoryList:(GetPathModel *)model;

- (NSMutableArray *)selectTrajectoryList:(NSString *)gid;

- (BOOL)deleteTrajectoryListByCuid:(NSString *)cuid;

- (BOOL)updataTrajectoryList:(GetPathModel*)model;

@end
