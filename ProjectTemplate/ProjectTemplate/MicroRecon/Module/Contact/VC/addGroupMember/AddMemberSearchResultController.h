//
//  AddMemberSearchResultController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddMemberSearchResultController;

@protocol AddMemberSearchResultControllerDelegate <NSObject>

- (void)addMemberSearchResultController:(AddMemberSearchResultController *)con model:(id)model;
- (void)scrollViewDidScroll:(AddMemberSearchResultController *)con;
@end

@interface AddMemberSearchResultController : UIViewController {
    
    UITableView *_tableView;
}


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<AddMemberSearchResultControllerDelegate> delegate;

- (void)reloadTableView;
@end
