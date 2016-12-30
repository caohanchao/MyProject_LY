//
//  VdLineTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdLineTableViewCell.h"

#define TitleFont 12

@interface VdLineTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, strong) UILabel *bayonetNameLabel;
@property (nonatomic, weak) UILabel *line;
@end

@implementation VdLineTableViewCell

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
    
    self.mapImageView = [CHCUI createImageWithbackGroundImageV:@"vd_annotation_small"];
    
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
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
    }];
    
    [self.bayonetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mapImageView);
        make.left.equalTo(self.mapImageView.mas_right).offset(12);
        make.right.equalTo(self.timeLabel.mas_left).offset(-20);
        make.height.mas_equalTo(height(self.frame));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)setBayonetName:(NSString *)bayonetName {
    
    _bayonetName = bayonetName;
    self.bayonetNameLabel.text = [NSString stringWithFormat:@"卡口名称：%@",[LZXHelper isNullToString:_bayonetName]];
}
- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = [_time timeChangeHHmm];
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
