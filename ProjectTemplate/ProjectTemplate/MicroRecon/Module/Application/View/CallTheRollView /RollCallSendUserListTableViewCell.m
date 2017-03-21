//
//  RollCallSendUserListTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "RollCallSendUserListTableViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "CallTheRollDeatilModel.h"

@interface RollCallSendUserListTableViewCell ()

@property (nonatomic, strong) UIImageView *headpic;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@end

@implementation RollCallSendUserListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {

//    self.headpic = [[UIImageView alloc] initWithCornerRadiusAdvance:20 rectCornerType:UIRectCornerAllCorners];
    self.headpic = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    
    self.nameLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:RGB(51, 51, 51) text:@""];
    
    self.departmentLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(12) textColor:RGB(128, 128, 128) text:@""];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    [self.contentView addSubview:self.headpic];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.departmentLabel];
    [self.contentView addSubview:line];
    
    [self.headpic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpic.mas_right).offset(12);
        make.top.equalTo(self.headpic.mas_top);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpic.mas_right).offset(12);
        make.bottom.equalTo(self.headpic.mas_bottom);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);

    }];
    
}
- (void)setUserListModel:(CallTheRollUserListModel *)userListModel {
    _userListModel = userListModel;
    
    [self reloadCell];
}
- (void)reloadCell {

    [self.headpic sd_setImageWithURL:[NSURL URLWithString:_userListModel.report_headpic] placeholderImage:[LZXHelper buttonImageFromColor:zGroupTableViewBackgroundColor]];
    self.nameLabel.text = _userListModel.report_name;
    self.departmentLabel.text = _userListModel.department;
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
