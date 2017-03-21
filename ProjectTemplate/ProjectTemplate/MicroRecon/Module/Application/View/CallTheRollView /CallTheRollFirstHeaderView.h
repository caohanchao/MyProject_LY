//
//  CallTheRollFirstHeaderView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallTheRollDeatilModel;

@interface CallTheRollFirstHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) CallTheRollDeatilModel *deatilModel;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
