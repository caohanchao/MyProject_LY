//
//  WorkAllTempModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GetrecordByGroupModel.h"
#import "ICometModel.h"

@interface WorkAllTempModel : MTLModel<MTLJSONSerializing>



@property (nonatomic, nonnull, copy) NSString *alarm;
@property (nonatomic, nonnull, copy) NSString *audio;
@property (nonatomic, nonnull, copy) NSString *content;
@property (nonatomic, nonnull, copy) NSString *create_time;
@property (nonatomic, nonnull, copy) NSString *department;
@property (nonatomic, nonnull, copy) NSString *direction;
@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic, nonnull, copy) NSString *interid;
@property (nonatomic, nonnull, copy) NSString *latitude;
@property (nonatomic, nonnull, copy) NSString *longitude;
@property (nonatomic, nonnull, copy) NSString *mode;//0 走访标记 1 快速记录 2 摄像头标记
@property (nonatomic, nonnull, copy) NSString *orderid;
@property (nonatomic, nonnull, copy) NSString *picture;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic, nonnull, copy) NSString *realname;


@property (nonatomic, nonnull, copy) NSString *title;

@property (nonatomic, nonnull, copy) NSString *type;//摄像头的类型 或走访的类型
@property (nonatomic, nonnull, copy) NSString *video;

@property (nonatomic, nonnull, copy) NSString *workId;
@property (nonatomic, nonnull, copy) NSString *cuid;

- (nonnull instancetype)initWithGetrecordByGroupModel:(nonnull GetrecordByGroupModel *)model;
- (nonnull instancetype)initWithICometModel:(nonnull ICometModel *)model;
@end
