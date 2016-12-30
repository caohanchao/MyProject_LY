//
//  VehicleDetectionMapManager.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MAMapView;

@interface VehicleDetectionMapManager : NSObject

+ (MAMapView *)shareMAMapView;

@end
