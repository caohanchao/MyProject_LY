//
//  CHCDownMenuCell.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define LeftMargin 15
#define TopMargin 10

#import "CHCDownMenuCell.h"

@interface CHCDownMenuCell ()
{
    UIImageView *_imageTU;
    UILabel *_titleLabel;
    UILabel *_lineLabel;
}
@end

@implementation CHCDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _imageTU = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, 16, 16)];
    
    [self.contentView addSubview:_imageTU];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_imageTU)+20,TopMargin, 100, 16)];
    
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:13];
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
