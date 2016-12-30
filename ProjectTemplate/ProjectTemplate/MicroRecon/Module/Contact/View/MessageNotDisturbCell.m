//
//  MessageNotDisturbCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MessageNotDisturbCell.h"
#import "UIView+Extension.h"

#define LeftMargin 12
#define TopMargin 15

@implementation MessageNotDisturbCell  {
    
    UILabel *_labelGroup;
    UISwitch *_switch;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _labelGroup = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, 100, 30)];
    _labelGroup.centerY=self.centerY;
    _labelGroup.text = @"消息免打扰";
    _labelGroup.font = ZEBFont(14);
    
    [self.contentView addSubview:_labelGroup];
    
    _switch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreen_Width - 50 - 12, TopMargin, 50, 30)];
    _switch.centerY=self.centerY;
    
    _switch.onTintColor = zBlueColor;
    _switch.enabled = YES;
    
    [_switch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switch];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
    
    [self.contentView addSubview:line];
    
}

- (void)setGid:(NSString *)gid {

    _gid = gid;
    TeamsListModel *model = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:_gid];
//
    _switch.on = [model.isRemindSet boolValue];
//    _switch.on = [[NSUserDefaults standardUserDefaults] boolForKey:_gid];
    
}
- (void)switchChange:(UISwitch *)sw {

//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setBool:sw.isOn forKey:self.gid];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[DBManager sharedManager] GrouplistSQ] updateGroupIsRemindSet:[NSString stringWithFormat:@"%d",sw.on] gid:self.gid];

    
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
