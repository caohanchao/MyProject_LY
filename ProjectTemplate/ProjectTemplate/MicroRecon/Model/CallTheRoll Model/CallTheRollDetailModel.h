//
//  CallTheRollDetailModel.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CallTheRollListDetailModel;
@class CallTheRollListUserListDetailModel;

@interface CallTheRollDetailModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy)NSArray *rallcallend;//点名关闭
@property (nonatomic,nonnull,copy)NSArray *rallcalled; //待点名
@property (nonatomic,nonnull,copy)NSArray *rallcalling;//点名中
@property (nonatomic,nonnull,copy)NSArray *rallcallfinish;//点名完成

@end

@interface CallTheRollListDetailModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy)NSString *active_state;
@property (nonatomic,nonnull,copy)NSString *self_state;
@property (nonatomic,nonnull,copy)NSString *sign_state;
@property (nonatomic,nonnull,copy)NSString *title;
@property (nonatomic,nonnull,copy)NSString *publish_head_pic;   //发布者头像
@property (nonatomic,nonnull,copy)NSString *latitude;
@property (nonatomic,nonnull,copy)NSString *reportNum;
@property (nonatomic,nonnull,copy)NSString *publish_name;
@property (nonatomic,nonnull,copy)NSString *countdown;
@property (nonatomic,nonnull,copy)NSString *publish_alarm; //
@property (nonatomic,nonnull,copy)NSString *week;
@property (nonatomic,nonnull,copy)NSString *rallcallid;
@property (nonatomic,nonnull,copy)NSString *userAllNum;
@property (nonatomic,nonnull,copy)NSString *create_time;
@property (nonatomic,nonnull,copy)NSString *workid;
@property (nonatomic,nonnull,copy)NSString *isrepeat;
@property (nonatomic,nonnull,copy)NSString *start_time;
@property (nonatomic,nonnull,copy)NSString *end_time;
@property (nonatomic,nonnull,copy)NSString *keeptime;
@property (nonatomic,nonnull,copy)NSArray *userlist;

@end

@interface CallTheRollListUserListDetailModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,nonnull,copy)NSString *report_name;
@property(nonatomic,nonnull,copy)NSString *report_alarm;
@property(nonatomic,nonnull,copy)NSString *self_state;

@end


