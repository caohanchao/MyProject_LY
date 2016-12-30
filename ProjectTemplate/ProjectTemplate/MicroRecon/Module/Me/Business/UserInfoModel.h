//
//  UserInfoModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@class FriendsListModel;


@interface UserInfoModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *headpic; //用户头像URL
@property (nonatomic, nonnull, copy) NSString *name; //姓名
@property (nonatomic, nonnull, copy) NSString *sex; //性别
@property (nonatomic, nonnull, copy) NSString *age; //年龄
@property (nonatomic, nonnull, copy) NSString *post; //职务
@property (nonatomic, nonnull, copy) NSString *department; //单位
@property (nonatomic, nonnull, copy) NSString *alarm; //身份唯一标识
@property (nonatomic, nonnull, copy) NSString *phonenum; //电话号码
@property (nonatomic, nonnull, copy) NSString *identitycard; //身份证号
@property (nonatomic, nonnull, copy) NSString *useralarm; //警号

@property (nonatomic, nonnull, copy) NSString *soundSet;        //声音设置
@property (nonatomic, nonnull, copy) NSString *vibrateSet;      //振动设置
@property (nonatomic, nonnull, copy) NSString *locationSet;     //位置共享设置
@property (nonatomic, nonnull, copy) NSString *autoUploadSet;   //自动上传设置

- (nonnull instancetype)initWithFriendsListModel:(nonnull FriendsListModel *)model;

@end
