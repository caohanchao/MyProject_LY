//
//  VideoView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VideoView.h"
#import "UIImageView+CornerRadius.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIButton+EnlargeEdge.h"

@interface VideoView ()

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIActivityIndicatorView *messageIndicatorV;
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation VideoView
- (instancetype)initWithFrame:(CGRect)frame widthVideoUrl:(NSString *)videoUrl {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self createUI];
        self.videoStr = videoUrl;
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self createUI];
        
    }
    return self;
}
- (void)createUI {
    
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
    [self addGestureRecognizer:tap];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMine:)];
//    longPress.numberOfTouchesRequired = 1;
//    longPress.minimumPressDuration = 1.f;
//    [self addGestureRecognizer:longPress];

    
    self.videoImageView.frame = self.bounds;
    [self addSubview:self.videoImageView];
    
    
    self.delBtn = [CHCUI createButtonWithtarg:self sel:@selector(deleteMine) titColor:zClearColor font:ZEBFont(10) image:@"mark_delete" backGroundImage:@"" title:@""];
    [self.delBtn setEnlargeEdge:5];
   
    
    UIView *plView = [[UIView alloc] initWithFrame:self.bounds];
    plView.backgroundColor = [UIColor blackColor];
    plView.alpha = 0.5;
    plView.userInteractionEnabled = NO;
    [self addSubview:plView];
    
    self.bgImageView.frame = CGRectMake(0, 0, 21, 21);
    self.bgImageView.center = self.videoImageView.center;
    [self addSubview:self.bgImageView];
    
    self.messageIndicatorV.frame = CGRectMake(0, 0, 30, 30);
    self.messageIndicatorV.center = CGPointMake(21/2, 21/2);
    [self.bgImageView addSubview:self.messageIndicatorV];
    [self.messageIndicatorV startAnimating];

    [self addSubview:self.delBtn];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.left.equalTo(self.mas_right).offset(-7);
        make.top.equalTo(self.mas_top).offset(-7);
    }];

}
- (void)setDelhidden:(BOOL)delhidden {
    _delhidden = delhidden;
    if (_delhidden) {
        self.delBtn.hidden = YES;
    }
}
- (void)setVideoStr:(NSString *)videoStr {
    _videoStr = videoStr;
    
    [self loadingVideo];
}
- (UIActivityIndicatorView *)messageIndicatorV {
    if (!_messageIndicatorV) {
        _messageIndicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _messageIndicatorV;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videostart"]];
    }
    return _bgImageView;
}
- (UIImageView *)videoImageView {

    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.clipsToBounds = YES;
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _videoImageView;
}
- (void)loadingVideo {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    NSURL *filePath = [ZEBCache videoCacheUrlString:self.videoStr chatId:chatId];
    
        if ([LZXHelper isUrlExist:filePath]) {
                self.messageIndicatorV.hidden = YES;
                [self.messageIndicatorV stopAnimating];
                self.userInteractionEnabled = YES;
                [self firstFrameWithVideoURL:filePath];
                self.filePath=filePath;
        }else {
            __weak typeof(self) weakSelf = self;
            [[HttpsManager sharedManager] download:self.videoStr progress:^(NSProgress * _Nonnull progress) {
                
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse) {
                
                return targetPath;
            } completionHandler:^(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error) {
                weakSelf.messageIndicatorV.hidden = YES;
                [weakSelf.messageIndicatorV stopAnimating];
                weakSelf.userInteractionEnabled = YES;
                [self firstFrameWithVideoURL:filePath];
                weakSelf.filePath=filePath;
                
            }];
        }
    
    }
#pragma mark - Video Methods
- (void)firstFrameWithVideoURL:(NSURL *)url {
    if (!url) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取视频第一帧
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        NSError *error = nil;
        CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
        if (error == nil)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
            self.videoImageView.image =  [UIImage imageWithCGImage:imageRef];
            });
            
        }

    });
    
}
- (void)playVideo:(UITapGestureRecognizer *)recognizer {
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoView:index:videlUrl:)]) {
        [_delegate videoView:self index:self.index videlUrl:self.videoStr];
    }
}
//- (void)deleteMine:(UILongPressGestureRecognizer *)longPressGes {
//    if (longPressGes.state == UIGestureRecognizerStateBegan) {
//        if (_delegate && [_delegate respondsToSelector:@selector(videoView:deleteVideoIndex:)]) {
//            [_delegate videoView:self deleteVideoIndex:self.index];
//        }
//    }
//}
- (void)deleteMine {
   
    if (_delegate && [_delegate respondsToSelector:@selector(videoView:deleteVideoIndex:)]) {
        [_delegate videoView:self deleteVideoIndex:self.index];
    }
    
}
//重写该方法后可以让超出父视图范围的子视图响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
