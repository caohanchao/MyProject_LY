//
//  CallTheRollFirstTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollFirstTableViewCell.h"


@interface CallTheRollFirstTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

@implementation CallTheRollFirstTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initview];
    }
    return self;
}
- (void)initview {

    self.leftImageView = [[UIImageView alloc] init];
    
    self.leftLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:RGB(48, 48, 48) text:@"开始时间"];
    
    self.rightLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(13) textColor:RGB(128, 128, 128) text:@"14:00"];
    
    
    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.image = [UIImage imageNamed:@"icon_arrowroll"];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.rightImageView];
    
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).offset(-11);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)setTitle:(NSString *)title {
    _title = title;
    _leftLabel.text = _title;
}
- (void)setImage:(NSString *)image {
    _image = image;
    _leftImageView.image = [UIImage imageNamed:_image];
}
- (void)setContent:(NSString *)content {
    _content = content;
    _rightLabel.text = _content;
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    
    if (_index == 2) {
        _rightLabel.textColor = zNavColor;
    }else {
        _rightLabel.textColor = RGB(128, 128, 128);
    }
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
