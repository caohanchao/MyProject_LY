//
//  TopTaskListView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TopTaskListView.h"
#import "SuspectlistModel.h"

@interface TopTaskListView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation TopTaskListView

- (instancetype)initWithFrame:(CGRect)frame widthDataArray:(NSArray *)dataArray withBlock:(ClickCellBlock)block {

    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.dataArray = dataArray;
        [self initall];
    }
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
}
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.tableView reloadData];
}

- (void)initall {
    [self addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, width(self.frame)-10, height(self.frame)-10) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indextifier = @"indextifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 29.5, width(self.frame), 0.5)];
        line.backgroundColor = CHCHexColor(@"eeeeee");
        [cell addSubview:line];
    }
    SuspectlistModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.suspectname;
    cell.textLabel.font = ZEBFont(14);
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == self.selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = CHCHexColor(@"12b7f5");
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = zBlackColor;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath.row;
    self.block(self,indexPath.row);
    [tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
