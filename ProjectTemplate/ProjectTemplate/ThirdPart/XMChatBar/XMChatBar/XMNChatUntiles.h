//
//  XMNChatUntiles.h
//  XMNChatExample
//
//  Created by shscce on 15/11/16.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#ifndef XMNChatUntiles_h
#define XMNChatUntiles_h


/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, XMNMessageOwner){
    XMNMessageOwnerUnknown = 0 /**< 未知的消息拥有者 */,
    XMNMessageOwnerSystem /**< 系统消息 */,
    XMNMessageOwnerSelf /**< 自己发送的消息 */,
    XMNMessageOwnerOther /**< 接收到的他人消息 */,
};


/**
 *  消息聊天类型
 */
typedef NS_ENUM(NSUInteger, XMNMessageChat){
    XMNMessageChatSingle = 0 /**< 单人聊天,不显示nickname */,
    XMNMessageChatGroup /**< 群组聊天,显示nickname */,
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, XMNMessageType){
    XMNMessageTypeUnknow = 0 /**< 未知的消息类型 */,
    XMNMessageTypeSystem /**< 系统消息 */,
    XMNMessageTypeText /**< 文本消息 */,
    XMNMessageTypeImage /**< 图片消息 */,
    XMNMessageTypeVoice /**< 语音消息 */,
    XMNMessageTypeLocation /**< 地理位置消息 */,
    XMNMessageTypeVideo /**< 视频消息 */,
    XMNMessageTypeReleaseTask /**< 发布任务 */,
};

/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, XMNMessageSendState){
    XMNMessageSendSuccess = 0 /**< 消息发送成功 */,
    XMNMessageSendStateSending, /**< 消息发送中 */
    XMNMessageSendFail /**< 消息发送失败 */,
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, XMNMessageReadState) {
    XMNMessageUnRead = 0 /**< 消息未读 */,
    XMNMessageReading /**< 正在接收 */,
    XMNMessageReaded /**< 消息已读 */,
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, XMNVoiceMessageState){
    XMNVoiceMessageStateNormal,/**< 未播放状态 */
    XMNVoiceMessageStateDownloading,/**< 正在下载中 */
    XMNVoiceMessageStatePlaying,/**< 正在播放 */
    XMNVoiceMessageStateCancel,/**< 播放被取消 */
};


/**
 *  XMNChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, XMNChatMessageCellMenuActionType) {
    XMNChatMessageCellMenuActionTypeCopy, /**< 复制 */
    XMNChatMessageCellMenuActionTypeRelay, /**< 转发 */
    XMNChatMessageCellMenuActionTypeWithdraw, /**< 撤回 */
};


#pragma mark - XMNMessage 相关key值定义

/**
 *  消息类型的key
 */
static NSString *const kXMNMessageConfigurationTypeKey = @"com.XMFraker.kXMNMessageConfigurationTypeKey";
/**
 *  消息拥有者的key
 */
static NSString *const kXMNMessageConfigurationOwnerKey = @"com.XMFraker.kXMNMessageConfigurationOwnerKey";

/**
 *  消息拥有者警号的key
 */
static NSString *const kXMNMessageConfigurationAlarmKey = @"com.XMFraker.kXMNMessageConfigurationAlarmKey";
/**
 *  消息群组类型的key
 */
static NSString *const kXMNMessageConfigurationGroupKey = @"com.XMFraker.kXMNMessageConfigurationGroupKey";

/**
 *  消息昵称类型的key
 */
static NSString *const kXMNMessageConfigurationNicknameKey = @"com.XMFraker.kXMNMessageConfigurationNicknameKey";

/**
 *  消息时间类型的key
 */
static NSString *const kXMNMessageConfigurationTimeKey = @"com.XMFraker.kXMNMessageConfigurationTimeKey";

/**
 *  消息时间范围的key
 */
static NSString *const kXMNMessageConfigurationTimeScopeKey = @"com.XMFraker.kXMNMessageConfigurationTimeScopeKey";

/**
 *  消息的显示时间的key
 */
static NSString *const kXMNMessageConfigurationBeginTimeKey = @"com.XMFraker.kXMNMessageConfigurationBeginTimeKey";

/**
 *  消息头像类型的key
 */
static NSString *const kXMNMessageConfigurationAvatarKey = @"com.XMFraker.kXMNMessageConfigurationAvatarKey";

/**
 *  消息阅读状态类型的key
 */
static NSString *const kXMNMessageConfigurationReadStateKey = @"com.XMFraker.kXMNMessageConfigurationReadStateKey";

/**
 *  消息发送状态类型的key
 */
static NSString *const kXMNMessageConfigurationSendStateKey = @"com.XMFraker.kXMNMessageConfigurationSendStateKey";

/**
 *  文本消息内容的key
 */
static NSString *const kXMNMessageConfigurationTextKey = @"com.XMFraker.kXMNMessageConfigurationTextKey";

/**
 *  图片消息内容的key
 */
static NSString *const kXMNMessageConfigurationImageKey = @"com.XMFraker.kXMNMessageConfigurationImageKey";
/**
 *  语音消息内容的key
 */
static NSString *const kXMNMessageConfigurationVoiceKey = @"com.XMFraker.kXMNMessageConfigurationVoiceKey";
/**
 *  视频消息内容的key
 */
static NSString *const kXMNMessageConfigurationVideoKey = @"com.XMFraker.kXMNMessageConfigurationVideoKey";

/**
 *  语音消息时长key
 */
static NSString *const kXMNMessageConfigurationVoiceSecondsKey = @"com.XMFraker.kXMNMessageConfigurationVoiceSecondsKey";

/**
 *  地理位置消息内容的key
 */
static NSString *const kXMNMessageConfigurationLocationKey = @"com.XMFraker.kXMNMessageConfigurationLocationKey";
/**
 *  任务的名字的key
 */
static NSString *const kXMNMessageConfigurationWorkNameKey = @"com.XMFraker.kXMNMessageConfigurationWorkNameKey";
/**
 *  消息体的cuid
 */
static NSString *const kXMNMessageConfigurationCUIDKey = @"com.XMFraker.kXMNMessageConfigurationCUIDKey";

/**
 *  消息体的qid
 */
static NSString *const kXMNMessageConfigurationQIDKey = @"com.XMFraker.kXMNMessageConfigurationQIDKey";
/**
 *  用户组织类型0或1
 */
static NSString *const kXMNMessageConfigurationDETypeKey = @"com.XMFraker.kXMNMessageConfigurationDETypeKey";
/**
 *  用户组织名称
 */
static NSString *const kXMNMessageConfigurationDENameKey = @"com.XMFraker.kXMNMessageConfigurationDENameKey";
/**
 *  是否为阅后即焚
 */
static NSString *const kXMNMessageConfigurationFireKey = @"com.XMFraker.kXMNMessageConfigurationFireKey";

/**
 *  是否存在倒计时
 */
static NSString *const kXMNMessageConfigurationTimerStrKey = @"com.XMFraker.kXMNMessageConfigurationTimerStrKey";
/**
 *  消息状态的key
 */
//static NSString *const kXMNMessageConfigurationStateKey = @"com.XMFraker.kXMNMessageConfigurationStateKey";
#endif /* XMNChatUntiles_h */
