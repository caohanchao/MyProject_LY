//
//  TeamTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "TeamsListModel.h"

@interface TeamTableViewCell : UITableViewCell

@property (nonatomic, strong) TeamsListModel *teamListModel;
@property (nonatomic, assign) BOOL isContact;//判断是否是来自通讯录

@property (nonatomic, assign) BOOL isSelect;
- (void)selectedCell;
@end
