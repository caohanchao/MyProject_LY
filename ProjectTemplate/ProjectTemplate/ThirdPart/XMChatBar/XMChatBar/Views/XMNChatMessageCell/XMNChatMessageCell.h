//
//  XMNChatMessageCell.h
//  XMNChatExample
//  XMNChatMessageCell 是所有XMNChatCell的父类
//  提供了delegate,messageOwner,messageType属性
//  Created by shscce on 15/11/13.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMNSendImageView.h"
#import "XMNContentView.h"
#import "XMNChatUntiles.h"

@class XMNChatMessageCell;
@class ZMLPlaceholderTextView;


@protocol XMNChatMessageCellDelegate <NSObject>

- (void)messageCellFailState:(XMNChatMessageCell *)messageCell;
- (void)messageCellTappedBlank:(XMNChatMessageCell *)messageCell;
- (void)messageCellTappedHead:(XMNChatMessageCell *)messageCell;
- (void)messageCellTappedMessage:(XMNChatMessageCell *)messageCell;
- (void)messageCellDoubleTappedMessage:(XMNChatMessageCell *)messageCell;
- (void)messageCell:(XMNChatMessageCell *)messageCell withActionType:(XMNChatMessageCellMenuActionType)actionType textField:(NSString *)textField;
@end


@interface XMNChatMessageCell : UITableViewCell

/**
 *  显示用户头像的UIImageView
 */
@property (nonatomic, strong) UIImageView *headIV;

/**
 *  显示用户昵称的UILabel
 */
@property (nonatomic, strong) UILabel *nicknameL;
/**
 *  职位
 */
@property (nonatomic, strong) UILabel *postnameL;

/**
 * 显示时间
 */
@property (nonatomic, strong) UILabel *timeL;

/**
 *  显示用户消息主体的View,所有的消息用到的textView,imageView都会被添加到这个view中 -> XMNContentView 自带一个CAShapeLayer的蒙版
 */
@property (nonatomic, strong) XMNContentView *messageContentV;

/**
 *  显示消息阅读状态的UIImageView -> 主要用于VoiceMessage
 */
@property (nonatomic, strong) UIImageView *messageReadStateIV;

/**
 *  显示消息发送状态的UIImageView -> 用于消息发送不成功时显示
 */
@property (nonatomic, strong) XMNSendImageView *messageSendStateIV;

/**
 *  messageContentV的背景层
 */
@property (nonatomic, strong) UIImageView *messageContentBackgroundIV;


@property (nonatomic, weak) id<XMNChatMessageCellDelegate> delegate;

/**
 *  消息的类型,只读类型,会根据自己的具体实例类型进行判断
 */
@property (nonatomic, assign, readonly) XMNMessageType messageType;


/**
 *  阅后即焚的锁
 */
@property (nonatomic, strong) UIImageView *fireMessageLockVI;

/**
 *  阅后即焚点击查看T
 */
@property (nonatomic, strong) UIImageView *fireMessageTVI;

/**
 *  阅后即焚的倒计时
 */
@property (nonatomic, strong) UILabel *fireMessageTimeLabel;

//阅后即焚的状态类型
@property (nonatomic, assign) ChatFireMessageType fireMessageType;
@property (nonatomic, strong) NSString * fireType;

/**
 *  消息的所有者,只读类型,会根据自己的reuseIdentifier进行判断
 */
@property (nonatomic, assign, readonly) XMNMessageOwner messageOwner;

/**
 *  消息群组类型,只读类型,根据reuseIdentifier判断
 */
@property (nonatomic, assign) XMNMessageChat messageChatType;


/**
 *  消息发送状态,当状态为XMNMessageSendFail或XMNMessageSendStateSending时,XMNMessageSendStateIV显示
 */
@property (nonatomic, assign) XMNMessageSendState messageSendState;

/**
 *  消息阅读状态,当状态为XMNMessageUnRead时,XMNMessageReadStateIV显示
 */
@property (nonatomic, assign) XMNMessageReadState messageReadState;

/** 
    长按cell获取的第一响应者ZMLPlaceholderTextView
 */
@property (nonatomic, weak) ZMLPlaceholderTextView *zmlPlaceholderTextView;

#pragma mark - Public Methods

- (void)setup;
- (void)configureCellWithData:(id)data;

@end

@interface XMNChatMessageCell (XMNChatMessageCellMenuAction)


@property (nonatomic, strong, readonly) UIMenuController *menuController;



@end
