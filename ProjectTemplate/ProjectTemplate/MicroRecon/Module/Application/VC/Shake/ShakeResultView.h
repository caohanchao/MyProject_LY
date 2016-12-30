//
//  ShakeResultView.h
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShakeResultView;

typedef void(^ResultBlock)(ShakeResultView *view);

@interface ShakeResultView : UIView

@property (nonatomic, copy) NSString *resultStr;

- (instancetype)initWithFrame:(CGRect)frame block:(ResultBlock)block;
@end
