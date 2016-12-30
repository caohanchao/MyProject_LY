//
//  ClearAllMessageCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ClearAllMessageCell.h"
#import "UIView+Extension.h"

#define LeftMargin 12
#define TopMargin 15

@implementation ClearAllMessageCell {
    
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
    _labelGroup.text = @"清空聊天记录";
    _labelGroup.font = ZEBFont(14);
    
    [self.contentView addSubview:_labelGroup];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,45, kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
    [self.contentView addSubview:line];
    
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
