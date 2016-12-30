//
//  MapBottomView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VISITMARK,//走访标记
    FASTMARK,//快速记录
    CAMERAMARK,//摄像头标记
} MARKTYPE;

typedef void(^ChooseBlock)(MARKTYPE type, NSInteger tag);

@interface MapBottomView : UIView

@property (nonatomic, assign) MARKTYPE type;
@property (nonatomic, copy) ChooseBlock block;

- (instancetype)initWithFrame:(CGRect)frame markType:(MARKTYPE)type block:(ChooseBlock)block;
- (void)showIn:(UIView *)view;
- (void)dismiss;
@end
