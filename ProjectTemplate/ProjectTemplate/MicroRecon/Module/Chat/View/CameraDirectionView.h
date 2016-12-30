//
//  CameraDirectionView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CameraDirectionView;


typedef void(^CameraDireationClickBlock)(CameraDirectionView *view, NSInteger tag);

@interface CameraDirectionView : UIView

@property (nonatomic, copy) CameraDireationClickBlock block;

- (instancetype)initWithFrame:(CGRect)frame cameraDirationBlock:(CameraDireationClickBlock)block;
- (void)showIn:(UIView *)view;
- (void)dismiss;
@end
