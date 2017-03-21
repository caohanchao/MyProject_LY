//
//  CallTheRollSecondHeaderView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallTheRollSecondHeaderView;

typedef void(^changeStateBlock)(NSInteger type); // type 0 已报道 1 未报道
typedef void(^selectDateBlock)(CallTheRollSecondHeaderView *headView); // type 0 已报道 1 未报道

@interface CallTheRollSecondHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) changeStateBlock block;
@property (nonatomic, copy) selectDateBlock dateBlock;

@property (nonatomic, assign) BOOL notreported; // 未报道
@property (nonatomic, assign) BOOL showDateBtn;
@property (nonatomic, assign) NSInteger notreportedCount; // 未报道人数
@property (nonatomic, assign) NSInteger havereportedCount; // 已报道人数

+ (instancetype)headerViewWithTableView:(UITableView *)tableView block:(changeStateBlock)block dateBlock:(selectDateBlock)dateBlock;

@end
