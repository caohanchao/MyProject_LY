//
//  AddGroupUTController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitViewController.h"

@class AddGroupUTController;

@protocol AddGroupUTControllerDelegate <NSObject>

- (void)addGroupUTController:(AddGroupUTController *)con title:(NSString *)title arr:(NSMutableArray *)arr allUser:(NSMutableArray *)allUser allDepart:(NSMutableArray *)allDepart nextUser:(NSMutableArray *)nextUser;
- (void)addGroupUTController:(AddGroupUTController *)con selArray:(NSMutableArray *)ary;

@end

@interface AddGroupUTController : UnitViewController

@property (nonatomic, weak) id<AddGroupUTControllerDelegate> addGroupDelegate;
@property (nonatomic, strong) NSMutableArray *groupSettingSelArray;
@property (nonatomic, strong) NSMutableArray *selArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end
