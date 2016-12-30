//
//  ContactTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsListModel.h"

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, strong) FriendsListModel *friendsLiModel;
@property (nonatomic, assign) BOOL isContact;//判断是否是来自通讯录

@property (nonatomic, assign) BOOL isSelect;

- (void)selectedCell;
@end
