//
//  UtOneTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitListModel.h"

@interface UtOneTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


/** 模型  */
@property (nonatomic, strong) UnitListModel *friendData;


@end
