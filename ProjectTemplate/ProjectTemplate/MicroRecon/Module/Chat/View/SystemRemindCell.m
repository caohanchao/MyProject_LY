//
//  SystemRemindCell.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define white_backgroundColor [UIColor whiteColor]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]
#define font(Int) [UIFont systemFontOfSize:Int]
#define leftMargin 12

#define TitleText(NSString) [NSString isEqualToString:@"O"] ? @"上线提醒" : @"发帖提醒"
#define DesText(NSString) [NSString isEqualToString:@"O"] ? @"我已上线,快来和我互动吧!": @"我已发帖,快来抢占沙发吧!"


#import "SystemRemindCell.h"
#import "UIImageView+CornerRadius.h"


@interface SystemRemindCell ()

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *bubbleImage;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *postLabel;
@property(nonatomic,strong)UIButton *notRemindBtn;
@property(nonatomic,strong)UILabel *titieLabel;
@property(nonatomic,strong)UILabel *desLabel;

//@property(nonatomic,copy)NSString *postName;

@end

@implementation SystemRemindCell

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [CHCUI createLabelWithbackGroundColor:CHCHexColor(@"bebebe") textAlignment:1 font:font(10) textColor:[UIColor whiteColor] text:nil];
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.layer.masksToBounds = YES;
    }
    return _timeLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(12) textColor:font_grayColor text:nil];
    }
    return _nameLabel;
}

- (UILabel *)postLabel {
    if (!_postLabel) {
        _postLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:1 font:font(10) textColor:[UIColor whiteColor] text:nil];
        _postLabel.layer.cornerRadius = 4;
        _postLabel.layer.masksToBounds = YES;
    }
    return _postLabel;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = zGroupTableViewBackgroundColor;
    }
    return _bgView;
}

- (UIImageView *)bubbleImage {
    if (!_bubbleImage) {
        _bubbleImage = [CHCUI createImageWithbackGroundImageV:@"System_Bubble"];
    }
    return _bubbleImage;

}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithCornerRadiusAdvance:50/2 rectCornerType:UIRectCornerAllCorners];
    }
    return _iconImage;
}

- (UILabel *)titieLabel {
    if (!_titieLabel) {
        _titieLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(15) textColor:zBlueColor text:nil];
    }
    return _titieLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(11) textColor:font_grayColor text:nil];
    }
    return _desLabel;
}



- (void)setModel:(ICometModel *)model {
    _model = model;
    _timeLabel.text = [_model.beginTime timeChage];
    [_iconImage imageGetCacheForAlarm:_model.data forUrl:_model.headpic];
    _titieLabel.text = TitleText(_model.mtype);
    _nameLabel.text = _model.sname;
    _desLabel.text = DesText(_model.mtype);
    [self updateViewConstraints];
    
//    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
    
    
}

- (void)updateViewConstraints {
    
    
    CGFloat timeWidth = [LZXHelper textWidthFromTextString:_timeLabel.text height:18 fontSize:10];
    
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX).with.offset(0);
        make.top.equalTo(self.bgView.mas_top).with.offset(12);
        make.width.offset(timeWidth+5);
        make.height.offset(18);
    }];
    
    
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.data];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    NSString *DE_type = uModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:uModel.DE_name];
    
    CGFloat postLabelWidth = self.postLabel.frame.size.width;
    
    if ([DE_name isEqualToString:@""]) {
        self.postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        self.postLabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            self.postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            self.postLabel.text = [NSString stringWithFormat:@" %@ ",userModel.RE_post];
        }else if ([DE_type isEqualToString:@"1"]) {
            self.postLabel.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            self.postLabel.text = [NSString stringWithFormat:@" %@ ",userModel.RE_post];
        }
    }
    
    postLabelWidth = [LZXHelper textWidthFromTextString:_postLabel.text height:15 fontSize:10];
    [self.postLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_top).with.offset(10);
        make.left.equalTo(self.iconImage.mas_right).with.offset(leftMargin);
        make.width.offset(postLabelWidth+5);
        make.height.equalTo(@15);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.bubbleImage];
    [self.bubbleImage addSubview:self.titieLabel];
    [self.bubbleImage addSubview:self.iconImage];
//    [self.bubbleImage addSubview:self.notRemindBtn];
    [self.bubbleImage addSubview:self.postLabel];
    [self.bubbleImage addSubview:self.nameLabel];
    
    
    [self.bubbleImage addSubview:self.desLabel];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.contentView.mas_width).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX).with.offset(0);
        make.top.equalTo(self.bgView.mas_top).with.offset(12);
        make.width.greaterThanOrEqualTo(@100);
        make.height.offset(18);
    }];
    
    [self.bubbleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).with.offset(40);
        make.left.equalTo(self.bgView.mas_left).with.offset(leftMargin);
        make.right.equalTo(self.bgView.mas_right).with.offset(-leftMargin);
        make.height.equalTo(@104);
    }];
    
    
    [self.titieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleImage.mas_top).with.offset(14);
        make.left.equalTo(self.bubbleImage.mas_left).with.offset(leftMargin);
        make.width.equalTo(@150);
        make.height.equalTo(@14);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titieLabel.mas_bottom).with.offset(12);
        make.left.equalTo(self.bubbleImage.mas_left).with.offset(leftMargin);
        make.width.and.height.equalTo(@50);
    }];
    
    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_top).with.offset(10);
        make.left.equalTo(self.iconImage.mas_right).with.offset(leftMargin);
        make.width.equalTo(@20);
        make.height.equalTo(@15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.postLabel.mas_top).with.offset(0);
        make.left.equalTo(self.postLabel.mas_right).with.offset(8);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(self.postLabel);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.postLabel.mas_bottom).with.offset(6);
        make.right.equalTo(self.bubbleImage.mas_right).with.offset(-leftMargin);
        make.left.equalTo(self.iconImage.mas_right).with.offset(leftMargin);
        make.height.equalTo(@11);
    }];

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
