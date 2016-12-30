//
//  VdLineDesNotHaveImageCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdLineDesNotHaveImageCell.h"


@interface VdLineDesNotHaveImageCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, weak) UILabel *line;
@end

@implementation VdLineDesNotHaveImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
    
    _leftImageView = [[UIImageView alloc] init];
    
    _desLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:CHCHexColor(@"000000") text:@""];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = CHCHexColor(@"eeeeee");
    self.line = line;
    
    [self.contentView addSubview:_leftImageView];
    [self.contentView addSubview:_desLabel];
    [self.contentView addSubview:line];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_leftImageView.mas_right).offset(12);
        make.height.equalTo(@17);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    self.leftImageView.image  = [UIImage imageNamed:_imageStr];
}
- (void)setDesStr:(NSString *)desStr {
    _desStr = desStr;
    self.desLabel.text = [LZXHelper isNullToString:_desStr];
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
