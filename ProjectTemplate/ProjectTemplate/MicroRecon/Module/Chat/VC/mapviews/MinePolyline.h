//
//  MinePolyline.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class MinePolylineRenderer;

@interface MinePolyline : MAPolyline

@property (nonatomic, weak) MinePolylineRenderer *polylineRenderer;
@property (nonatomic, copy) NSString *polylineId;

@end
