//
//  DisplayContentLogic.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/30.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayContentLogic : NSObject

+ (nonnull instancetype)sharedManager;


-(nonnull NSString *)displayContentLogicWithChatType:(nonnull NSString *)chatType withChatID: ( nonnull NSString *)chatId withMessageType:(XMNMessageType)mType  withData:(nonnull NSString *)data;

@end
