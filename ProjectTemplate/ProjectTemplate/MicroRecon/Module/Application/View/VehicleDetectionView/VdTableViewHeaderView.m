//
//  VdTableViewHeaderView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdTableViewHeaderView.h"

#define leftMrgin 12
#define TopMargin 17

#define TitleFont 14

@interface VdTableViewHeaderView () {

}

@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation VdTableViewHeaderView



+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header";
    VdTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[VdTableViewHeaderView alloc] initWithReuseIdentifier:ID];
        
        
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
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = CHCHexColor(@"eeeeee");
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = CHCHexColor(@"eeeeee");

    self.timeImageView = [[UIImageView alloc] init];
    self.timeImageView.image = [UIImage imageNamed:@"time"];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = CHCHexColor(@"12b7f5");
    self.timeLabel.font = ZEBFont(TitleFont);

    [self.contentView addSubview:line];
    [self.contentView addSubview:self.timeImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:line1];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
 
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(TopMargin);
        make.left.equalTo(self.mas_left).offset(leftMrgin);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImageView.mas_right).offset(12);
        make.centerY.equalTo(self.timeImageView.mas_centerY);
        make.height.equalTo(@20);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.timeLabel.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
}
- (void)setTime:(NSString *)time {
    
    _time = time;
    [self reloadView];
}
- (void)reloadView {
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_time VdtimeChange]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
