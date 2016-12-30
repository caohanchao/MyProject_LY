//
//  UserInfoTextViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserInfoTextViewCell.h"
#import "UIView+Extension.h"

#define LeftMargin 15

@implementation UserInfoTextViewCell {

    UILabel *_titleLabel;
    UILabel *_infoLabel;
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
    _titleLabel.font = ZEBFont(15);
    [self.contentView addSubview:_titleLabel];
    
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.textAlignment = NSTextAlignmentRight;
    _infoLabel.textColor = [UIColor grayColor];
    _infoLabel.font = ZEBFont(14);

    [self.contentView addSubview:_infoLabel];
}

- (void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    [self reloadCell];
}
- (void)reloadCell {
    
    _titleLabel.text = _titleStr;
    _infoLabel.text = _infoStr;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat titleWidth = [LZXHelper textWidthFromTextString:_titleStr height:30 fontSize:15];
    CGFloat infoWidth = [LZXHelper textWidthFromTextString:_infoStr height:30 fontSize:15];
  
        
    _titleLabel.frame = CGRectMake(LeftMargin, 5, titleWidth, 35);
    if (self.section == 0) {
        _infoLabel.frame = CGRectMake(kScreen_Width-LeftMargin-infoWidth-20, 5, infoWidth, 35);
    }else if(self.section == 1) {
        _infoLabel.frame = CGRectMake(kScreen_Width-LeftMargin-infoWidth, 5, infoWidth, 35);
    }
   
    
    
    
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
