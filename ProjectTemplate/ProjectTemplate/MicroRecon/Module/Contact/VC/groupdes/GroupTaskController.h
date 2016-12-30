//
//  GroupTaskController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupDesModel;
@class GroupTaskController;

@protocol GroupTaskControllerDelegate <NSObject>

- (void)groupTaskControllerRefresh:(GroupTaskController *)con intro:(NSString *)intro;

@end

@interface GroupTaskController : UIViewController

@property (nonatomic, assign) BOOL isgAdmin;
@property (nonatomic, strong) GroupDesModel *gDesModel;
@property (nonatomic, weak) id<GroupTaskControllerDelegate> delegate;

@end
