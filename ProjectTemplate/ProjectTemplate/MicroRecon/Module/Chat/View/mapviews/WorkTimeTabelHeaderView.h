//
//  WorkTimeTabelHeaderView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTimeTabelHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *time;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView ;

@end
