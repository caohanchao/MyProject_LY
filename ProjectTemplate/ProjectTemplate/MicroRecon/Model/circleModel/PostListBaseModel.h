//
//  PostListBaseModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"

@interface PostListBaseModel : BaseResponseModel

@property (nonatomic, nonnull, strong) NSArray *results;

/**
 * 根据data获取 PostListResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;

@end
