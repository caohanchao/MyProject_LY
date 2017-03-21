//
//  XMNChatEmotionsMessageCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/1.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "XMNChatEmotionsMessageCell.h"
#import "YYImage.h"

@interface XMNChatEmotionsMessageCell ()

@property (nonatomic, strong) YYAnimatedImageView *animatedImageView;

@end

@implementation XMNChatEmotionsMessageCell
- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.animatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-8);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(2);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(80);
            make.height.offset(80);
            
        }];
        
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        [self.animatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-2);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(8);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(80);
            make.height.offset(80);
            
        }];
    }
}

#pragma mark - Public Methods

- (void)setup {
    
    [self.messageContentV addSubview:self.animatedImageView];
    
    [super setup];
    
}

- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
    NSString *image = data[kXMNMessageConfigurationTextKey];
    
    NSArray *images = [image componentsSeparatedByString:@"/"];
    
    self.animatedImageView.image = [YYImage imageNamed:[images lastObject]];
    
}


#pragma mark - Getters

- (YYAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = [[YYAnimatedImageView alloc] init];
    }
    return _animatedImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
