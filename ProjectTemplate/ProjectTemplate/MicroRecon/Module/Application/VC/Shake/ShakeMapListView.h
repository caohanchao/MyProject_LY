//
//  VehicleDetectionListView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HeightC  ([UIScreen mainScreen].bounds.size.height - 259)//[UIScreen mainScreen].bounds.size.height*0.6 // 默认距离屏幕顶部的高度

@class ShakeMapListView;
@class ShakeCameraModel;


typedef enum : NSUInteger {
    ShakeMapListCamera,// 摄像头
    ShakeMapListPolicing,// 警务室
    ShakeMapListBaseStation,// 基站
} SHAKEMAPLISTSHAKETYPE;

@protocol ShakeMapListViewDelegate <NSObject>

- (void)shakeMapListView:(ShakeMapListView *)view model:(ShakeCameraModel *)model;

@end

@interface ShakeMapListView : UIView


@property (nonatomic, weak) id<ShakeMapListViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) SHAKEMAPLISTSHAKETYPE shakeMapListType;
#pragma mark -
#pragma mark 刷新tableview
- (void)reloadData:(NSMutableArray *)arr;
// 滚动视图
- (void)scrollToSection:(NSInteger)section;
// 选中
- (void)selectSection:(NSInteger)section;
//在中间
- (void)scrollToCenter;
@end
