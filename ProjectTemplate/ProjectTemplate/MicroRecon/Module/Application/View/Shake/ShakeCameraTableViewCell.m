//
//  ShakeCameraTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeCameraTableViewCell.h"
#import "ShakeCameraModel.h"

@interface ShakeCameraTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *cameraType;
@property (nonatomic, strong) UILabel *distance;
@property (nonatomic, strong) UILabel *location;
@end

@implementation ShakeCameraTableViewCell


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
    
    self.titleLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:CHCHexColor(@"000000") text:@""];
    
    self.cameraType = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(8) textColor:zWhiteColor text:@""];
    self.cameraType.layer.masksToBounds = YES;
    self.cameraType.layer.cornerRadius = 3;
    
    self.location = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(12) textColor:CHCHexColor(@"808080") text:@""];
    
    self.distance  = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(12) textColor:CHCHexColor(@"000000") text:@""];

    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cameraType];
    [self.contentView addSubview:self.location];
    [self.contentView addSubview:self.distance];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(10.5);
        make.height.equalTo(@14);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.cameraType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top);
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@12);
    }];
    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@12);
        make.width.mas_lessThanOrEqualTo(80);
    }];
}
- (void)setModel:(ShakeCameraModel *)model {
    _model = model;
    [self reloadCell];
}
- (void)reloadCell {

    _titleLabel.text = [NSString stringWithFormat:@"%ld.%@",_model.udid+1,_model.NAME];
    if (self.type == 0) {
        if ([_model.FL isEqualToString:@"1"]) {
            _cameraType.layer.backgroundColor = CHCHexColor(@"fdaf3a").CGColor;
            _cameraType.text = @"一类点";
        }else if ([_model.FL isEqualToString:@"2"]) {
            _cameraType.layer.backgroundColor = CHCHexColor(@"6cd9a3").CGColor;
            _cameraType.text = @"二类点";
        }else if ([_model.FL isEqualToString:@"3"]) {
            _cameraType.layer.backgroundColor = CHCHexColor(@"96b0fb").CGColor;
            _cameraType.text = @"三类点";
        }
    }else {
        _cameraType.hidden = YES;
    }
    _location.text = _model.ADDRESS;
    
   
    _distance.text = [NSString stringWithFormat:@"%ld米",[_model.distance integerValue]];
    
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
