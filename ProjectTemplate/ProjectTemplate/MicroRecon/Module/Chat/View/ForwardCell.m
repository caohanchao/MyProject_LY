//
//  ForwardCell.m
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ForwardCell.h"
#import "UIImageView+CornerRadius.h"

@interface ForwardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ForwardCell




-(void)configDataSourceOfTModel:(TeamsListModel *)tModel FModel:(FriendsListModel*) fModel  andModelType:(ModelType)modelType;

{
    if (modelType == IsTeamsListModelType)
    {
        [self setTModel:tModel];
    }
    else
    {
        [self setFModel:fModel];
    }

}

-(void)setFModel:(FriendsListModel *)fModel
{
    _fModel =fModel;
    
    CGFloat radius = self.iconImage.frame.size.width/2;
    [self.iconImage imageGetCacheForAlarm:fModel.alarm forUrl:_fModel.headpic];
    [self.iconImage zy_cornerRadiusAdvance:width(self.iconImage.frame)/2 rectCornerType:UIRectCornerAllCorners];
//    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:_fModel.headpic] placeholderImage:nil];
    self.nameLabel.text =_fModel.name;
}

-(void)setTModel:(TeamsListModel *)tModel
{
    _tModel = tModel;
    
    NSString *imageStr;
    switch ([_tModel.type integerValue]) {
        case 0:
            imageStr = @"group_zhencha";
            break;
        case 1:
            imageStr = @"group_qunliao";
            break;
        case 2:
            imageStr = @"group_anbao";
            break;
        case 3:
            imageStr = @"group_xunkong";
            break;
        case 4:
            imageStr = @"group_sos";
            break;
        default:
            imageStr = @"ph_g";
            break;
    }
    
    self.iconImage.image = [UIImage imageNamed:imageStr];
    self.nameLabel.text = _tModel.gname;

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
