//
//  VdDesHaveImageCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdDesHaveImageCell.h"


#define LeftMargin 12
#define TopMargin 12

#define Height 79

@interface VdDesHaveImageCell ()


@end

@implementation VdDesHaveImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
 
    //图片区
    self.imageScrollView = [[UIScrollView alloc]init];
    self.imageScrollView.pagingEnabled = NO;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.imageScrollView];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = CHCHexColor(@"eeeeee");
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setImageArray:(NSMutableArray *)imageArray {

    _imageArray = imageArray;
    
    CGFloat imageScrollViewWidth = 88*_imageArray.count+12*(_imageArray.count-1);
    if (imageScrollViewWidth>screenWidth() - LeftMargin*2)
    {
        imageScrollViewWidth = screenWidth() - LeftMargin*2;
    }
    
    if (_imageArray.count > 0)
    {
        _imageScrollView.frame = CGRectMake(LeftMargin, TopMargin,imageScrollViewWidth , Height);
    }
    else
    {
        _imageScrollView.frame = CGRectMake(LeftMargin, TopMargin, imageScrollViewWidth, Height);
    }
    
    [self.imageScrollView setContentSize:CGSizeMake(100*_imageArray.count, Height)];
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
