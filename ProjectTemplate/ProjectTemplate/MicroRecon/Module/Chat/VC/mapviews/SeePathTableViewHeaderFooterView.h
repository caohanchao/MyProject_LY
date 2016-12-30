//
//  SeePathTableViewHeaderFooterView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeePathTableViewHeaderFooterView;

@protocol SeePathTableViewHeaderFooterViewDelegate <NSObject>

- (void)seePathTableViewHeaderFooterView:(SeePathTableViewHeaderFooterView *)view index:(NSInteger)idnex;

@end
@interface SeePathTableViewHeaderFooterView : UITableViewHeaderFooterView


@property (nonatomic, assign) NSInteger idnex;
@property (nonatomic, weak) id<SeePathTableViewHeaderFooterViewDelegate> deleagte;
@property (nonatomic, copy) NSString *alarm;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
