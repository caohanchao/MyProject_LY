//
//  AddGroupMemberController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddGroupMemberController;


typedef enum : NSUInteger {
    FromeCreateGroup,//建群
    FromeGroupDes,//详情
    FromeOther//其它
    
} WhereFrome;

typedef enum : NSUInteger {
    FRIEND,//好友
    TEAM,//组队
    UNIT//单位
} UITYPE;

@protocol AddGroupMemberControllerDelegate <NSObject>

- (void)addGroupMemberController:(AddGroupMemberController *)con selectFRArray:(NSMutableArray *)FRArray selectTMArray:(NSMutableArray *)TMArray selectUTArray:(NSMutableArray *)UTArray selectTempFRArray:(NSMutableArray *)tempFRArray selectTempTMArray:(NSMutableArray *)tempTMArray selectTempUTArray:(NSMutableArray *)tempUTArray selGid:(NSString *)selGid;

@end

@interface AddGroupMemberController : UIViewController

@property (nonatomic, weak) id<AddGroupMemberControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectFRArray;
@property (nonatomic, strong) NSMutableArray *selectTMArray;
@property (nonatomic, strong) NSMutableArray *selectUTArray;

@property (nonatomic, strong) NSMutableArray *selectTempFRArray;
@property (nonatomic, strong) NSMutableArray *selectTempTMArray;
@property (nonatomic, strong) NSMutableArray *selectTempUTArray;


@property (nonatomic, strong) NSMutableArray *TempTMArray;

@property (nonatomic, copy) NSString *selGid;
@property (nonatomic, assign) NSInteger gMCount;
@property (nonatomic, assign) WhereFrome fromeWhere;
@end
