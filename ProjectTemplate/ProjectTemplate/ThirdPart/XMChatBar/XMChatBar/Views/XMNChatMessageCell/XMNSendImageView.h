//
//  XMNSendImageView.h
//  XMChatBarExample
//
//  Created by shscce on 15/11/23.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMNChatUntiles.h"

typedef void (^RestartSendBlock)(void);

@interface XMNSendImageView : UIImageView

@property (nonatomic, assign) XMNMessageSendState messageSendState;

@property (nonatomic, copy)RestartSendBlock restartSendBlock;
@end
