//
//  CallTheRollDeatilModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CallTheRollDeatilModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *active_state;
@property (nonatomic, nonnull, copy) NSString *create_time;
@property (nonatomic, nonnull, copy) NSString *end_time;
@property (nonatomic, nonnull, copy) NSString *isrepeat;
@property (nonatomic, nonnull, copy) NSString *keeptime;
@property (nonatomic, nonnull, copy) NSString *latitude;
@property (nonatomic, nonnull, copy) NSString *longitude;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic, nonnull, copy) NSString *ptime;
@property (nonatomic, nonnull, copy) NSString *publish_alarm;
@property (nonatomic, nonnull, copy) NSString *publish_head_pic;
@property (nonatomic, nonnull, copy) NSString *publish_name;
@property (nonatomic, nonnull, copy) NSString *rallcallid;
@property (nonatomic, nonnull, copy) NSString *sign_state;
@property (nonatomic, nonnull, copy) NSString *start_time;
@property (nonatomic, nonnull, copy) NSString *title;
@property (nonatomic, nonnull, copy) NSString *userAllNum;
@property (nonatomic, nonnull, copy) NSString *userlatitude;
@property (nonatomic, nonnull, strong) NSArray *userlist;
@property (nonatomic, nonnull, copy) NSString *userlongitude;
@property (nonatomic, nonnull, copy) NSString *week;
@property (nonatomic, nonnull, copy) NSString *workid;


@end


@interface CallTheRollUserListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, copy) NSString *department;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic, nonnull, copy) NSString *report_alarm;
@property (nonatomic, nonnull, copy) NSString *report_headpic;
@property (nonatomic, nonnull, copy) NSString *report_name;
@property (nonatomic, nonnull, copy) NSString *report_time;
@property (nonatomic, nonnull, copy) NSString *self_state;
@property (nonatomic, nonnull, copy) NSString *usergpsh;
@property (nonatomic, nonnull, copy) NSString *usergpsw;

@property (nonatomic, nonnull, copy) NSString *alarm;
@property (nonatomic, nonnull, copy) NSString *ptime;

@end
