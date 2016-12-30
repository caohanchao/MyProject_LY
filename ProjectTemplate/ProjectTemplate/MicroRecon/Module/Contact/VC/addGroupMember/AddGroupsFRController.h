//
//  AddGroupsFRController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "FriendsViewController.h"

@class AddGroupsFRController;

@protocol AddGroupsFRControllerDelegate <NSObject>

- (void)addGroupsFRController:(AddGroupsFRController *)con selArray:(NSMutableArray *)ary;

@end

@interface AddGroupsFRController : FriendsViewController

@property (nonatomic, strong) NSMutableArray *selArray;
@property (nonatomic, strong) NSMutableArray *groupSettingSelArray;
@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, weak) id<AddGroupsFRControllerDelegate> addGroupsFRDelegate;
@end
