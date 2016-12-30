//
//  AudioView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AudioView.h"
#import "ChatBusiness.h"
#import "UIButton+EnlargeEdge.h"

@interface AudioView ()


@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIActivityIndicatorView *messageIndicatorV;

@property (nonatomic, strong) NSURL *audioUrl;
@end

@implementation AudioView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = RGB(0, 160, 235);
        [self addSubview:self.bgView];
        
        self.backgroundColor = zClearColor;
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(height(self.bgView.frame)/2, height(self.bgView.frame)/2)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = self.bgView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.bgView.layer.mask = maskLayer;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio:)];
        [self.bgView addGestureRecognizer:tap];
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMine:)];
//        longPress.numberOfTouchesRequired = 1;
//        longPress.minimumPressDuration = 1.f;
//        [self addGestureRecognizer:longPress];
        [self createUI];
    }
    return self;
}
- (void)setDelhidden:(BOOL)delhidden {
    _delhidden = delhidden;
    if (_delhidden) {
        self.delBtn.hidden = YES;
    }
}
- (void)createUI {
    
    self.audioImageView = [[UIImageView alloc] init];
    self.audioImageView.image = [UIImage imageNamed:@"RSS"];
    UIImage *image1 = [UIImage imageNamed:@"RSS_playing_1"];
    UIImage *image2 = [UIImage imageNamed:@"RSS_playing_2"];
    UIImage *image3 = [UIImage imageNamed:@"RSS_playing_3"];
    self.audioImageView.highlightedAnimationImages = @[image1,image2,image3];
    self.audioImageView.animationDuration = 1.5f;
    self.audioImageView.animationRepeatCount = NSUIntegerMax;
    
    
    
    self.timeLabel = [LZXHelper getLabelFont:ZEBFont(13) textColor:[UIColor whiteColor]];
    
    self.delBtn = [CHCUI createButtonWithtarg:self sel:@selector(deleteMine) titColor:zClearColor font:ZEBFont(10) image:@"mark_delete" backGroundImage:@"" title:@""];
    [self.delBtn setEnlargeEdge:5];
    
    
    [self addSubview:self.audioImageView];

    [self addSubview:self.timeLabel];
    [self addSubview:self.messageIndicatorV];
    [self addSubview:self.delBtn];
    
    [self.audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(height(self.frame)/2);
        make.size.mas_equalTo(CGSizeMake(11.5, 17));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.audioImageView);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.width.mas_lessThanOrEqualTo(30);
    }];
    [self.messageIndicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.audioImageView);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.left.equalTo(self.mas_right).offset(-8);
        make.top.equalTo(self.mas_top).offset(-2);
    }];
}
- (UIActivityIndicatorView *)messageIndicatorV {
    if (!_messageIndicatorV) {
        _messageIndicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _messageIndicatorV;
}
- (void)setVoiceMessageState:(XMNVoiceMessageState)voiceMessageState {
    if (_voiceMessageState != voiceMessageState) {
        _voiceMessageState = voiceMessageState;
    }
    
    self.audioImageView.hidden = NO;
    self.messageIndicatorV.hidden = YES;
    [self.messageIndicatorV stopAnimating];
    
    if (_voiceMessageState == XMNVoiceMessageStatePlaying) {
        self.audioImageView.highlighted = YES;
        [self.audioImageView startAnimating];
    }else if (_voiceMessageState == XMNVoiceMessageStateDownloading) {
        
        self.audioImageView.hidden = YES;
        self.messageIndicatorV.hidden = NO;
        [self.messageIndicatorV startAnimating];
        
    }else {
        self.audioImageView.highlighted = NO;
        [self.audioImageView stopAnimating];
    }
}
- (void)setAudioStr:(NSString *)audioStr {
    _audioStr = audioStr;
    [self loadingAudio];
}
- (void)setTime:(NSTimeInterval)time {
    _time = time;
    NSInteger t = _time;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld”", t];
}

- (void)loadingAudio {
    
    if ([_audioStr hasPrefix:@"http"] || [_audioStr hasPrefix:@"https"]) {
        //1.检查URLString是本地文件还是网络文件
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        NSURL *filePath = [ZEBCache audioCacheUrlString:_audioStr chatId:chatId];
        if ([LZXHelper isUrlExist:filePath]) {
            NSInteger time = [ChatBusiness durationWithVideo:filePath];
           // NSString *time1 = [[NSString stringWithFormat:@"%ld",time] getMMSSFromSS];
            self.timeLabel.text = [NSString stringWithFormat:@"%ld”", time];
            self.audioUrl = filePath;
        }else {
        __weak typeof(self) weakSelf = self;
        [[HttpsManager sharedManager] downloadAudio:_audioStr progress:^(NSProgress * _Nonnull progress) {
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse) {
            weakSelf.messageIndicatorV.hidden = NO;
            weakSelf.audioImageView.hidden = YES;
            [weakSelf.messageIndicatorV startAnimating];
            return targetPath;
        } completionHandler:^(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error) {
            weakSelf.messageIndicatorV.hidden = YES;
            weakSelf.audioImageView.hidden = NO;
            [weakSelf.messageIndicatorV stopAnimating];
            weakSelf.audioUrl = filePath;
            NSInteger time = [ChatBusiness durationWithVideo:filePath];
            //NSString *time1 = [[NSString stringWithFormat:@"%ld",time] getMMSSFromSS];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%ld”", time];
            
        }];
        }
    }
}
- (void)playAudio:(UITapGestureRecognizer *)recognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(audioViewPlayAudio:index:audio:)]) {
        [_delegate audioViewPlayAudio:self index:self.index audio:self.audioUrl];
    }
}
//- (void)deleteMine:(UILongPressGestureRecognizer *)longPressGes {
//    if (longPressGes.state == UIGestureRecognizerStateBegan) {
//        if (_delegate && [_delegate respondsToSelector:@selector(audioViewPlayAudio:deleteAudioIndex:)]) {
//            [_delegate audioViewPlayAudio:self deleteAudioIndex:self.index];
//        }
//    }
//}
- (void)deleteMine {
   
    if (_delegate && [_delegate respondsToSelector:@selector(audioViewPlayAudio:deleteAudioIndex:)]) {
        [_delegate audioViewPlayAudio:self deleteAudioIndex:self.index];
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
