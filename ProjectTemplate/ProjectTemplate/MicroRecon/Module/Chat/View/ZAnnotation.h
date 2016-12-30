//
//  ZAnnotation.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface ZAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSString *time;//时间

@property (nonatomic, copy) NSString *title;//title
@property (nonatomic, copy) NSString *subtitle;//详情
/**大头针的图片名*/
@property (nonatomic, strong)UIImage  *icon;

//type
@property(nonatomic, copy)NSString *type;
//direction
@property (nonatomic, copy) NSString *direction;
//本身的类型
@property(nonatomic, copy)NSString *My_type;//0 走访标记 1 快速记录  2摄像头
//警号
@property (nonatomic, copy) NSString *alarm;
//任务id
@property (nonatomic, copy) NSString *workid;
//任务model
@property (nonatomic, strong) id model;
//标记id
@property (nonatomic, copy) NSString *interId;
@end
