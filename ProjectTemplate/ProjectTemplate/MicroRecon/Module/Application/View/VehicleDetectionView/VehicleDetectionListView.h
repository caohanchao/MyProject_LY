//
//  VehicleDetectionListView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VdResultModel;
@class VehicleDetectionListView;

#define HeightC [UIScreen mainScreen].bounds.size.height*0.6 // 默认距离屏幕顶部的高度

@protocol VehicleDetectionListViewDelegate <NSObject>

- (void)vehicleDetectionListView:(VehicleDetectionListView *)view vdResultModel:(VdResultModel *)mode;

@end

@interface VehicleDetectionListView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dateDic;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, weak) id<VehicleDetectionListViewDelegate> delegate;

- (void)isToTop;
- (void)isToCenter;
- (void)isToBottom;
- (void)reloadData;
@end
