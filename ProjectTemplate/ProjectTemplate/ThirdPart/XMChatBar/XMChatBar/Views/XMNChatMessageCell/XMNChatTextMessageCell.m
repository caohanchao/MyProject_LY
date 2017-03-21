//
//  XMNChatTextMessageCell.m
//  XMNChatExample
//
//  Created by shscce on 15/11/13.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatTextMessageCell.h"
#import "MLEmojiLabel.h"
#import "Masonry.h"
#import "XMFaceManager.h"

//static NSString * _showORCancelTimeout;

@interface XMNChatTextMessageCell ()<MLEmojiLabelDelegate>

/**
 *  用于显示文本消息的文字
 */
@property (nonatomic, strong) MLEmojiLabel *messageTextL;
@property (nonatomic, copy, readonly) NSDictionary *textStyle;

@end

@implementation XMNChatTextMessageCell
@synthesize textStyle = _textStyle;

#pragma mark - Override Methods

- (void)updateConstraints {
    [super updateConstraints];
    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.messageTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.messageContentV).with.insets(UIEdgeInsetsMake(8, 16, 8, 16));
        }];
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        [self.messageTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.messageContentV).with.insets(UIEdgeInsetsMake(8, 20, 8, 12));
        }];
    }
    
}

#pragma mark - Public Methods

- (void)setup {
    
    [self.messageContentV addSubview:self.messageTextL];
    [super setup];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showtimeout) name:@"showtimeout" object:nil];
    
}

//- (void)showtimeout
//{
//    _showORCancelTimeout = @"show";
//}


- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
    ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[data[kXMNMessageConfigurationQIDKey]integerValue]];
    
    [self.messageTextL setEmojiText:[data[kXMNMessageConfigurationTextKey]transferredMeaningWithEnter]];
    
    if (data[kXMNMessageConfigurationFireKey])
    {
        self.fireType = data[kXMNMessageConfigurationFireKey];
        if (![[LZXHelper isNullToString:self.fireType] isEqualToString:@""])
        {
            
            if ([self.fireType containsString:@"LOCK"]&&![self.fireType isEqualToString:@"UNLOCK"])
            {
                self.hidden = NO;
                if ([data[kXMNMessageConfigurationOwnerKey] integerValue]==2)
                {
                    self.fireMessageTimeLabel.hidden = YES;
                    self.fireMessageLockVI.hidden = NO;
                    self.fireMessageTVI.hidden = YES;
                }
                else
                {
                    [self.messageTextL setEmojiText:@"点击查看"];
                    self.fireMessageTimeLabel.hidden = YES;
                    self.fireMessageTVI.hidden = NO;
                    
                }
            }
            else if ([self.fireType isEqualToString:@"UNLOCK"])
            {
                self.hidden = NO;
                if ([data[kXMNMessageConfigurationOwnerKey] integerValue]==3)
                {
                    self.fireMessageLockVI.hidden = YES;
                    self.fireMessageTimeLabel.hidden = NO;
                    self.fireMessageTVI.hidden = YES;
                }
                
                if (data[kXMNMessageConfigurationTimerStrKey])
                {
                    NSString * timerStr = data[kXMNMessageConfigurationTimerStrKey];
                    if ((![[LZXHelper isNullToString:timerStr] isEqualToString:@""]) )
                    {
                        if ([timerStr integerValue]>1)
                        {
                            //                            self.fireMessageTimeLabel.text = @"";
                            self.fireMessageTimeLabel.text = timerStr;
//                            if ([_showORCancelTimeout isEqualToString:@"show"])
//                            {
//                                [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
//                                [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
//                                [[NSNotificationCenter defaultCenter]postNotificationName:ChatControllerRefreshUINotification object:nil];
//                            }
                        }
                        else
                        {
                            [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
                            [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
                            [[NSNotificationCenter defaultCenter]postNotificationName:ChatControllerRefreshUINotification object:nil];
                            self.fireMessageTimeLabel.hidden = YES;
                            self.hidden = YES;
                        }
                    }
                }
            }
            else if ([self.fireType isEqualToString:@"READ"])
            {
                self.fireMessageTimeLabel.hidden = YES;
                self.hidden = YES;
            }
            else
            {
                self.hidden = NO;
            }
        }
        
    }
  //  _showORCancelTimeout = @"";
    
    //
    //    if ([string rangeOfString:@"martin"].location == NSNotFound) {
    //        NSLog(@"string 不存在 martin");
    //    }
    //    if ([str containsString:@"world"]) {
    //        NSLog(@"str 包含 world");
    //    }
    
    //    NSMutableAttributedString *attrS = [XMFaceManager emotionStrWithString:data[kXMNMessageConfigurationTextKey]];
    //    [attrS addAttributes:self.textStyle range:NSMakeRange(0, attrS.length)];
    //    self.messageTextL.attributedText = attrS;
    
}

//-(void)getTimeoutwithTimerstr:(NSString *)string withDic:(NSDictionary*)dic
//{
//    
//    
//    ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[dic[kXMNMessageConfigurationQIDKey]integerValue]];
//    __block int timeout  = [string intValue];
//    
//    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0)
//        {
//            dispatch_source_cancel(_timer);
//            [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
//            [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[NSNotificationCenter defaultCenter]postNotificationName:ChatControllerRefreshUINotification object:nil];
//            });
//        }else{
//            [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:[NSString stringWithFormat:@"%d",timeout]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.fireMessageTimeLabel.text = @"";
//                self.fireMessageTimeLabel.text = [NSString stringWithFormat:@"%d",timeout];
//                
//            });
//            
//            timeout--;
//        }
//    });
//    dispatch_resume(_timer);
//    
//}



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

- (NSDictionary *)textStyle {
    if (!_textStyle) {
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentLeft;
        style.paragraphSpacing = 0.25 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        _textStyle = @{NSFontAttributeName: font,
                 NSParagraphStyleAttributeName: style};
    }
    return _textStyle;
    
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

//富文本处理
#pragma mark - OHAttributedLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    
    // NSMutableString * linkString = [[NSMutableString alloc]init];
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"我草点击了链接%@",link);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickLinkUrlNotification" object:link];
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            
            break;
        case MLEmojiLabelLinkTypePoundSign:
             NSLog(@"点击了话题%@",link);
        
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
        }
}
//双击手势
- (void)mlEmojiLabelDidDoubleTap:(MLEmojiLabel *)emojiLabel {
    
    [self.delegate messageCellDoubleTappedMessage:self];
}

- (void)mlEmojiLabelDidSelectNoLink:(MLEmojiLabel *)emojiLabel
{
    [self.delegate messageCellTappedMessage:self];
}

@end
