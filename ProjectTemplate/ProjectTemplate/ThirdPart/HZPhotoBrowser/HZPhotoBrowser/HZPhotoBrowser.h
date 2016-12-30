//
//  HZPhotoBrowser.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoBrowserView.h"

@class HZPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

@optional
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface HZPhotoBrowser : UIViewController

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;//图片总数

@property (nonatomic, copy) NSString * imageUrl;

@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

/**
 是否支持长按
 */
@property (nonatomic, assign) BOOL longPress;

- (void)show;
@end
