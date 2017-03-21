//
//  TeamTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TeamTableViewCell.h"


#define LeftMargin 12
#define TopMargin 9


@implementation TeamTableViewCell{
    
    
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
    
    _imageTU = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, 40, 40)];
    
    [self.contentView addSubview:_imageTU];
    
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_imageTU)+LeftMargin, minY(_imageTU), screenWidth() - LeftMargin*3 -40, 40)];
    
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
- (void)selectCellTM:(NSNotification *)notification {
    
    NSString *isSel = notification.object[isMemberSelect];
    if ([isSel isEqualToString:@"YES"]) {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
    }else {
        
        [_radionBtn setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        
    }
    
}
- (void)setTeamListModel:(TeamsListModel *)teamListModel {

    _teamListModel = teamListModel;
    [self reloadTeamsCell];
}
- (void)reloadTeamsCell {
    
    NSString *title = [NSString stringWithFormat:@"%@（%@）",_teamListModel.gname,_teamListModel.count];
    
    _labelName.text = title;
   
    NSString *imageStr;
    switch ([_teamListModel.type integerValue]) {
        case 0:
            // imageStr = @"group_zhencha";
            imageStr = @"G_zhencha";
            break;
        case 1:
            // imageStr = @"group_qunliao";
            imageStr = @"G_zudui";
            break;
        case 2:
            // imageStr = @"group_anbao";
            imageStr = @"G_pancha";
            break;
        case 3:
            //imageStr = @"group_xunkong";
            imageStr = @"G_xunkong";
            break;
        case 4:
            //  imageStr = @"group_sos";
            imageStr = @"G_zengyuan";
            break;
        case 5:
            imageStr = @"G_duikang";
            break;
        default:
            imageStr = @"ph_g";
            break;
    }
    
    _imageTU.image = [UIImage imageNamed:imageStr];
    
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
