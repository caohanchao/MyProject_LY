//
//  XMNChatController.h
//  XMChatBarExample
//
//  Created by shscce on 15/11/20.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMNChat.h"
#import "XMNChatViewModel.h"
@class ChatTableView;
typedef enum : NSUInteger {
    ChatList,
    GroupTeam,
    SearchC
} COMETYPE;

//typedef NS_ENUM(NSUInteger, ChatSendMessageType){
//    sendMessageLock /**< 阅后即焚消息*/,
//    sendMessageRead /**<阅后即焚已读*/,
//    sendMessageUNLock /**<阅后即焚已读*/,
//};

@interface XMNChatController : UIViewController

@property (strong, nonatomic) ChatTableView *tableView;
@property (strong, nonatomic) XMChatBar *chatBar;
@property (copy, nonatomic) NSString *chatterName /**< 正在聊天的用户昵称 */;
@property (copy, nonatomic) NSString *chatterThumb /**< 正在聊天的用户头像 */;
@property (nonatomic, strong) XMNChatViewModel *chatViewModel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) COMETYPE cType;//区分来自哪个界面

@property (nonatomic,copy)NSString *beginTime;

//是否为阅后即焚消息
@property (nonatomic) ChatFireMessageType fireMessageType;

- (instancetype)initWithChatType:(XMNMessageChat)messageChatType;
# pragma to_do
-(void)loadNewData;
@end
