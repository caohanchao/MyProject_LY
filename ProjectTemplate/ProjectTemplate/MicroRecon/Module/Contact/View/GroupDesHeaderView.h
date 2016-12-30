//
//  GroupDesHeaderView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupMemberModel;
@class GroupDesHeaderView;

#define ShowMemberCount 10

@protocol GroupDesHeaderViewDelegate <NSObject>

- (void)groupDesHeaderView:(GroupDesHeaderView *)view gMemberModel:(GroupMemberModel *)gMemberModel;
- (void)groupDesHeaderViewAddMember:(GroupDesHeaderView *)view ;
- (void)groupDesHeaderViewDeleteMember:(GroupDesHeaderView *)view ;
- (void)groupDesHeaderView:(GroupDesHeaderView *)view type:(NSInteger)type;
- (void)groupDesHeaderViewAllMember:(GroupDesHeaderView *)view;

@end

@interface GroupDesHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *type;

@property (nonatomic,copy) NSString *gMCount;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) id<GroupDesHeaderViewDelegate> delegate;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
