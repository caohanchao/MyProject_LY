//
//  SeePathFiristTableViewHeaderFooterView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SeePathFiristTableViewHeaderFooterView;

@protocol SeePathFiristTableViewHeaderFooterViewDelegate <NSObject>

- (void)seePathFiristTableViewHeaderFooterView:(SeePathFiristTableViewHeaderFooterView *)view index:(NSInteger)idnex;

@end
@interface SeePathFiristTableViewHeaderFooterView : UITableViewHeaderFooterView


@property (nonatomic, assign) NSInteger idnex;
@property (nonatomic, weak) id<SeePathFiristTableViewHeaderFooterViewDelegate> deleagte;
@property (nonatomic, copy) NSString *alarm;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
