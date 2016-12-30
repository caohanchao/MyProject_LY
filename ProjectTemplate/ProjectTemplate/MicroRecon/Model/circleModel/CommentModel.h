//
//  CommentModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy) NSString *alarm;
@property (nonatomic,nonnull,copy) NSString *commentid;
@property (nonatomic, nonnull,copy) NSString *postuser;
@property (nonatomic, nonnull, copy) NSString *content;
@property (nonatomic, nonnull,copy) NSString *department;
@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic,nonnull,  copy) NSString *mode;
@property (nonatomic, nonnull, strong) NSNumber *pushtime;
@property (nonatomic,nonnull, copy) NSString *name;
@property (nonatomic, nonnull, copy) NSString *postid;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
