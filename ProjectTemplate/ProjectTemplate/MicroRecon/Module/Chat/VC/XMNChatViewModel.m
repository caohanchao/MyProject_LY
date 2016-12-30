//
//  XMNChatViewModel.m
//  XMNChatExample
//
//  Created by shscce on 15/11/18.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatViewModel.h"

#import "XMNChatTextMessageCell.h"
#import "XMNChatImageMessageCell.h"
#import "XMNChatVoiceMessageCell.h"
#import "XMNChatSystemMessageCell.h"
#import "XMNChatLocationMessageCell.h"

#import "XMNAVAudioPlayer.h"
#import "XMNChatMessageServer.h"
#import "XMNMessageStateManager.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "XMNChatMessageCell+XMNCellIdentifier.h"

@interface XMNChatViewModel () <XMNChatServerDelegate>

@property (nonatomic, weak) UIViewController<XMNChatMessageCellDelegate> *parentVC;
@property (nonatomic, strong) id<XMNChatServer> chatServer;

@end

@implementation XMNChatViewModel

- (instancetype)initWithParentVC:(UIViewController<XMNChatMessageCellDelegate> *)parentVC {
    self = [super init];
    if (self) {
//        _dataArray = [NSMutableArray array];
        _parentVC = parentVC;
        _chatServer = [[XMNChatMessageServer alloc] init];
        _chatServer.delegate = self;
    }
    return self;
}

- (void)dealloc {
    
    [[XMNMessageStateManager shareManager] cleanState];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *message = self.dataArray[indexPath.row];
    NSString *identifier = [XMNChatMessageCell cellIdentifierForMessageConfiguration:@{kXMNMessageConfigurationGroupKey:message[kXMNMessageConfigurationGroupKey],kXMNMessageConfigurationOwnerKey:message[kXMNMessageConfigurationOwnerKey],kXMNMessageConfigurationTypeKey:message[kXMNMessageConfigurationTypeKey]}];
    
    XMNChatMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [messageCell configureCellWithData:message];
    messageCell.messageReadState = [[XMNMessageStateManager shareManager] messageReadStateForIndex:indexPath.row];
    messageCell.messageSendState = [[XMNMessageStateManager shareManager] messageSendStateForIndex:indexPath.row];
    messageCell.delegate = self.parentVC;
    
    if ([message[kXMNMessageConfigurationSendStateKey] integerValue] == XMNMessageSendFail) {
        messageCell.messageSendState = XMNMessageSendFail;
    }
//    else {
//        messageCell.messageSendState = XMNMessageSendSuccess;
//    }
//    
    return messageCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *message = self.dataArray[indexPath.row];
    NSString *identifier = [XMNChatMessageCell cellIdentifierForMessageConfiguration:@{kXMNMessageConfigurationGroupKey:message[kXMNMessageConfigurationGroupKey],kXMNMessageConfigurationOwnerKey:message[kXMNMessageConfigurationOwnerKey],kXMNMessageConfigurationTypeKey:message[kXMNMessageConfigurationTypeKey]}];
    
    if ([message[kXMNMessageConfigurationFireKey] isEqualToString:@"READ"]) {
        return 0.1;
    }
    else
    {
        if(identifier){
            return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(XMNChatMessageCell *cell) {
                [cell configureCellWithData:message];
            }];
        }else{
            return 0;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    //设置正确的voiceMessageCell播放状态
    NSDictionary *message = self.dataArray[indexPath.row];
    if ([message[kXMNMessageConfigurationTypeKey] integerValue] == XMNMessageTypeVoice) {
        if (indexPath.row == [[XMNAVAudioPlayer sharePlayer] index]) {
            [(XMNChatVoiceMessageCell *)cell setVoiceMessageState:[[XMNAVAudioPlayer sharePlayer] audioPlayerState]];
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.chatBar endInputing];
    if ([UIMenuController sharedMenuController].isMenuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
}

#pragma mark - XMNChatServerDelegate

- (void)recieveMessage:(NSDictionary *)message {
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionaryWithDictionary:message];
    [self addMessage:messageDict];
    [self.delegate reloadAfterReceiveMessage:messageDict];
}

#pragma mark - Public Methods

- (void)addMessage:(NSDictionary *)message {
    [self.dataArray addObject:message];

}

- (void)sendMessage:(NSDictionary *)message{
    
    __weak __typeof(&*self) wself = self;
    [[XMNMessageStateManager shareManager] setMessageSendState:XMNMessageSendStateSending forIndex:[self.dataArray indexOfObject:message]];
    
    [self.delegate messageSendStateChanged:XMNMessageSendStateSending withProgress:0.0f forIndex:[self.dataArray indexOfObject:message]];
    
    [self.chatServer sendMessage:message withProgressBlock:^(CGFloat progress) {
        __strong __typeof(wself)self = wself;
        [self.delegate messageSendStateChanged:XMNMessageSendStateSending withProgress:progress forIndex:[self.dataArray indexOfObject:message]];
    } completeBlock:^(XMNMessageSendState sendState) {
        __strong __typeof(wself)self = wself;
        [[XMNMessageStateManager shareManager] setMessageSendState:sendState forIndex:[self.dataArray indexOfObject:message]];
        [self.delegate messageSendStateChanged:sendState withProgress:1.0f forIndex:[self.dataArray indexOfObject:message]];
        
    }];
}

//- (void)sendMessageOfFailMessage:(NSDictionary *)message {
//    __weak __typeof(&*self) wself = self;
//    [[XMNMessageStateManager shareManager] setMessageSendState:XMNMessageSendStateSending forIndex:[self.dataArray indexOfObject:message]];
//    
//    [self.delegate messageSendStateChanged:XMNMessageSendStateSending withProgress:0.0f forIndex:[self.dataArray indexOfObject:message]];
//    
//    [self.chatServer sendMessage:message withProgressBlock:^(CGFloat progress) {
//        __strong __typeof(wself)self = wself;
//        [self.delegate messageSendStateChanged:XMNMessageSendStateSending withProgress:progress forIndex:[self.dataArray indexOfObject:message]];
//    } completeBlock:^(XMNMessageSendState sendState) {
//        __strong __typeof(wself)self = wself;
//        [[XMNMessageStateManager shareManager] setMessageSendState:sendState forIndex:[self.dataArray indexOfObject:message]];
//        [self.delegate messageSendStateChanged:sendState withProgress:1.0f forIndex:[self.dataArray indexOfObject:message]];
//    }];
//}

- (void)removeMessageAtIndex:(NSUInteger)index {
    if (index < self.dataArray.count) {
        [self.dataArray removeObjectAtIndex:index];
    }
}

- (NSDictionary *)messageAtIndex:(NSUInteger)index {
    if (index < self.dataArray.count) {
        return self.dataArray[index];
    }
    return nil;
}


#pragma mark - Setters

- (void)setChatServer:(id<XMNChatServer>)chatServer {
    if (_chatServer == chatServer) {
        return;
    }
    _chatServer = chatServer;

}

#pragma mark - Getters

- (NSUInteger)messageCount {
    return self.dataArray.count;
}

@end
