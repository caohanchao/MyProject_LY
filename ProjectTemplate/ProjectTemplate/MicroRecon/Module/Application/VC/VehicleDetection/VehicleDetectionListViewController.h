//
//  VehicleDetectionListViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VdResultModel;

@interface VehicleDetectionListViewController : UIViewController

- (void)setCarDataSources:(NSArray *)carDataSource;
- (void)setkkbh:(NSString *)kkbh withAllarr:(NSMutableArray *)arr;

@end
