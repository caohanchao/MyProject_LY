//
//  XMChatBar.h
//  XMChatBarExample
//
//  Created by shscce on 15/8/17.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#define kMaxHeight 60.0f
#define kMinHeight 45.0f
#define kFunctionViewHeight 210.0f

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CJFileObjModel.h"

@class ZMLPlaceholderTextView;
/**
 *  functionView 类型
 */
typedef NS_ENUM(NSUInteger, XMFunctionViewShowType){
    XMFunctionViewShowNothing /**< 不显示functionView */,
    XMFunctionViewShowFace /**< 显示表情View */,
    XMFunctionViewShowVoice /**< 显示录音view */,
    XMFunctionViewShowMore /**< 显示更多view */,
    XMFunctionViewShowKeyboard /**< 显示键盘 */,
    XMFunctionViewCloseRead /**< 关闭阅后即焚 */,
};

typedef NS_ENUM(NSUInteger, ChatBarShowType){
    ChatBarShowNomalSingel /**< 个人聊天 */,
    ChatBarShowNomalGroup/**< 一般群*/,
    ChatBarShowMapGroup /**< 地图侦查群*/,
};

typedef NS_ENUM(NSUInteger, ChatFireMessageType){
    messageUNLock /**<阅后即焚已读*/,
    messageLock /**< 阅后即焚消息*/,
    messageRead /**<阅后即焚已读*/,
    messageUnknow /**<未知消息*/,
};

@protocol XMChatBarDelegate;

/**
 *  仿微信信息输入框,支持语音,文字,表情,选择照片,拍照
 */
@interface XMChatBar : UIView

@property (strong, nonatomic) ZMLPlaceholderTextView *textView;
@property (weak, nonatomic) id<XMChatBarDelegate> delegate;
@property (nonatomic, assign) CGFloat winHeight;

//显示类型
@property (nonatomic) ChatBarShowType chatBarType;

@property (nonatomic,copy) NSMutableDictionary *paramData;

//是否为阅后即焚消息
@property (nonatomic,assign) ChatFireMessageType fireMessageType;

/*
 *  结束输入状态
 */
- (void)endInputing;

@end

/**
 *  XMChatBar代理事件,发送图片,地理位置,文字,语音信息等
 */
@protocol XMChatBarDelegate <NSObject>


@optional

/**
 *  chatBarFrame改变回调
 *
 *  @param chatBar 
 */
- (void)chatBarFrameDidChange:(XMChatBar *)chatBar frame:(CGRect)frame;


/**
 *  发送图片信息,支持多张图片
 *
 *  @param chatBar
 *  @param pictures 需要发送的图片信息
 */
- (void)chatBar:(XMChatBar *)chatBar sendPictures:(NSArray *)pictures withType:(ChatFireMessageType)messageType;

/**
 *  发送地理位置信息
 *
 *  @param chatBar
 *  @param locationCoordinate 需要发送的地址位置经纬度
 *  @param locationText       需要发送的地址位置对应信息
 */
- (void)chatBar:(XMChatBar *)chatBar sendLocation:(NSString *)location locationText:(NSString *)locationText;

/**
 *  发送普通的文字信息,可能带有表情
 *
 *  @param chatBar
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(XMChatBar *)chatBar sendMessage:(NSString *)message withType:(ChatFireMessageType)messageType;

/**
 *  发送语音信息
 *
 *  @param chatBar
 *  @param voiceData 语音data数据
 *  @param seconds   语音时长
 */
- (void)chatBar:(XMChatBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds withType:(ChatFireMessageType)messageType;

/**
 *  发送视频信息
 *
 *  @param chatBar
 *  @param assetURL 需要发送的视频地址
 */
- (void)chatBar:(XMChatBar *)chatBar sendVideo:(NSURL *)assetURL;

/**
 *  发送文件信息
 *
 *  @param chatBar
 *  @param assetURL 需要发送的视频地址
 */
- (void)chatBar:(XMChatBar *)chatBar sendfile:(NSString *)fileURL withName:(NSString *)fileName withSize:(NSString *)fileSize orAsset:(PHAsset *)asset;


- (void)chatBar:(XMChatBar *)chatBar sendfile:(CJFileObjModel *)fileModel;

/**
 *  将聊天信息滑动至最底部
 *
 *  @param chatBar
 *  @param animated 是否开启动画
 */
- (void)chatBar:(XMChatBar *)chatBar scrollBottom:(BOOL)animated;
/**
 *  当输入@时候的回调
 *
 *  @param chatBar 当输入@时候的回调
 */
- (void)chatBarForAt:(XMChatBar *)chatBar;



@end
