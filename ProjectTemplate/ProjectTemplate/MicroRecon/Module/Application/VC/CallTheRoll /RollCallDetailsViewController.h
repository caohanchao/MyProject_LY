//
//  RollCallDetailsViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SingleRoll, // 单次点名
    RepeatRoll // 重复点名
} ROLLTYPE;

@interface RollCallDetailsViewController : UIViewController

@property (nonatomic, assign) ROLLTYPE rollType;
@property (nonatomic, copy) NSString *rallcallid;
@end
