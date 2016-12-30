//
//  MapLocationManager.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAMapView;
@interface MapLocationManager : NSObject

+ (MAMapView *)shareMAMapView;

@end
