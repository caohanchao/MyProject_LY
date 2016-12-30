//
//  FriendsViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsViewController;
@class FriendsListModel;

@protocol FriendsViewControllerPushDelegate <NSObject>


- (void)friendsViewControllerPush:(FriendsViewController *)con frModel:(FriendsListModel *)frModel;
- (void)friendsViewControllerPushToNewFr:(FriendsViewController *)con;

@end

@interface FriendsViewController : UIViewController {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *friendListArray;
@property(nonatomic, weak) id<FriendsViewControllerPushDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

- (void)sortFriendList;
@end
