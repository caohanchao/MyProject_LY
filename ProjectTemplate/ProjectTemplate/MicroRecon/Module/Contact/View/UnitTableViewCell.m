//
//  UnitTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UnitTableViewCell.h"
#import "UIView+Common.h"

#define LeftMargin 12
#define TopMargin 9


@implementation UnitTableViewCell{
    
    
    UIImageView *_imageTU;
    UILabel *_labelName;
    UIImageView *_jtLabel;
    
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
    
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_imageTU)+LeftMargin, minY(_imageTU), 150, 40)];
    
    _labelName.textColor = [UIColor blackColor];
    _labelName.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_labelName];
    
    
    _jtLabel = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth()-80, 15, 26, 26)];
    _jtLabel.image = [UIImage imageNamed:@"personal"];
    [self.contentView addSubview:_jtLabel];
    
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
