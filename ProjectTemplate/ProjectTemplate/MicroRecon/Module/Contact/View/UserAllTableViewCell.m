//
//  UserAllTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserAllTableViewCell.h"

#define LeftMargin 31
#define TopMargin 9

@implementation UserAllTableViewCell {
    
    
    UIImageView *_imageTU;
    UILabel *_labelName;
    UILabel *_postnameL;
    UIButton *_radionBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
//    _imageTU = [[UIImageView alloc] initWithCornerRadiusAdvance:20 rectCornerType:UIRectCornerAllCorners];
    _imageTU = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    _imageTU.frame = CGRectMake(LeftMargin, TopMargin, 40, 40);
    _imageTU.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:_imageTU];
    
    
    _postnameL = [[UILabel alloc] init];
    _postnameL.frame = CGRectMake(LeftMargin + 50, TopMargin+10, 40, 20);
    _postnameL.font = [UIFont systemFontOfSize:12.0f];
    _postnameL.textColor = [UIColor whiteColor];
    _postnameL.layer.masksToBounds = YES;
    _postnameL.layer.cornerRadius = 3;
    _postnameL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_postnameL];
    
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_postnameL)+10, minY(_imageTU), 150, 40)];
    _labelName.textColor = [UIColor blackColor];
    _labelName.font = ContactFont;
    [self.contentView addSubview:_labelName];
    
    _radionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _radionBtn.frame = CGRectMake(0, 0, 30, 30);
    _radionBtn.center = CGPointMake(kScreen_Width-35, midY(_labelName));
    [_radionBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    _radionBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_radionBtn];
    
    
    
}
- (void)selectedCell {
    
    if (self.isSelect) {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        
    }else {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
      
        
    }
    
}
- (void)selectCellUT:(NSNotification *)notification {
    
    NSString *isSel = notification.object[isMemberSelect];
    if ([isSel isEqualToString:@"YES"]) {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
    }else {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        
    }

}
- (void)setModel:(UserAllModel *)model {

    _model = model;
    [self reloadCell];
}

- (void)reloadCell {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    UserInfoModel *meModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    if ([_model.RE_alarmNum isEqualToString:alarm]) {
      // [_imageTU sd_setImageWithURL:[NSURL URLWithString:meModel.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"]];
        [_imageTU imageGetCacheForAlarm:meModel.alarm forUrl:meModel.headpic];
        _labelName.text = meModel.name;
    }else {
    //[_imageTU sd_setImageWithURL:[NSURL URLWithString:_model.RE_headpic] placeholderImage:[UIImage imageNamed:@"ph_s"]];
        [_imageTU imageGetCacheForAlarm:_model.RE_alarmNum forUrl:_model.RE_headpic];
    _labelName.text = _model.RE_name;
    }

    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:_model.RE_department];
    NSString *DE_type = uModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:uModel.DE_name];
    NSString *str =  [NSString stringWithFormat:@" %@ ",DE_name];
    
    CGFloat width =_postnameL.frame.size.width;
//    width = [LZXHelper textWidthFromTextString:str height:20 fontSize:12];
    width = 0;
    
//    if ([[LZXHelper isNullToString:DE_type] isEqualToString:@""]) {
//        _postnameL.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
//        
//        _postnameL.text = [NSString stringWithFormat:@" 武汉市公安局 "];
//         width = [LZXHelper textWidthFromTextString:_postnameL.text height:20 fontSize:12];
//        
//        
//    }else {
//        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
//            _postnameL.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
//            _postnameL.text = [NSString stringWithFormat:@" %@ ",self.model.RE_post];
//            width = [LZXHelper textWidthFromTextString:_postnameL.text height:20 fontSize:12];
//            
//        }else if ([DE_type isEqualToString:@"1"]) {
//            _postnameL.layer.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"].CGColor;
//            _postnameL.text = [NSString stringWithFormat:@" %@ ",self.model.RE_post];
//            width = [LZXHelper textWidthFromTextString:_postnameL.text height:20 fontSize:12];
//        }
//        
//    }
//    if (width>140)
//    {
//        _postnameL.frame = CGRectMake(LeftMargin + 50, TopMargin+10, 140, 20);
//    }else{
//        _postnameL.frame = CGRectMake(LeftMargin + 50, TopMargin+10, width+8, 20);
//    }
    
//    _labelName.frame = CGRectMake(maxX(_postnameL)+10, minY(_imageTU), 150, 40);
    _labelName.frame = CGRectMake(LeftMargin + 50, minY(_imageTU), 150, 40);
    
    if ([_model.isSelect boolValue]) {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        
    }else {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        
        
    }
    
    if (self.isContact) {
        _radionBtn.hidden = YES;
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
