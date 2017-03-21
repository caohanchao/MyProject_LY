//
//  XMNChatVoiceMessageCell.m
//  XMNChatExample
//
//  Created by shscce on 15/11/16.
//  Copyright © 2015年 xmfraker. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "XMNChatVoiceMessageCell.h"
#import "Masonry.h"

@interface XMNChatVoiceMessageCell ()

@property (nonatomic, strong) UIImageView *messageVoiceStatusIV;
@property (nonatomic, strong) UILabel *messageVoiceSecondsL;
@property (nonatomic, strong) UIActivityIndicatorView *messageIndicatorV;

@end

@implementation XMNChatVoiceMessageCell

#pragma mark - Override Methods


- (void)prepareForReuse {

    [super prepareForReuse];
    [self setVoiceMessageState:_voiceMessageState];
    
}

- (void)updateConstraints {
    [super updateConstraints];

    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.messageVoiceStatusIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-12);
            make.centerY.equalTo(self.messageContentV.mas_centerY);
        }];
        [self.messageVoiceSecondsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageVoiceStatusIV.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentV.mas_centerY);
        }];
        [self.messageIndicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.messageContentV);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        [self.messageVoiceStatusIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageContentV.mas_left).with.offset(12);
            make.centerY.equalTo(self.messageContentV.mas_centerY);
        }];
        
        [self.messageVoiceSecondsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageVoiceStatusIV.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentV.mas_centerY);
        }];
        [self.messageIndicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.messageContentV);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
    
    [self.messageContentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
    }];

}

#pragma mark - Public Methods

- (void)setup {

    [self.messageContentV addSubview:self.messageVoiceSecondsL];
    [self.messageContentV addSubview:self.messageVoiceStatusIV];
    [self.messageContentV addSubview:self.messageIndicatorV];
    [super setup];
    self.voiceMessageState = XMNVoiceMessageStateNormal;
    
}

- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
 
    self.messageVoiceSecondsL.text = [NSString stringWithFormat:@"%d''",[data[kXMNMessageConfigurationVoiceSecondsKey] intValue]];
    
    self.fireMessageTVI.hidden = YES;
    
    ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[data[kXMNMessageConfigurationQIDKey]integerValue]];
    
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
                    
                }
                else if ([data[kXMNMessageConfigurationOwnerKey] integerValue]==3)
                {
                    self.fireMessageTimeLabel.hidden = YES;
                    if(_voiceMessageState == XMNVoiceMessageStateCancel||_voiceMessageState == XMNVoiceMessageStateFinish)
                    {
                        self.fireMessageLockVI.hidden = YES;
                        self.fireMessageTimeLabel.hidden = NO;
                    }
                    self.messageVoiceStatusIV.image = [UIImage imageNamed:@"Fmessage_voice_receiver_playing_3"];
                    UIImage *image1 = [UIImage imageNamed:self.messageOwner == XMNMessageOwnerSelf ? @"message_voice_sender_playing_1" : @"Fmessage_voice_receiver_playing_1"];
                    UIImage *image2 = [UIImage imageNamed:self.messageOwner == XMNMessageOwnerSelf ? @"message_voice_sender_playing_2" : @"Fmessage_voice_receiver_playing_2"];
                    UIImage *image3 = [UIImage imageNamed:self.messageOwner == XMNMessageOwnerSelf ? @"message_voice_sender_playing_3" : @"Fmessage_voice_receiver_playing_3"];
                    self.messageVoiceStatusIV.highlightedAnimationImages = @[image1,image2,image3];
                }
            }
             else if ([self.fireType isEqualToString:@"UNLOCK"])
             {
                 self.hidden = NO;
                 if ([data[kXMNMessageConfigurationOwnerKey] integerValue]==3)
                 {
                     if(_voiceMessageState == XMNVoiceMessageStateCancel||_voiceMessageState == XMNVoiceMessageStateFinish)
                     {
                         self.fireMessageLockVI.hidden = YES;
                         self.fireMessageTimeLabel.hidden = NO;
                     }
                     else
                     {
                             self.fireMessageLockVI.hidden = NO;
                             self.fireMessageTimeLabel.hidden = YES;
                    }
                 }
                 
                 if (data[kXMNMessageConfigurationTimerStrKey])
                 {
                     NSString * timerStr = data[kXMNMessageConfigurationTimerStrKey];
                     if ((![[LZXHelper isNullToString:timerStr] isEqualToString:@""]) )
                     {
                         if ([timerStr integerValue]>1)
                         {
                             self.fireMessageLockVI.hidden = YES;
                             self.fireMessageTimeLabel.hidden = NO;
                             self.fireMessageTimeLabel.text = timerStr;
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
                // self.fireMessageTimeLabel.hidden = YES;
                 self.hidden = YES;
             }
             else
             {
                 self.hidden = NO;
             }
        }
        else
        {
            self.fireMessageLockVI.hidden = YES;
            self.fireMessageTimeLabel.hidden = YES;
        }
    }
    
}

