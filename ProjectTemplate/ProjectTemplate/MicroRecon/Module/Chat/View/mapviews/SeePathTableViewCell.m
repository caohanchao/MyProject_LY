//
//  SeePathTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SeePathTableViewCell.h"

@interface SeePathTableViewCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation SeePathTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {

    self.title = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(12) textColor:CHCHexColor(@"000000") text:@""];
    
    self.time  = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(12) textColor:CHCHexColor(@"808080") text:@""];
    
    self.btn = [CHCUI createButtonWithtarg:self sel:@selector(btnClick:) titColor:zClearColor font:ZEBFont(10) image:nil backGroundImage:nil title:@""];
    self.btn.userInteractionEnabled = NO;
    [self.btn setImage:[UIImage imageNamed:@"mapchoose"] forState:UIControlStateNormal];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.btn];
    [self.contentView addSubview:line];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@15);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.mas_lessThanOrEqualTo(280);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(GetPathModel *)model {
    _model = model;
    [self reloadCell];
}
- (void)reloadCell {
    self.title.text = _model.route_title;
    self.time.text = [NSString stringWithFormat:@"%@——%@",[_model.start_time timeChangeYMdHHmm],[_model.end_time timeChangeYMdHHmm]];
    if (_model.select) {
        [self.btn setImage:[UIImage imageNamed:@"mapchoose_se"] forState:UIControlStateNormal];
    }else {
        [self.btn setImage:[UIImage imageNamed:@"mapchoose"] forState:UIControlStateNormal];
    }
}
- (void)btnClick:(UIButton *)btn {
    if (btn.selected) {
        _model.select = NO;
        btn.selected = NO;
    }else {
        _model.select = YES;
        btn.selected = YES;
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
