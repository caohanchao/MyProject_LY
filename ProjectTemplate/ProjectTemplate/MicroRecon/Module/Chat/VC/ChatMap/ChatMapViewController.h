//
//  ChatMapViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseViewController.h"
@class ChatView;

@interface ChatMapViewController : BaseViewController


@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) ChatView *chatView;
@property (nonatomic, copy) NSString *chatterName;
@property (nonatomic, assign) NSInteger type; //1.消息列表 2.组队列表 3.搜索

- (instancetype)initWithChatType:(XMNMessageChat)messageChatType chatname:(NSString *) chatName type:(NSInteger)type;

@end
