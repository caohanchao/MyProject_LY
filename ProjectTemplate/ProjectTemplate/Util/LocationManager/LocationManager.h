//
//  LocationManager.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>



@interface LocationManager : NSObject

@property (nonatomic,copy) void(^locationCompleteBlock)(CLLocation *location);


@property (assign, nonatomic) CLLocationDegrees longitude; /**< 经度 */
@property (assign, nonatomic) CLLocationDegrees latitude; /**< 纬度 */

@property (nonatomic, assign) BOOL pausesLocationUpdatesAutomatically; //设置不允许系统暂停定位
@property (nonatomic, assign) BOOL allowsBackgroundLocationUpdates;  //设置允许在后台定位

+ (instancetype)shareManager;
- (void)startLocation;
- (void)stopLocation;
@end
