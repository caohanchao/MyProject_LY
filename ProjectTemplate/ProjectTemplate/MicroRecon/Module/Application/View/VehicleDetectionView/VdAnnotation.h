//
//  VdAnnotation.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class VdResultModel;

@interface VdAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property(nonatomic,copy)NSString *date;// 经过日期
@property (nonatomic, copy) NSString *moment;// 经过时刻
@property (nonatomic, copy) NSString *LaneNumber;// 车道编号
@property (nonatomic, copy) NSString *bayonetName;// 车道名称
@property (nonatomic, copy) NSString *iconUrl; // 图片url
@property (nonatomic, copy) NSString *kknum; // 经过次数
/**大头针的图片名*/
@property (nonatomic, strong) UIImage  *icon;

@property (nonatomic, copy) NSString *myID; // 车辆信息编号
@property (nonatomic, assign) NSInteger index; // 序号

@property (nonatomic, weak) VdResultModel *model;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
