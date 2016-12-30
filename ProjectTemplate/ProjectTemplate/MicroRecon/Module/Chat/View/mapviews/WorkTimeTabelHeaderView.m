//
//  WorkTimeTabelHeaderView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkTimeTabelHeaderView.h"


#define leftMrgin 50


@interface WorkTimeTabelHeaderView () {
    
    
    
}

@property (nonatomic, strong) UILabel *timeLeftLabel;
@property (nonatomic, strong) UILabel *timeRightLabel;
@end


@implementation WorkTimeTabelHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header";
    WorkTimeTabelHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[WorkTimeTabelHeaderView alloc] initWithReuseIdentifier:ID];
        
        
    }
    return header;
    
}

/**
 *  在这个初始化方法中,MJHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    
    self.timeLeftLabel = [[UILabel alloc] init];
    self.timeLeftLabel.textColor = [UIColor whiteColor];
    self.timeLeftLabel.backgroundColor = [UIColor blueColor];
    self.timeLeftLabel.font = ZEBFont(10);
    self.timeLeftLabel.layer.masksToBounds = YES;
    self.timeLeftLabel.layer.cornerRadius = 25/2;
    self.timeLeftLabel.textAlignment = NSTextAlignmentCenter;
    
    self.timeRightLabel = [[UILabel alloc] init];
    self.timeRightLabel.textColor = [UIColor blueColor];
    self.timeRightLabel.font = ZEBFont(14);
    
    [self.contentView addSubview:lineLabel];
    [self.contentView addSubview:self.timeLeftLabel];
    [self.contentView addSubview:self.timeRightLabel];
    
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(leftMrgin);
        make.width.mas_equalTo(0.5);
        make.height.equalTo(self.mas_height);
    }];
    [self.timeLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lineLabel.mas_centerX);
        make.centerY.equalTo(lineLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.timeRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLeftLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timeLeftLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
}
- (void)setTime:(NSString *)time {

    _time = time;
    [self reloadView];
}
- (void)reloadView {
    self.timeLeftLabel.text = [_time timeChaneTodayOrYesterdayOrOther];
    self.timeRightLabel.text = _time;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
