//
//  UserAllModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface UserAllModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *RE_alarmNum;
@property (nonatomic, nonnull, copy) NSString *RE_department;
@property (nonatomic, nonnull, copy) NSString *RE_headpic;
@property (nonatomic, nonnull, copy) NSString *RE_name;
@property (nonatomic, nonnull, copy) NSString *RE_nickname;
@property (nonatomic, nonnull, copy) NSString *RE_permission;
@property (nonatomic, nonnull, copy) NSString *RE_phonenum;
@property (nonatomic, nonnull, copy) NSString *RE_ptime;
@property (nonatomic, nonnull, copy) NSString *RE_post;
@property (nonatomic, nonnull, copy) NSString *RE_status;


@property (nonatomic, nonnull, copy) NSString *RE_useralarm;
;

@property (nonatomic, nonnull, copy) NSString *isSelect;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;


@end
