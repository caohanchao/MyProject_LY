//
//  ChatView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "ChatMapViewController.h"

#define HeightC [UIScreen mainScreen].bounds.size.height*0.3


typedef enum : NSUInteger {
    ONLINEHAVEPOST,//在线有位置信息
    NOTONLINE,//不在线
    ONLINENOTHAVEPOSI//在线没位置信息
} ONLINESTATUS;


@interface ChatView : UIView
@property (nonatomic, strong) NSMutableArray *groupMemberArray;
@property (nonatomic, strong) ChatViewController *chatController;
@property (nonatomic, copy) NSString *chatterName;
@property (nonatomic, weak) UIVisualEffectView * effectView;
@property (nonatomic, assign) NSInteger type; //1.消息列表 2.组队列表
- (void)reload:(NSArray *)memberArray;
- (instancetype)initWithFrame:(CGRect)frame  ChatType:(XMNMessageChat)messageChatType chatname:(NSString *) chatName type:(NSInteger)type;
@end
