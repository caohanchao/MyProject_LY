//
//  ShakePolicingTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShakeCameraModel;

@interface ShakePolicingTableViewCell : UITableViewCell


@property (nonatomic, assign) NSInteger type; // 0.摄像头 1.监控室 2.基站


@property (nonatomic, weak) ShakeCameraModel *model;

@end
