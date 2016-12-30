//
//  VdDesTableViewHeaderFooterView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VdDesTableViewHeaderFooterView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;



/**
 给时间赋值

 @param timeText 时间
 */
- (void)setTimeText:(NSString *)timeText;

@end
