//
//  TeamViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TeamViewController;
@class TeamsListModel;


@protocol teamViewControllerPushDelegate <NSObject>


- (void)teamViewControllerPush:(TeamViewController *)con teamListModel:(TeamsListModel *)model;

@end


@interface TeamViewController : UIViewController {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<teamViewControllerPushDelegate> delegate;

- (void)refreshUI;
@end
