//
//  CallHelpTopTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpTopTableViewCell.h"

@interface CallHelpTopTableViewCell () {
    
    UIImageView *_imageView;
    UILabel *_nameLabel;
}

@end

@implementation CallHelpTopTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    _imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    _imageView.frame = CGRectMake(15, 15, 50, 50);
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    
//    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 77, 60, 20)];
    _nameLabel.textColor  = zBlackColor;
    
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
     [self.contentView addSubview:_nameLabel];
    
}
- (void)setUserArr:(NSArray *)userArr {

    _userArr = userArr;
    UserAllModel * model = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:_userArr[self.row]];
    
    [_imageView imageGetCacheForAlarm:self.userArr[self.row] forUrl:model.RE_headpic];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([model.RE_alarmNum isEqualToString:alarm]) {
        UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
        _nameLabel.text = model.name;
    }else {
        _nameLabel.text = model.RE_name;
    }
    
//    if ([model.RE_name isEqualToString:@"文件助手"]||[model.RE_name isEqualToString:@"文件小助手"]) {
//        UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
//        _nameLabel.text = model.name;
//    }
//    else
//    {
//        _nameLabel.text = model.RE_name;
//    }

}
- (void)tap:(UITapGestureRecognizer*)recognizer
{
    if (self.userImageBlock) {
        self.userImageBlock();
    }
//    
//     [LYRouter openURL:@"ly://selsetCell" withUserInfo:nil completion:nil];
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
