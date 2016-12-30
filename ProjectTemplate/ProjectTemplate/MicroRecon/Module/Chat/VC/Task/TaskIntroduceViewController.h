//
//  TaskIntroduceViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskIntroduceViewController;
typedef void (^TaskIntroduceBlock)(TaskIntroduceViewController *controller, NSString *intro);

@interface TaskIntroduceViewController : UIViewController

@property (nonatomic, copy) TaskIntroduceBlock block;
@property (nonatomic, copy) NSString *text;
@end
