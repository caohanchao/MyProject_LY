//
//  GetPathModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface GetPathModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *alarm;
@property (nonatomic, nonnull, copy) NSString *end_latitude; // 结束纬度
@property (nonatomic, nonnull, copy) NSString *end_longitude;// 结束经度
@property (nonatomic, nonnull, copy) NSString *end_posi; // 结束 位置
@property (nonatomic, nonnull, copy) NSString *end_time; // 结束时间
@property (nonatomic, nonnull, copy) NSString *gid; // 群ID
@property (nonatomic, nonnull, copy) NSString *head_pic; // 头像
@property (nonatomic, nonnull, copy) NSString *name; // 姓名
@property (nonatomic, nonnull, copy) NSString *position; // 位置
@property (nonatomic, nonnull, copy) NSString *route_id; // ID
@property (nonatomic, nonnull, copy) NSString *route_title; // 标题
@property (nonatomic, nonnull, copy) NSString *start_latitude; // 开始纬度
@property (nonatomic, nonnull, copy) NSString *start_longitude; // 开始经度
@property (nonatomic, nonnull, copy) NSString *start_posi; // 开始位置
@property (nonatomic, nonnull, copy) NSString *start_time; // 开始时间
@property (nonatomic, nonnull, copy) NSString *task_id; // ID
@property (nonatomic, nonnull, copy) NSString *token;
@property (nonatomic, nonnull, copy) NSString *type; // 类型
@property (nonatomic, nonnull, copy) NSString *describetion; // 描述
@property (nonatomic, nonnull, strong) NSArray *location_list; // 位置列表
@property (nonatomic, assign) BOOL select; // 是否被选择

@property (nonatomic, nonnull, copy) NSString *cuid;
@property (nonatomic, nonnull, copy) NSString *createTime;
@end
