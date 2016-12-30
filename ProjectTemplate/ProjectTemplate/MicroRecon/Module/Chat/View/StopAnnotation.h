//
//  StopAnnotation.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class StopPathAnnotationView;

@interface StopAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, weak) StopPathAnnotationView *stopPathAnnotationView;
@property (nonatomic, copy) NSString *polylineID; // 关联的线id

@property (nonatomic, copy) NSString *title;//title
@property (nonatomic, copy) NSString *subtitle;//详情

@property (nonatomic, copy) NSString *alarm;

@property (nonatomic, assign) BOOL isBig;
@end
