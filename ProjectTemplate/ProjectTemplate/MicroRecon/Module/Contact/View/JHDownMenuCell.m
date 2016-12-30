//
//  JHDownMenuCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "JHDownMenuCell.h"

#import "UIView+Common.h"


#define LeftMargin 10
#define TopMargin 45/4

@implementation JHDownMenuCell {

    UIImageView *_imageTU;
    UILabel *_lineLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _imageTU = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, height(self.contentView.frame)-2*TopMargin, height(self.contentView.frame)-2*TopMargin)];
    
    [self.contentView addSubview:_imageTU];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_imageTU)+LeftMargin+10, minY(_imageTU), 100, height(self.contentView.frame)-2*TopMargin)];
    
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];

    
    
//    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, maxY(_titleLabel)+5, width(self.contentView.frame)-2*LeftMargin, 0.5)];
//    _lineLabel.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:_lineLabel];
    
}
- (void)setTitleStr:(NSString *)titleStr {

    _titleStr = titleStr;
    
    _titleLabel.text = titleStr;
}
- (void)setImageStr:(NSString *)imageStr {

    _imageStr = imageStr;
    
    _imageTU.image = [UIImage imageNamed:imageStr];
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
