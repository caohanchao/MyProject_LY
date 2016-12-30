//
//  CreateTaskViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ChatListVCToTaskGroup,
    GroupTeamVCToTaskGroup
} TaskGroupVCComeType;

@interface CreateTaskViewController : UIViewController


@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *selectFRArray;
@property (nonatomic, strong) NSMutableArray *selectTMArray;
@property (nonatomic, strong) NSMutableArray *selectUTArray;

@property (nonatomic, strong) NSMutableArray *selectTempFRArray;
@property (nonatomic, strong) NSMutableArray *selectTempTMArray;
@property (nonatomic, strong) NSMutableArray *selectTempUTArray;

@property (nonatomic, copy) NSString *selGid;

@property (nonatomic,assign)TaskGroupVCComeType type;

@end
