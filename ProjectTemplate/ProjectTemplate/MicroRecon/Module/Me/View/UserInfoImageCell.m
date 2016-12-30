//
//  UserInfoImageCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserInfoImageCell.h"

#define LeftMargin 15

@implementation UserInfoImageCell {

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
    _titleLabel.font = ZEBFont(15);
    [self.contentView addSubview:_titleLabel];
    
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
}
- (void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    [self reloadCell];
}
- (void)reloadCell {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    _titleLabel.text = _titleStr;
    if ([_titleStr isEqualToString:@"头像"]) {
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = _imageView.frame.size.width/2;
       //[_imageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:nil];
        [_imageView imageGetCacheForAlarm:alarm forUrl:_imageStr];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [_imageView addGestureRecognizer:tap];
    }else if ([_titleStr isEqualToString:@"我的二维码"]) {
        
        _imageView.image = [UIImage imageNamed:@"qrcode_small"];
        }
   
}
- (void)click:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(userInfoImageCell:imageView:)]) {
        [_delegate userInfoImageCell:self imageView:tap.view];
    }
}
- (void)layoutSubviews {

    [super layoutSubviews];
    
    if ([_titleStr isEqualToString:@"头像"]) {
        
        _titleLabel.frame = CGRectMake(LeftMargin, 15, 120, 40);
        _imageView.frame = CGRectMake(kScreen_Width-LeftMargin-70, 10, 50, 50);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = _imageView.frame.size.width/2;
        
    }else if ([_titleStr isEqualToString:@"我的二维码"]) {
    
        _titleLabel.frame = CGRectMake(LeftMargin, 5, 120, 35);
        _imageView.frame = CGRectMake(kScreen_Width-LeftMargin-42.5, 12.5, 20, 20);
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
