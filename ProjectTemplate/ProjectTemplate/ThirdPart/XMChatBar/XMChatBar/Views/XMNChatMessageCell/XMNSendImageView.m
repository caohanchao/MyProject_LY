//
//  XMNSendImageView.m
//  XMChatBarExample
//
//  Created by shscce on 15/11/23.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNSendImageView.h"

@interface XMNSendImageView ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic,weak) UIButton *pointBut;

@end

@implementation XMNSendImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.hidden =YES;
        [self addSubview:self.indicatorView = indicatorView];
        UIImage *image=[UIImage imageNamed:@"lose"];
        self.image=image;
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(restartSend)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


-(void)restartSend{
    
    self.restartSendBlock();

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorView.frame = self.bounds;
}

#pragma mark - Setters
- (void)setMessageSendState:(XMNMessageSendState)messageSendState {
    _messageSendState = messageSendState;
//    if (_messageSendState == XMNMessageSendStateSending) {
//        [self.indicatorView startAnimating];
//        self.indicatorView.hidden = NO;
//    }else {
//        [self.indicatorView stopAnimating];
//        self.indicatorView.hidden = YES;
//    }

    switch (_messageSendState) {
        case XMNMessageSendStateSending:
             [self.indicatorView startAnimating];
            self.hidden=YES;
            break;
        case XMNMessageSendSuccess:
             [self.indicatorView startAnimating];
            self.hidden=YES;
            break;
        case XMNMessageSendFail:
            self.indicatorView.hidden=YES;
            self.hidden =NO;
            break;
        default:
            self.hidden = YES;
            break;
    }
}

@end
