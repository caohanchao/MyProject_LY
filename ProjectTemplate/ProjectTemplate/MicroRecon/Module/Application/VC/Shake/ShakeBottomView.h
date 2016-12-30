//
//  ShakeBottomView.h
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShakeBottomView;

typedef void(^CameraBlock)(ShakeBottomView *view);// 摄像头
typedef void(^PolicingBlock)(ShakeBottomView *view);// 警务室
typedef void(^BaseStationBlock)(ShakeBottomView *view);// 基站

@interface ShakeBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame cBlock:(CameraBlock)cBlock pBlock:(PolicingBlock)pBlock bSBlock:(BaseStationBlock)bSBlock;

@end
