//
//  MapAnnotationBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"
#import "LinesignModel.h"
#import "InterinfoModel.h"
#import "IntersignModel.h"
#import "TrackinfoModel.h"

@interface MapAnnotationBaseModel : BaseResponseModel

@property (nonatomic, nonnull, strong) NSArray *linesignModel;//走线标记 参考获取标记列表
@property (nonatomic, nonnull, strong) NSArray *intersignModel;//摄像头标记
@property (nonatomic, nonnull, strong) NSArray *interinfoModel;//快速记录
@property (nonatomic, nonnull, strong) NSArray *trackinfoModel;//快速记录
/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;
@end
