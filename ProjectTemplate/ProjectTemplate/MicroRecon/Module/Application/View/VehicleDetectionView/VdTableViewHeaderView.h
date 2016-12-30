//
//  VdTableViewHeaderView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VdTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *time;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView ;

@end