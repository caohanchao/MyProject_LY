//
//  PostInfoModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy) NSString *department;
@property (nonatomic, nonnull,copy) NSString *alarm;
@property (nonatomic, nonnull,copy) NSString *name;
@property (nonatomic, nonnull,copy) NSString *headpic;
@property (nonatomic, nonnull,copy) NSString* time;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
