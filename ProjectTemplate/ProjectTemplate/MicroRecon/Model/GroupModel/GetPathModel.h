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
@property (nonatomic, nonnull, copy) NSString *end_latitude;
@property (nonatomic, nonnull, copy) NSString *end_longitude;
@property (nonatomic, nonnull, copy) NSString *end_posi;
@property (nonatomic, nonnull, copy) NSString *end_time;
@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *head_pic;
@property (nonatomic, nonnull, copy) NSString *name;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic, nonnull, copy) NSString *route_id;
@property (nonatomic, nonnull, copy) NSString *route_title;
@property (nonatomic, nonnull, copy) NSString *start_latitude;
@property (nonatomic, nonnull, copy) NSString *start_longitude;
@property (nonatomic, nonnull, copy) NSString *start_posi;
@property (nonatomic, nonnull, copy) NSString *start_time;
@property (nonatomic, nonnull, copy) NSString *task_id;
@property (nonatomic, nonnull, copy) NSString *token;
@property (nonatomic, nonnull, copy) NSString *type;
@property (nonatomic, nonnull, copy) NSString *describetion;
@property (nonatomic, nonnull, strong) NSArray *location_list;
@property (nonatomic, assign) BOOL select; // 是否被选择

@property (nonatomic, nonnull, copy) NSString *cuid;
@property (nonatomic, nonnull, copy) NSString *createTime;
@end
