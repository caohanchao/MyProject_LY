//
//  CardCountInfoModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCountInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy) NSString *fansNum;
@property (nonatomic,nonnull,copy) NSString *focusNum;
@property (nonatomic, nonnull,copy) NSString *publicNum;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;
@end
