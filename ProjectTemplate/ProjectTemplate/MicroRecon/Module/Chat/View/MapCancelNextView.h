//
//  MapCancelNextView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapCancelNextView;

typedef void(^NextClickBlock)(MapCancelNextView *view);
typedef void(^CancelClickBlock)(MapCancelNextView *view);

@interface MapCancelNextView : UIView

@property (nonatomic, copy) NextClickBlock block;
@property (nonatomic, copy) CancelClickBlock cBlock;
- (instancetype)initWithFrame:(CGRect)frame nextBlock:(NextClickBlock)block cancelBlock:(CancelClickBlock)cBlock;
- (void)dismiss;
@end
