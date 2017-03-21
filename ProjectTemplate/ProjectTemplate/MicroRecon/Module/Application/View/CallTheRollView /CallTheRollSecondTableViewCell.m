//
//  CallTheRollSecondTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollSecondTableViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "CallTheRollDeatilModel.h"

@interface CallTheRollSecondTableViewCell ()

@property (nonatomic, strong) UIImageView *headpic;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation CallTheRollSecondTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initview];
    }
    return self;
}
- (void)initview {

//    self.headpic = [[UIImageView alloc] initWithCornerRadiusAdvance:18 rectCornerType:UIRectCornerAllCorners];
    self.headpic = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    
    self.nameLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:RGB(51, 51, 51) text:@""];
    
    
    self.timeLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(12) textColor:RGB(153, 153, 153) text:@""];
    
    self.locationLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:RGB(128, 128, 128) text:@""];
    self.locationLabel.numberOfLines = 2;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    
    [self.contentView addSubview:self.headpic];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:line];
    
    [self.headpic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpic.mas_right).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-8);
        make.height.equalTo(@14);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@12);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpic.mas_right).offset(12);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@14);
        make.width.mas_lessThanOrEqualTo(250);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.locationLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}
- (void)setNotreported:(BOOL)notreported {
    _notreported = notreported;
    
    if (_notreported) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.headpic.mas_right).offset(10);
            make.height.equalTo(@15);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        _locationLabel.hidden = YES;
        _timeLabel.hidden = YES;
    }else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headpic.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(7);
            make.height.equalTo(@15);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        _locationLabel.hidden = NO;
        _timeLabel.hidden = NO;
    }
}
- (void)setUserListModel:(CallTheRollUserListModel *)userListModel {
    _userListModel = userListModel;
    [self reloadCell];
}
- (void)reloadCell {
    [self.headpic sd_setImageWithURL:[NSURL URLWithString:self.userListModel.report_headpic] placeholderImage:[LZXHelper buttonImageFromColor:zGroupTableViewBackgroundColor]];
    self.nameLabel.text = self.userListModel.report_name;
    self.locationLabel.text = self.userListModel.position;
    self.timeLabel.text = [self.userListModel.report_time timeChangeHHmm];
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