#pragma mark - Getters

- (UIImageView *)messageVoiceStatusIV {
    if (!_messageVoiceStatusIV) {
        _messageVoiceStatusIV = [[UIImageView alloc] init];
        _messageVoiceStatusIV.image = self.messageOwner != XMNMessageOwnerSelf ? [UIImage imageNamed:@"message_voice_receiver_normal"] : [UIImage imageNamed:@"message_voice_sender_playing_3"];
        UIImage *image1 = [UIImage imageNamed:self.messageOwner == XMNMessageOwnerSelf ? @"message_voice_sender_playing_1" : @"message_voice_receiver_playing_1"];
        UIImage *image2 = [UIImage imageNamed:self.messageOwner == XMNMessageOwnerSelf ? @"message_voice_sender_playing_2" : @"message_voice_receiver_playing_2"];
        UIImage *image3 = [UIImage imageNamed:self.messageOwner == XMNMessageOwnerSelf ? @"message_voice_sender_playing_3" : @"message_voice_receiver_playing_3"];
        _messageVoiceStatusIV.highlightedAnimationImages = @[image1,image2,image3];
        _messageVoiceStatusIV.animationDuration = 1.5f;
        _messageVoiceStatusIV.animationRepeatCount = NSUIntegerMax;
    }
    return _messageVoiceStatusIV;
}

- (UILabel *)messageVoiceSecondsL {
    if (!_messageVoiceSecondsL) {
        _messageVoiceSecondsL = [[UILabel alloc] init];
        _messageVoiceSecondsL.font = [UIFont systemFontOfSize:14.0f];
        _messageVoiceSecondsL.textColor = self.messageOwner == XMNMessageOwnerSelf ? [UIColor whiteColor] : [UIColor blackColor];
        _messageVoiceSecondsL.text = @"0''";
    }
    return _messageVoiceSecondsL;
}

- (UIActivityIndicatorView *)messageIndicatorV {
    if (!_messageIndicatorV) {
        _messageIndicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _messageIndicatorV;
}

#pragma mark - Setters

- (void)setVoiceMessageState:(XMNVoiceMessageState)voiceMessageState {
    if (_voiceMessageState != voiceMessageState) {
        _voiceMessageState = voiceMessageState;
    }
    self.messageVoiceSecondsL.hidden = NO;
    self.messageVoiceStatusIV.hidden = NO;
    self.messageIndicatorV.hidden = YES;
    self.fireMessageLockVI.image = [UIImage imageNamed:@"lock"];
    [self.messageIndicatorV stopAnimating];
    
    if (_voiceMessageState == XMNVoiceMessageStatePlaying) {
        self.messageVoiceStatusIV.highlighted = YES;
        self.fireMessageLockVI.image = [UIImage imageNamed:@"openLock"];
        [self.messageVoiceStatusIV startAnimating];
    }else if (_voiceMessageState == XMNVoiceMessageStateDownloading) {
        self.messageVoiceSecondsL.hidden = YES;
        self.messageVoiceStatusIV.hidden = YES;
        self.messageIndicatorV.hidden = NO;
        [self.messageIndicatorV startAnimating];
    }else {
        self.messageVoiceStatusIV.highlighted = NO;
        self.fireMessageLockVI.image = [UIImage imageNamed:@"lock"];
        [self.messageVoiceStatusIV stopAnimating];
    }
}

@end
