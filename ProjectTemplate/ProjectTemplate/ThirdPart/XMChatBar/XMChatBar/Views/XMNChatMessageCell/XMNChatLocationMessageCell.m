//
//  XMNChatLocationMessageCell.m
//  XMNChatExample
//
//  Created by shscce on 15/11/17.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatLocationMessageCell.h"

#import "Masonry.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface XMNChatLocationMessageCell ()

@property (nonatomic, strong) UIImageView *locationIV;
@property (nonatomic, strong) UILabel *locationAddressL;

@end

@implementation XMNChatLocationMessageCell

#pragma mark - Override Methods

- (void)updateConstraints {
    [super updateConstraints];
    

    self.messageContentV.backgroundColor = [UIColor whiteColor];
    
    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-5);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(0);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(35);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(0);
            make.width.offset(220);
            make.height.offset(100);
        }];
        
        [self.locationAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.messageContentV.mas_left).with.offset(2);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(10);
            make.width.offset(220);
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-7);
            
        }];
        
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        
        [self.locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(0);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(5);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(35);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(0);
            make.width.offset(220);
            make.height.offset(100);
        }];
        
        [self.locationAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.messageContentV.mas_left).with.offset(7);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(10);
            make.width.offset(220);
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-2);
            
        }];
        
    }
    
    
    

}

#pragma mark - Public Methods

- (void)setup {
    
    [self.messageContentV addSubview:self.locationIV];
    [self.messageContentV addSubview:self.locationAddressL];
    [super setup];
    
}

- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
    NSString *url = data[kXMNMessageConfigurationLocationKey];
    [self setImage:self.locationIV url:url];
    self.locationAddressL.text = data[kXMNMessageConfigurationTextKey];
    
    
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

- (UILabel *)locationAddressL {
    if (!_locationAddressL) {
        _locationAddressL = [[UILabel alloc] init];
//        _locationAddressL.textColor = self.messageOwner == XMNMessageOwnerSelf ? [UIColor whiteColor] : [UIColor blackColor];
        _locationAddressL.textColor = [UIColor grayColor];
        _locationAddressL.font = [UIFont systemFontOfSize:14.0f];
        _locationAddressL.numberOfLines = 1;
        _locationAddressL.backgroundColor =[UIColor whiteColor];
        _locationAddressL.textAlignment = NSTextAlignmentCenter;
        
        _locationAddressL.lineBreakMode = NSLineBreakByTruncatingTail;
//        _locationAddressL.text = @"上海市 试验费snap那就开动脑筋阿萨德你接啊三年级可 ";
    }
    return _locationAddressL;
}

- (UIImageView *)locationIV {
    if (!_locationIV) {
        _locationIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        _locationIV.contentMode = UIViewContentModeScaleToFill;
//        [_locationIV zy_cornerRadiusAdvance:20 rectCornerType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    }
    return _locationIV;
}

@end
