//
//  UserChatModel.h
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "BaseResponseModel.h"

@class GPSModel;
@class  MSGModel;
@class SuspectSDataModel;
@class TaskFDataModel;
@class TaskNDataModel;
@class TaskTDataModel;

@interface UserChatModel :BaseResponseModel

@property (nonatomic, nonnull, strong) NSArray *results;

+ (nonnull instancetype) UserChatWithData:(nonnull NSData *)data;

@end


@interface chatModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,nonnull,copy)NSString *SID;
@property(nonatomic,nonnull,copy)NSString *RID;
@property(nonatomic,nonnull,copy)NSString *HEADPIC;
@property(nonatomic,nonnull,copy)NSString *TYPE;
@property(nonatomic,nonnull,copy)NSString *ATALARM;
@property(nonatomic,nonnull,copy)NSString *CMD;
@property(nonatomic,nonnull,copy)NSString *MSGID;
@property(nonatomic,nonnull,copy)NSString *TIME;
@property(nonatomic,nonnull,copy)NSString *SNAME;
@property(nonatomic,assign)NSInteger QID;
@property(nonatomic,nonnull,strong) GPSModel *GPS;
@property(nonatomic,nonnull,strong) MSGModel *MSG;
@property(nonatomic,nonnull,strong)NSString *beginTime;
//@property(nonatomic,nonnull,copy)NSString *FIRE;
@property(nonatomic,nonnull,copy)NSString *timeStr;
//@property (nonatomic, nonnull, copy) NSString *markdataId;//标记唯一标识

@end

@interface GPSModel : MTLModel<MTLJSONSerializing>
@property(nonatomic,nonnull,copy) NSString *H;
@property(nonatomic,nonnull,copy) NSString *W;
@end


@interface MSGModel : MTLModel<MTLJSONSerializing>
@property(nonatomic,nonnull,copy)NSString *DATA;
@property(nonatomic,nonnull,copy)NSString *VIDEOPIC;
@property(nonatomic,nonnull,copy)NSString *MTYPE;
@property(nonatomic,nonnull,copy)NSString *FIRE;
@property(nonatomic,nonnull,copy)NSString *VOICETIME;



@property (nonatomic, nonnull, strong) SuspectSDataModel *suspectSDataModel;
@property (nonatomic, nonnull, strong) TaskNDataModel *taskNDataModel;//添加纪录通知
@property (nonatomic, nonnull, strong) TaskTDataModel *taskTDataModel;//添加轨迹通知
@property (nonatomic, nonnull, strong) TaskFDataModel *taskFDataModel;//任务结束通知

@end
