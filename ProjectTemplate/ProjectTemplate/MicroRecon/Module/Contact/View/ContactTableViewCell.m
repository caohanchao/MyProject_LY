//
//  ContactTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ContactTableViewCell.h"


#define LeftMargin 12
#define TopMargin 9

@implementation ContactTableViewCell {


    UIImageView *_imageTU;
    UILabel *_labelName;
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

    //_imageTU = [[UIImageView alloc] initWithCornerRadiusAdvance:20 rectCornerType:UIRectCornerAllCorners];
    _imageTU = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    
    _imageTU.frame = CGRectMake(LeftMargin, TopMargin, 40, 40);
    _imageTU.contentMode = UIViewContentModeScaleAspectFill;

    [self.contentView addSubview:_imageTU];
    
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_imageTU)+LeftMargin, minY(_imageTU), 150, 40)];
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
- (void)selectCellFR:(NSNotification *)notification {

    NSString *isSel = notification.object[isMemberSelect];
    if ([isSel isEqualToString:@"YES"]) {
       
    [_radionBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
    }else {
        
    [_radionBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    
    }
    
}
- (void)setFriendsLiModel:(FriendsListModel *)friendsLiModel {

    _friendsLiModel = friendsLiModel;
    [self reloadFrinedsCell];
    
}
- (void)reloadFrinedsCell {


    //[_imageTU sd_setImageWithURL:[NSURL URLWithString:_friendsLiModel.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"]];
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([_friendsLiModel.alarm isEqualToString:alarm]) {
        _imageTU.image = [UIImage imageNamed:@"wenjianzhushou"];
    }else {
        [_imageTU imageGetCacheForAlarm:_friendsLiModel.alarm forUrl:_friendsLiModel.headpic];
    }
    _labelName.text = _friendsLiModel.name;
    
    if (self.isSelect) {
        
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
