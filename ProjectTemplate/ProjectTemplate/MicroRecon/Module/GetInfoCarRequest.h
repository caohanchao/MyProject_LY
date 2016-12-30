//
//  GetInfoCarRequest.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  数据请求和处理类

#import <Foundation/Foundation.h>
#import "VdResultModel.h"
@interface GetInfoCarRequest : NSObject

+ (nonnull NSString *)removeSpaceAndNewline:(nonnull NSString *)str;

/**
 请求车侦数据
 
 @param info 传值: 起始时间 , 终止时间 ,车辆号牌
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)getCarIntoWithDict:(nonnull NSDictionary *)info success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 将model转换成数组

 @param model VdResultModel模型
 @return 返回的数组是详情页面所需的
 */
+ (nonnull NSArray *)configurationCellWithModel:(nonnull VdResultModel *)model;



/**
 将 (年 月 日 小时 分 秒) 转换成 (年 月 日)

 @param time(年 月 日 小时 分 秒)
 @return  时间 (年 月 日)
 */
+ (nonnull NSString *)cutTimeForHourMinment:(nonnull NSString *)time;


/**
 判断两时间是否在一周内

 @param startTime 开始时间
 @param endTime 结束时间
 @param formatter 传入formatter
 @return YES or NO   YES:大于一周   NO:小于一周
 */
+ (BOOL)isInOneWeekCompareWithStartTime:(nonnull NSString *)startTime WithEndTime:(nonnull NSString *)endTime Formatter:(nonnull NSDateFormatter *)formatter ;

@end
