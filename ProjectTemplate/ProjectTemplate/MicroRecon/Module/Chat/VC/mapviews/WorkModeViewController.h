//
//  WorkModeViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RoutingWorkMode,    // 走线
    VisitingWorkMode,   // 走访
    TrackWorkMode       // 追踪
}WorkModeType;

typedef void (^SelectWorkModeBlock) (WorkModeType workMode,NSString *workModeName);

@interface WorkModeViewController : UIViewController

@property (nonatomic,assign) WorkModeType workMode;

@property (nonatomic,copy)SelectWorkModeBlock WorkModeBlock;


@end
