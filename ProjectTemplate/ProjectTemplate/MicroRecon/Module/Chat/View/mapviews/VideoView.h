//
//  VideoView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoView;

@protocol VideoViewDelegate <NSObject>

@optional
- (void)videoView:(VideoView *)view index:(NSInteger)index;
- (void)videoView:(VideoView *)view deleteVideoIndex:(NSInteger)index;
@end

@interface VideoView : UIView

@property (nonatomic, weak) id<VideoViewDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *videoStr;
@property (nonatomic, strong) NSURL *filePath;
@property (nonatomic, assign) BOOL delhidden;

- (instancetype)initWithFrame:(CGRect)frame widthVideoUrl:(NSString *)videoUrl;

@end
