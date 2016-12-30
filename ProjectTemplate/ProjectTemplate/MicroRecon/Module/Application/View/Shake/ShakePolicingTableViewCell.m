//
//  ShakePolicingTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakePolicingTableViewCell.h"
#import "ShakeCameraModel.h"

@interface ShakePolicingTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distance;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UIButton *phone;
@end

@implementation ShakePolicingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = CHCHexColor(@"eeeeee");
        self.selectedBackgroundView = view;
        
        [self initView];
    }
    return self;
}
- (void)initView {
    
    self.titleLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:CHCHexColor(@"000000") text:@"加大时间嗲时间嗲说"];
    
    
    self.location = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(12) textColor:CHCHexColor(@"808080") text:@"好速度啊速度滑动哈苏大户"];
    
    self.distance  = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(12) textColor:CHCHexColor(@"000000") text:@"450"];
    
    UIImageView *imageView = [CHCUI createImageWithbackGroundImageV:@"shake_phone"];
    
    self.phone = [CHCUI createButtonWithtarg:self sel:@selector(call:) titColor:CHCHexColor(@"808080") font:ZEBFont(10) image:nil backGroundImage:nil title:@"13033725910"];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.location];
    [self.contentView addSubview:self.distance];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:self.phone];
    
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@12);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.bottom.equalTo(self.location.mas_top).offset(-8);
        make.height.equalTo(@14);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@12);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.location.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(8);
        make.top.equalTo(self.location.mas_bottom).offset(8);
        make.height.equalTo(@10);
        make.width.mas_equalTo(150);
    }];
}
- (void)setModel:(ShakeCameraModel *)model {
    _model = model;
    [self reloadCell];
}
- (void)reloadCell {
    
    _titleLabel.text = [NSString stringWithFormat:@"%ld.%@",_model.udid+1,_model.NAME];
    _location.text = _model.ADDRESS;
    
    
    _distance.text = [NSString stringWithFormat:@"%ld米",[_model.distance integerValue]];
    
    [self.phone setTitle:[LZXHelper isNullToString:_model.PHONE] forState:UIControlStateNormal];
    
}
- (void)call:(UIButton *)btn {

    if (![[LZXHelper isNullToString:_model.PHONE] isEqualToString:@""]) {
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        parm[@"phone"] = _model.PHONE;
        [LYRouter openURL:@"ly://ShakeViewControllerCallPhone" withUserInfo:parm completion:^(id result) {
            
        }];
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
