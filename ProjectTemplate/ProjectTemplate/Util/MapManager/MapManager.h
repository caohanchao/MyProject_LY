//
//  MapManager.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MAMapView;

@interface MapManager : NSObject

+ (MAMapView *)shareMAMapView;

@end
