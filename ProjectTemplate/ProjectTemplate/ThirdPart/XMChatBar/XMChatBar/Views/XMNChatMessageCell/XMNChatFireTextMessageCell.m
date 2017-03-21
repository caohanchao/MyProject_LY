//
//  XMNChatFireTextMessageCell.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/12/30.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "XMNChatFireTextMessageCell.h"
#import "MLEmojiLabel.h"
#import "Masonry.h"
#import "XMFaceManager.h"

@interface XMNChatFireTextMessageCell ()<MLEmojiLabelDelegate>

/**

 *  阅后即焚的锁
 */
//@property (nonatomic, strong) UIImageView *fireMessageLockVI;

/**
 *  阅后即焚点击查看T
 */
//@property (nonatomic, strong) UIImageView *fireMessageTVI;

/**
 *  阅后即焚的倒计时
 */
//@property (nonatomic, strong) UILabel *fireMessageTimeLabel;

/**

 *  用于显示文本消息的文字
 */
@property (nonatomic, strong) MLEmojiLabel *messageTextL;
@property (nonatomic, copy, readonly) NSDictionary *fireTextStyle;

@end

@implementation XMNChatFireTextMessageCell
@synthesize fireTextStyle = _fireTextStyle;

#pragma mark - Override Methods

- (void)updateConstraints {
    [super updateConstraints];
    [self.messageTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentV).with.insets(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
}

- (void)setup {
    
    [self.messageContentV addSubview:self.messageTextL];

    [self.messageContentV addSubview:self.fireMessageLockVI];
    [self.messageContentV addSubview:self.fireMessageTVI];
    [self.messageContentV addSubview:self.fireMessageTimeLabel];

    [super setup];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showtimeout) name:@"showtimeout" object:nil];
    
}

- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
    
}

#pragma mark - Getters

- (MLEmojiLabel *)messageTextL {
    if (!_messageTextL) {
        _messageTextL = [MLEmojiLabel new];
        _messageTextL.textColor = self.messageOwner == XMNMessageOwnerSelf ? [UIColor whiteColor] : [UIColor blackColor];
        _messageTextL.font = [UIFont systemFontOfSize:14.0f];
        _messageTextL.numberOfLines = 0;
        _messageTextL.userInteractionEnabled = YES;
        _messageTextL.lineBreakMode = NSLineBreakByWordWrapping;
        [_messageTextL setEmojiDelegate:self];
    }
    return _messageTextL;
}

- (NSDictionary *)fireTextStyle {
    if (!_fireTextStyle) {
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentLeft;
        style.paragraphSpacing = 0.25 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        _fireTextStyle = @{NSFontAttributeName: font,
                       NSParagraphStyleAttributeName: style};
    }
    return _fireTextStyle;
    
}


//- (UIImageView *)fireMessageLockVI {
//    if (!_fireMessageLockVI) {
//        _fireMessageLockVI = [[UIImageView alloc] init];
//        _fireMessageLockVI.image = [UIImage imageNamed:@"lock"];;
//    }
//    return _fireMessageLockVI;
//}
//
//- (UIImageView *)fireMessageTVI {
//    if (!_fireMessageTVI) {
//        _fireMessageTVI = [[UIImageView alloc] init];
//        _fireMessageTVI.image = [UIImage imageNamed:@"T"];
//    }
//    return _fireMessageTVI;
//}
//
//- (UILabel *)fireMessageTimeLabel {
//    if (!_fireMessageTimeLabel) {
//        _fireMessageTimeLabel = [[UILabel alloc] init];
//        _fireMessageTimeLabel.backgroundColor = CHCHexColor(@"ff7200");
//        _fireMessageTimeLabel.layer.masksToBounds = YES;
//        _fireMessageTimeLabel.layer.cornerRadius = 7;
//        _fireMessageTimeLabel.font = [UIFont systemFontOfSize:8];
//        _fireMessageTimeLabel.textColor = CHCHexColor(@"ffffff");
//        _fireMessageTimeLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _fireMessageTimeLabel;
//}
//
//- (void)updateFireConstraints
//{
//    [self.fireMessageLockVI mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.messageContentBackgroundIV.mas_right).offset(2);
//        make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(-2);
//        make.width.equalTo(@14);
//        make.height.equalTo(@14);
//    }];
//    
//    [self.fireMessageTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.messageContentBackgroundIV.mas_right).offset(2);
//        make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(-2);
//        make.width.equalTo(@14);
//        make.height.equalTo(@14);
//    }];
//    
//    [self.fireMessageTVI mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.messageContentBackgroundIV.mas_right).offset(-12);
//        make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(8);
//        make.width.equalTo(@15);
//        make.height.equalTo(@16);
//    }];
//}


- (void)mlEmojiLabelDidSelectNoLink:(MLEmojiLabel *)emojiLabel
{
    [self.delegate messageCellTappedMessage:self];
}

@end
