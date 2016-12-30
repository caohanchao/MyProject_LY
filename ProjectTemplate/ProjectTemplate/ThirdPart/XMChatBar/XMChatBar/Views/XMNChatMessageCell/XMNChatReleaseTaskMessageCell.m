//
//  XMNChatReleaseTaskMessageCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "XMNChatReleaseTaskMessageCell.h"

@interface XMNChatReleaseTaskMessageCell ()

@property (nonatomic, strong) UILabel *topTaskLabel;
@property (nonatomic, strong) UIImageView *leftTaskImage;
@property (nonatomic, strong) UILabel *rightTaskLabel;

@end

@implementation XMNChatReleaseTaskMessageCell

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.topTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.messageContentV.mas_left).with.offset(16);
        make.top.equalTo(self.messageContentV.mas_top).offset(5);
    }];
    
    [self.leftTaskImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.messageContentV.mas_left).with.offset(16);
        make.bottom.equalTo(self.messageContentV.mas_bottom).offset(-5);
        make.width.equalTo(@45);
        make.height.equalTo(@45);
    }];
    
    [self.rightTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftTaskImage.mas_right).offset(10);
        make.bottom.equalTo(self.leftTaskImage.mas_bottom);
        make.right.equalTo(self.messageContentV.mas_right).offset(-10);
        make.height.equalTo(@60);
    }];
}

#pragma mark - Public Methods

- (void)setup {
    
    [self.messageContentV addSubview:self.topTaskLabel];
    [self.messageContentV addSubview:self.leftTaskImage];
    [self.messageContentV addSubview:self.rightTaskLabel];
    [super setup];
    
}

- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
//    NSString *url = data[kXMNMessageConfigurationLocationKey];
//    [self setImage:self.locationIV url:url];
//    self.locationAddressL.text = data[kXMNMessageConfigurationTextKey];
    
    self.topTaskLabel.text = data[kXMNMessageConfigurationWorkNameKey];
    NSMutableString *text = (NSMutableString *)data[kXMNMessageConfigurationTextKey];
    self.rightTaskLabel.text=text;
    //self.rightTaskLabel.text = [text stringByAppendingString:@"，点击查看"];
  
}

- (void)setImage:(UIImageView *)imgeView url:(NSString *)urlString{
    if (!urlString) {
        return;
    }
    dispatch_async(dispatch_queue_create("pic", nil), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgeView.image = [UIImage imageWithData:data];
        });
    });
}

#pragma mark - Getters

- (UILabel *)rightTaskLabel {
    if (!_rightTaskLabel) {
        _rightTaskLabel = [[UILabel alloc] init];
        _rightTaskLabel.textColor = [UIColor blackColor];
        _rightTaskLabel.font = [UIFont systemFontOfSize:14.0f];
        _rightTaskLabel.numberOfLines = 2;
        _rightTaskLabel.textAlignment = NSTextAlignmentNatural;
        _rightTaskLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        _locationAddressL.text = @"上海市 试验费snap那就开动脑筋阿萨德你接啊三年级可 ";
    }
    return _rightTaskLabel;
}
- (UILabel *)topTaskLabel {

    if (_topTaskLabel == nil) {
        _topTaskLabel = [[UILabel alloc] init];
        _topTaskLabel.textColor = [UIColor whiteColor];
        _topTaskLabel.font = ZEBFont(12);
        _topTaskLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _topTaskLabel;
}

- (UIImageView *)leftTaskImage {
    if (!_leftTaskImage) {
        _leftTaskImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chat_inform"]];
    }
    return _leftTaskImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
