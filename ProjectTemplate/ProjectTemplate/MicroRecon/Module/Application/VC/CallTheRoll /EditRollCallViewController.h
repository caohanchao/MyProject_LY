//
//  EditRollCallViewController.h
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "BaseViewController.h"
#import "CallTheRollDeatilModel.h"

@class EditRollCallViewController;

@protocol EditRollCallDelegate <NSObject>

- (void)finishEditRollCall:(EditRollCallViewController *)finishEdit;

@end

@interface EditRollCallViewController : BaseViewController

@property (nonatomic, strong) CallTheRollDeatilModel *deatilModel;

@property (nonatomic, strong) NSMutableArray *selectFRArray;
@property (nonatomic, strong) NSMutableArray *selectTMArray;
@property (nonatomic, strong) NSMutableArray *selectUTArray;
@property (nonatomic, copy) NSString *selGid;

@property (nonatomic, weak) id<EditRollCallDelegate> delegate;

@end
