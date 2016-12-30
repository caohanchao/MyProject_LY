//
//  TaskIntroducedCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TaskIntroducedCell.h"
#import "UIView+Extension.h"

#define LeftMargin 12
#define TopMargin 15
#define TopMarginJT  17.5
#define RightMargin 70

@implementation TaskIntroducedCell {
    
    UILabel *_labelGroup;
    UILabel *_labelName;
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
    _labelGroup.text = @"任务介绍";
    _labelGroup.font = ZEBFont(14);
   
    [self.contentView addSubview:_labelGroup];
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-RightMargin-100, TopMargin, 100, 30)];
    _labelName.centerY=self.centerY;
    _labelName.font = ZEBFont(14);
    _labelName.textColor = CHCHexColor(@"808080");
    _labelName.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelName];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 10 - 12, 0, 10, 15)];
    imageView.centerY=self.centerY;
    imageView.image = [UIImage imageNamed:@"go_right"];
    [self.contentView addSubview:imageView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,45, kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
    [self.contentView addSubview:line];
    
}
- (void)setIntroducStr:(NSString *)introducStr {

    _introducStr = introducStr;
    
    _labelName.text = _introducStr;
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
