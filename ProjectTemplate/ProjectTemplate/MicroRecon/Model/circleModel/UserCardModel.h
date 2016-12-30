//
//  UserCardModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCardModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, copy) NSNumber *isfocus;
@property (nonatomic, nonnull, copy) NSString *department;
@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic, nonnull, strong) NSDictionary *countInfo;
@property (nonatomic, nonnull, strong) NSArray *postInfo;
@property (nonatomic, nonnull, copy) NSString *name;
@property (nonatomic, nonnull, strong) NSNumber *honorNum;


/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;

@end
