//
//  TreeTableViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeTableViewController;

@protocol TreeTableViewControllerDelegate <NSObject>

-(void)selectUnit:(TreeTableViewController *)con orgStr:(NSString *)orgStr orgID:(NSString *)orgID;

@end

@interface TreeTableViewController : UIViewController
@property (nonatomic, weak) id<TreeTableViewControllerDelegate>  delegate;

- (void)selectCell;
@end

