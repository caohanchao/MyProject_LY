//
//  MessageResendSQ.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageResendSQ : NSObject

+ (instancetype)messageResendSQ;


// 插入一条的消息
- (BOOL)insertMessage:(ICometModel *)model;

// 根据qid查询消息
- (ICometModel *)selectMessageByCuid:(NSString *)cuid;

- (NSMutableArray *)selectMessage;

- (BOOL)deleteMessageByCuid:(NSString *)cuid;

@end
