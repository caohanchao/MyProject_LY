//
//  VideoViewCollectionViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "VideoViewCollectionViewCell.h"
#import "VideoView.h"

@interface VideoViewCollectionViewCell ()<VideoViewDelegate>

@property (nonatomic, strong) VideoView *videoView;

@end

@implementation VideoViewCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}
- (void)createUI {
    self.videoView = [[VideoView alloc] initWithFrame:self.bounds];
    self.videoView.delhidden = YES;
    self.videoView.delegate = self;
    [self.contentView addSubview:self.videoView];
    
    
}
- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    self.videoView.videoStr = _videoUrl;
}
- (void)videoView:(VideoView *)view index:(NSInteger)index videlUrl:(NSString *)videoUrl {
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"videoUrl"] = self.videoUrl;
    
    [LYRouter openURL:@"ly://MessageBoardViewControllerplayvideo" withUserInfo:parm completion:^(id result) {
        
    }];
}
@end
