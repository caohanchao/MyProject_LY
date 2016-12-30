//
//  AddGroupTMController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TeamViewController.h"

@class AddGroupTMController;

@protocol AddGroupTMControllerDelegate <NSObject>

- (void)addGroupTMController:(AddGroupTMController *)con selArray:(NSMutableArray *)ary selGidstr:(NSString *)selGidstr;

@end

@interface AddGroupTMController : TeamViewController
@property (nonatomic, strong) NSMutableArray *groupSettingSelArray;
@property (nonatomic, strong) NSMutableArray *selArray;
@property (nonatomic, strong) NSMutableArray *selGidArray;
@property (nonatomic, copy) NSString *selGidstr;
@property (nonatomic, copy) NSString *groupSettingselGidstr;
@property (nonatomic, weak) id<AddGroupTMControllerDelegate> addGroupTMDelegate;
@end
