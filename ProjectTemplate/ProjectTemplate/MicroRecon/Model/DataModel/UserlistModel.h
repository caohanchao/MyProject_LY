//
//  UserlistModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  消息列表Model

#import <Foundation/Foundation.h>

@interface UserlistModel : NSObject

@property (nonatomic, assign) NSInteger ut_id;
@property (nonatomic, nonnull, copy) NSString *ut_cmd; //操作类型
@property (nonatomic, nonnull, copy) NSString *ut_sendid; //发送者id
@property (nonatomic, nonnull, copy) NSString *ut_alarm; //对方id或群id
@property (nonatomic, nonnull, copy) NSString *ut_headpic; //发送者
@property (nonatomic, nonnull, copy) NSString *ut_name; //对方姓名
@property (nonatomic, nonnull, copy) NSString *ut_fire; //阅后即焚标识
@property (nonatomic, nonnull, copy) NSString *ut_mode; //
@property (nonatomic, nonnull, copy) NSString *ut_type; // s单聊,g群聊,b广播
@property (nonatomic, nonnull, copy) NSString *ut_mtype;
@property (nonatomic, nonnull, copy) NSString *ut_draft; //
@property (nonatomic, nonnull, copy) NSString *ut_message; //最后一条消息
@property (nonatomic, nonnull, copy) NSString *ut_time; //时间
@property (nonatomic, nonnull, copy) NSString *ut_newmsgcount;
@property (nonatomic, nonnull, copy) NSString *ut_ptime;

@end
