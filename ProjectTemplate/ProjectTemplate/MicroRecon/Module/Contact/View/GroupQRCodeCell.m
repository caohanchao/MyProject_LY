//
//  GroupQRCodeCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupQRCodeCell.h"
#import "UIView+Extension.h"

#define LeftMargin 12
#define RightMargin 70
#define TopMargin 15
@implementation GroupQRCodeCell {
    
    UILabel *_titleLabel;
    UIImageView *_imageView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = ZEBFont(14);
    [self.contentView addSubview:_titleLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 10 - 12, 0, 10, 15)];
    imgView.centerY=self.centerY;
    imgView.image = [UIImage imageNamed:@"go_right"];
    [self.contentView addSubview:imgView];
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    _titleLabel.frame = CGRectMake(LeftMargin, TopMargin/2, 120, 30);
    _imageView.frame = CGRectMake(kScreen_Width-RightMargin-20, 10, 20, 20);
    _imageView.centerY = self.centerY;
    
    
    _titleLabel.text = @"群二维码";
    _imageView.image = [UIImage imageNamed:@"qrcode_small"];
    
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
