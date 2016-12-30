//
//  TestVideoViewController.m
//  Memento
//
//  Created by Ömer Faruk Gül on 22/05/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "VideoViewController.h"
#import "HttpsManager.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
@import AVFoundation;

@interface VideoViewController () {

    UIActivityIndicatorView *_indicator;
    
}
//@property (strong, nonatomic) NSURL *videoUrl;
@property (strong, nonatomic) id videoUrl;
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UISlider *slider;
@property (assign, nonatomic) BOOL isPlayed;
@property (nonatomic,strong) NSURL *filePath;
@end

@implementation VideoViewController

- (instancetype)initWithVideoUrl:(id)url {
    self = [super init];
    if(self) {
        _videoUrl = url;
        _isPlayed = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
       self.avPlayerLayer = [AVPlayerLayer new];
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressToDO:)];
    longPress.numberOfTouchesRequired=1;
    longPress.minimumPressDuration=1.0;
    
    //self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    [self.view.layer addSublayer:self.avPlayerLayer];
    
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.pauseButton];
    [self.view addSubview:self.cancelButton];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //设置显示位置
    _indicator.center = self.view.center;;
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
//    [self.view addSubview:self.slider];
    [self makeConstraints];
    // cancel button
    
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.videoUrl isKindOfClass:NSURL.class]) {
        [self playVideo:self.videoUrl];
    } else if ([self.videoUrl isKindOfClass:NSString.class]) {
        
        /**
         *  判断沙盒路径下是否有缓存
         */
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        NSURL *filePath = [ZEBCache videoCacheUrlString:self.videoUrl chatId:chatId];
        NSString *fileString = filePath.absoluteString;
        fileString = [fileString substringFromIndex:7];
        if ([LZXHelper isFileExist:fileString]) {
            
            [self playVideo:filePath];
            [self.view addGestureRecognizer:longPress];
            self.filePath=filePath;
        
        }else {
            [_indicator startAnimating];
            __weak typeof(self) weakSelf = self;
            [[HttpsManager sharedManager] download:self.videoUrl progress:^(NSProgress * _Nonnull progress) {
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse) {
                return targetPath;
            } completionHandler:^(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [_indicator stopAnimating];
                [self.view addGestureRecognizer:longPress];
                [weakSelf playVideo:filePath];
                self.filePath=filePath;
                
            }];
        }
    }
    
}

-(void)playVideo:(NSURL *)url {
    // the video player
    self.avPlayer = [AVPlayer playerWithURL:url];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [self.avPlayerLayer setPlayer:self.avPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    [self.avPlayer play];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [self.avPlayer play];
//}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
    self.isPlayed = YES;
//    AVPlayerItem *p = [notification object];
//    [p currentTime];
//    [p seekToTime:kCMTimeZero];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIButton *)cancelButton {
    if(!_cancelButton) {
        UIImage *cancelImage = [UIImage imageNamed:@"cancel.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor = [UIColor whiteColor];
        [button setImage:cancelImage forState:UIControlStateNormal];
        button.imageView.clipsToBounds = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//        button.layer.shadowOpacity = 0.4f;
//        button.layer.shadowRadius = 1.0f;
        button.clipsToBounds = NO;
        
        _cancelButton = button;
    }
    
    return _cancelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter && Setter

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = YES;
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
    }
    return _slider;
}

#pragma mark - Selector

- (void)cancelButtonPressed:(UIButton *)button {
    [self.avPlayer pause];
    self.avPlayer = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)playButtonPressed:(UIButton *)button {
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
    if (self.isPlayed) {
        self.isPlayed = NO;
        [[self.avPlayer currentItem] seekToTime:kCMTimeZero];
    } else {
        [self.avPlayer play];
    }
}

- (void)pauseButtonPressed:(UIButton *)button {
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
    [self.avPlayer pause];
}

#pragma mark - Masonry

- (void)makeConstraints {
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0.f);
        make.top.equalTo(self.view.mas_top).offset(10.f);
        make.height.and.width.mas_equalTo(44.f);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0.f);
        make.height.and.width.mas_equalTo(44.f);
    }];
    
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0.f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0.f);
        make.height.and.width.mas_equalTo(44.f);
    }];
    
//    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.playButton.mas_right).offset(5.f);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-5.f);
//        make.right.equalTo(self.view.mas_right).offset(-20.f);
//    }];
}

-(void)LongPressToDO:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state==UIGestureRecognizerStateBegan) {
        
       // NSLog(@"%@",self.filePath);
        
        if (self.filePath) {
            
            if (self.videoLongPress) {
                self.videoLongPress(self.filePath);
            }
        }

    }
}
@end
