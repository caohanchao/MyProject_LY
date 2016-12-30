//
//  UnitViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UnitViewController;
@class UserAllModel;

@protocol UnitViewControllerPushDelegate <NSObject>


- (void)unitViewControllerPush:(UnitViewController *)con title:(NSString *)title arr:(NSMutableArray *)arr allUser:(NSMutableArray *)allUser allDepart:(NSMutableArray *)allDepart nextUser:(NSMutableArray *)nextUser;

- (void)unitViewControllerPushUserInfo:(UnitViewController *)con userAllModel:(UserAllModel *)model;
- (void)changeTitleView;
@end

@interface UnitViewController : UIViewController {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *sjnumberArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray *departArray;
@property (nonatomic, weak) id<UnitViewControllerPushDelegate> delegate;


- (void)getUserForOne;
@end
