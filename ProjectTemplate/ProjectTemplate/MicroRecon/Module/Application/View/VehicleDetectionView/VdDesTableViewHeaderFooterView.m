//
//  VdDesTableViewHeaderFooterView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdDesTableViewHeaderFooterView.h"

@interface VdDesTableViewHeaderFooterView ()


@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, copy)NSString *timeText;

@end

@implementation VdDesTableViewHeaderFooterView


- (void)setTimeText:(NSString *)timeText {
    _timeText = timeText;
    _timeLabel.text = _timeText;
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header";
    VdDesTableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[VdDesTableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = CHCHexColor(@"f5f5f5");
        [self initView];
    }
    return self;
}
- (void)initView {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = zWhiteColor;
    
    _leftImageView = [CHCUI createImageWithbackGroundImageV:@"vdDes_time"];
    
    _timeLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(14) textColor:CHCHexColor(@"000000") text:@"时间缺失"];
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = CHCHexColor(@"eeeeee");
    
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = CHCHexColor(@"eeeeee");

    
    [self addSubview:topView];
    [self addSubview:_leftImageView];
    [self addSubview:_timeLabel];
    [self addSubview:line1];
    [self addSubview:line2];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@40);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.bottom.equalTo(topView.mas_bottom);
        make.width.mas_lessThanOrEqualTo(150);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.right.equalTo(_timeLabel.mas_left).offset(-10);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
