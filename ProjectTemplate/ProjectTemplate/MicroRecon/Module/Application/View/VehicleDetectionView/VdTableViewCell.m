//
//  VdTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdTableViewCell.h"

#define TitleFont 12

@interface VdTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *mapImageView;
@property (nonatomic, strong) UILabel *bayonetNameLabel;
@property (nonatomic, weak) UILabel *line;
@end

@implementation VdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = CHCHexColor(@"eeeeee");
    self.line = line;
    
    self.timeLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(10) textColor:CHCHexColor(@"a6a6a6") text:@""];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    self.mapImageView = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(12) textColor:zBlackColor text:@""];
    
    self.bayonetNameLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(TitleFont) textColor:CHCHexColor(@"000000") text:@""];
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.mapImageView];
    [self.contentView addSubview:self.bayonetNameLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.equalTo(@20);
    }];
    
    [self.mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.height.equalTo(@12);
        make.width.mas_equalTo(25);
 
    }];
    
    [self.bayonetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mapImageView);
        make.left.equalTo(self.mapImageView.mas_right).offset(12);
        make.right.equalTo(self.timeLabel.mas_left).offset(-20);
        make.height.mas_equalTo(height(self.frame));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mapImageView.mas_right).offset(12);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)setBayonetName:(NSString *)bayonetName {

    _bayonetName = bayonetName;
    NSString *name = [LZXHelper isNullToString:_bayonetName];
    if ([name isEqualToString:@""]) {
        name = @"未知";
    }
    self.bayonetNameLabel.text = [NSString stringWithFormat:@"卡口名称：%@",name];
}
- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = [_time timeChangeHHmm];
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.mapImageView.text = [NSString stringWithFormat:@"%ld",_index];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
