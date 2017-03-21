//
//  VehicleDetectionSearchViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  车辆侦查-搜索

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TrafficMonitoring, // 通行监控
    PathAnalysis, // 轨迹分析
} AnalysisType;

@interface VehicleDetectionSearchViewController : UIViewController

@property (nonatomic, assign) AnalysisType analysisType;

@end
