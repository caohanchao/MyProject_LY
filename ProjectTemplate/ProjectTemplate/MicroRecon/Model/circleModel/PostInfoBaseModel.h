//
//  PostInfoBaseModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostInfoBaseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy) NSString *alarm;
@property (nonatomic,nonnull,copy) NSString *comment;
@property (nonatomic, nonnull,copy) NSString *department;
@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic, nonnull,copy) NSString *ispraise;
@property (nonatomic, nonnull, copy) NSString *mode;
@property (nonatomic,nonnull,  copy) NSString *picture;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic,nonnull, copy) NSString *postid;
@property (nonatomic, nonnull, copy) NSString *posttype;
@property (nonatomic, nonnull, copy) NSString *praisenum;
@property (nonatomic, nonnull,strong) NSArray *praiseuser;
@property (nonatomic, nonnull,strong) NSArray *commentinfo;
@property (nonatomic, nonnull,copy) NSString *publishname;
@property (nonatomic, nonnull,strong) NSNumber* pushtime;
@property (nonatomic, nonnull, copy) NSString *text;
/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;

@end
