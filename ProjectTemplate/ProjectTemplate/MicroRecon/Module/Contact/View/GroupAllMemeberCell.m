//
//  GroupAllMemeberCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupAllMemeberCell.h"
#import "UIView+Extension.h"

#define LeftMargin 15
#define TopMargin 15
#define TopMarginJT  17.5

@implementation GroupAllMemeberCell {
    
    UILabel *_labelGroup;
   
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _labelGroup = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin,0, 100, 30)];
    _labelGroup.centerY=self.centerY;
    _labelGroup.text = @"所有成员";
    _labelGroup.font = ZEBFont(15);
   
    [self.contentView addSubview:_labelGroup];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-40, 0, 25, 25)];
    imageView.centerY=self.centerY;
    imageView.image = [UIImage imageNamed:@"personal"];
    [self.contentView addSubview:imageView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,45, kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
    [self.contentView addSubview:line];
    
}
- (void)setCount:(NSString *)count {

    _labelGroup.text = [NSString stringWithFormat:@"所有成员(%@)",count];
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
