//
//  ICometModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "SuspectSDataModel.h"
#import "TaskNDataModel.h"//添加纪录通知
#import "TaskTDataModel.h"//添加轨迹通知
#import "TaskFDataModel.h"//任务结束通知

@interface ICometModel : MTLModel<MTLJSONSerializing>
// {"type":"data","cname":"01029","seq":79,"content":"{\"SID\":\"01004\",\"RID\":\"01029\",\"HEADPIC\":\"http:\\/\\/220.249.118.115:13201\\/tax00\\/M00\\/00\\/09\\/QUIPAFd7F82AB_qCAAGiaqLUTE0042.jpg\",\"TYPE\":\"S\",\"CMD\":\"1\",\"TIME\":\"2016-07-18 15:17:00\",\"SNAME\":\"郑胜\",\"GPS\":{\"W\":\"-1.0\",\"H\":\"-1.0\"},\"QID\":\"469\",\"MSG\":{\"MTYPE\":\"T\",\"DATA\":\"啪啪啪\",\"VIDEOPIC\":\"null\",\"VOICETIME\":\"null\"}}"}
@property (nonatomic, nonnull, copy) NSString *sid; // 发送人警号
@property (nonatomic, nonnull, copy) NSString *rid; // 接受人警号
@property (nonatomic, nonnull, copy) NSString *headpic; // 头像
@property (nonatomic, nonnull, copy) NSString *sname; // 发送人姓名
@property (nonatomic, nonnull, copy) NSString *cname; // 发送人姓名
@property (nonatomic, nonnull, copy) NSString *myType; // 该条model的类型
@property (nonatomic, nonnull, copy) NSString *msGid; // 消息唯一id
@property (nonatomic, assign) NSInteger qid;
@property (nonatomic, assign) NSInteger seq;
@property (nonatomic, nonnull, copy) NSString *time;
@property (nonatomic, nonnull, copy) NSString *mtype;
@property (nonatomic, nonnull, copy) NSString *type;
@property (nonatomic, nonnull, copy) NSString *cmd;
@property (nonatomic, nonnull, copy) NSString *latitude; // 纬度
@property (nonatomic, nonnull, copy) NSString *longitude; // 经度
@property (nonatomic, nonnull, copy) NSString *data; // 消息内容
@property (nonatomic, nonnull, copy) NSString *videopic;
@property (nonatomic, nonnull, copy) NSString *voicetime;

@property (nonatomic, nonnull, copy) NSString *beginTime;

@property (nonatomic, nonnull, copy) NSString *workname;
@property (nonatomic, nonnull, copy) NSString *worId;
@property (nonatomic, nonnull, copy) NSString *markdataId;//标记唯一标识

@property (nonatomic, nonnull, strong) SuspectSDataModel *suspectSDataModel;
@property (nonatomic, nonnull, strong) TaskNDataModel *taskNDataModel;//添加纪录通知
@property (nonatomic, nonnull, strong) TaskTDataModel *taskTDataModel;//添加轨迹通知
@property (nonatomic, nonnull, strong) TaskFDataModel *taskFDataModel;//任务结束通知

@property (nonatomic, nonnull, copy) NSString *atAlarm;//@人传递的警号用于识别
@property (nonatomic, nonnull, copy) NSString *cuid;//传消息的唯一id
@property (nonatomic, nonnull, copy) NSString *DE_type;//组织类型
@property (nonatomic, nonnull, copy) NSString *DE_name;//组织名称

@property(nonatomic,nonnull,copy)NSString *FIRE;//阅后即焚
@property (nonatomic, nonnull, copy) NSString *messageState;//消息状态

@property(nonatomic,nonnull,copy)NSString *timeStr;

@property(nonatomic,nonnull,copy)   NSString *messageNotShow; // 消息不显示在列表 默认显示 @"NO"

/**
 * 根据字节数组获取 ICometModel 对象
 */
+ (nonnull instancetype) iCometModelWithBytes:(nonnull const void *)cst length:(NSUInteger) length;

- (BOOL) isUpdateOnChatList:(nonnull ICometModel *) model;

@end
