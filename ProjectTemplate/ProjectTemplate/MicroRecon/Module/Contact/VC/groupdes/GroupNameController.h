//
//  GroupNameController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupDesModel;
@class GroupNameController;

@protocol GroupNameControllerDelegate <NSObject>

- (void)groupNameControllerRefresh:(GroupNameController *)con name:(NSString *)name;

@end

@interface GroupNameController : UIViewController

@property (nonatomic, assign) BOOL isgAdmin;
@property (nonatomic, strong) GroupDesModel *gDesModel;
@property (nonatomic, weak) id<GroupNameControllerDelegate> delegate;
@end
