//
//  XMNChatFireImageMessageCell.m
//  ProjectTemplate
//
//  Created by 李凯华 on 17/3/8.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "XMNChatFireImageMessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImagedownloderOldShouldDecompressImages = YES;

@interface XMNChatFireImageMessageCell ()


/**
 *  用来显示上传进度的UIView
 */
@property (nonatomic, strong) UIView *messageProgressView;

/**
 *  显示上传进度百分比的UILabel
 */
@property (nonatomic, weak) UILabel *messageProgressLabel;

/**
 *  显示上传进度百分比的UILabel
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) UILabel *messageTextL;
@property (nonatomic, strong) UIImageView *fireImage;
@property (nonatomic, strong) UIView *fireBgView;

@end

@implementation XMNChatFireImageMessageCell


#pragma mark - Override Methods

- (void)updateConstraints {
    
    [super updateConstraints];
    
    //    self.messageContentV.backgroundColor = [UIColor redColor];
    
    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(self.messageContentV.mas_right).with.offset(-8);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(2);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(105);
            make.height.offset(100);
        }];
        
        [self.fireImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-35);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(30);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(20);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-45);
            make.width.offset(35);
            make.height.offset(35);
        }];
        
        [self.messageTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-10);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(5);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(65);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-15);
            make.width.offset(90);
            make.height.offset(20);
        }];
        
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-2);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(8);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(105);
            make.height.offset(100);
        }];
        
        [self.fireImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-30);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(35);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(20);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-45);
            make.width.offset(35);
            make.height.offset(35);
        }];
        
        [self.messageTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-5);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(10);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(65);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-15);
            make.width.offset(90);
            make.height.offset(20);
        }];
    }
    
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(@30);
        make.center.equalTo(self.messageContentV);
    }];
    
    [self.fireBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(@105);
        make.center.equalTo(self.messageContentV);
    }];
}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.messageImageView.image = nil;
}

#pragma mark - Public Methods

- (void)setup {
    
    [self.messageContentV addSubview:self.messageImageView];
    [self.messageContentV addSubview:self.messageProgressView];
    [self.messageContentV addSubview:self.loadingView];
    [self.messageContentV addSubview:self.fireBgView];
    [self.messageContentV addSubview:self.fireImage];
    [self.messageContentV addSubview:self.messageTextL];
    
    [super setup];
    
}

- (void)configureCellWithData:(id)data {
    
    [super configureCellWithData:data];
    if (self.messageImageView.image) {
        return;
    }
    
    self.fireMessageTVI.hidden = YES;
    
    id image = data[kXMNMessageConfigurationImageKey];
    
    if ([image isKindOfClass:[UIImage class]]) {
        self.messageImageView.image = image;
        self.messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }else if ([image isKindOfClass:[NSString class]]) {
        
        if ([image isEqualToString:@""]) {
            image = [UIImage imageNamed:@"default_image"];
            self.messageImageView.image = image;
        }else {
            //TODO 是一个路径,可能是网址,需要加载
            [self.loadingView startAnimating];
            [self setImageWithURL:image];
        }
    } else {
        NSLog(@"未知的图片类型");
    }
    
    ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[data[kXMNMessageConfigurationQIDKey]integerValue]];
    
    
    if (data[kXMNMessageConfigurationFireKey])
    {
        self.fireType = data[kXMNMessageConfigurationFireKey];
        if (![[LZXHelper isNullToString:self.fireType] isEqualToString:@""])
        {
            
            if ([self.fireType containsString:@"LOCK"]&&![self.fireType isEqualToString:@"UNLOCK"])
            {
                self.hidden = NO;
                if ([data[kXMNMessageConfigurationOwnerKey] integerValue]==2)
                {
                    self.fireMessageTimeLabel.hidden = YES;
                    self.fireMessageLockVI.hidden = NO;
                }
                else
                {
               //     [self.messageTextL setEmojiText:@"点击查看"];
                    self.fireMessageTimeLabel.hidden = YES;
                    self.fireMessageLockVI.hidden = NO;
                }
            }
            else if ([self.fireType isEqualToString:@"UNLOCK"])
            {
                self.hidden = NO;
                if ([data[kXMNMessageConfigurationOwnerKey] integerValue]==3)
                {
                    self.fireMessageLockVI.hidden = YES;
                    self.fireMessageTimeLabel.hidden = NO;
                }
                
                if (data[kXMNMessageConfigurationTimerStrKey])
                {
                    NSString * timerStr = data[kXMNMessageConfigurationTimerStrKey];
                    if ((![[LZXHelper isNullToString:timerStr] isEqualToString:@""]) )
                    {
                        if ([timerStr integerValue]>1)
                        {
                            self.fireMessageTimeLabel.text = timerStr;
                        }
                        else
                        {
                            [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
                            [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
                            [[NSNotificationCenter defaultCenter]postNotificationName:ChatControllerRefreshUINotification object:nil];
                            self.fireMessageTimeLabel.hidden = YES;
                            self.hidden = YES;
                        }
                        
                    }
                }
            }
            else if ([self.fireType isEqualToString:@"READ"])
            {
                self.fireMessageTimeLabel.hidden = YES;
                self.hidden = YES;
            }
            else
            {
                self.hidden = NO;
            }
        }
        
    }
    
}
- (void)setSDWebImage {
    
    SDImageCache *canche = [SDImageCache sharedImageCache];
    SDImageCacheOldShouldDecompressImages = canche.shouldDecompressImages;
    canche.shouldDecompressImages = NO;
    
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
    
    
}
- (void)setImageWithURL:(NSString *)imageUrl{
    
    NSString *originalUrl = @"";
    if ([imageUrl containsString:@"?type=1"]) {
        NSArray *arr = [imageUrl componentsSeparatedByString:@"?"];
        originalUrl = [arr firstObject];
        if (self.messageOwner == XMNMessageOwnerSelf) {
            if ([self hasDownLoad:originalUrl]) {
                imageUrl = originalUrl;
                [self setSDWebImage];
            }
            //            imageUrl = originalUrl;
        }else {
            if ([self hasDownLoad:originalUrl]) {
                imageUrl = originalUrl;
                [self setSDWebImage];
            }
        }
        
    }
    [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.loadingView stopAnimating];
        // [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        self.messageImageView.image = image;
        self.messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }];
    //    [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_image"]];
}
- (BOOL)hasDownLoad:(NSString *)originalUrl {
    BOOL ret = NO;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if ([manager cachedImageExistsForURL:[NSURL URLWithString:[manager cacheKeyForURL:[NSURL URLWithString:originalUrl]]]]) {
        ret = YES;
    }
    return ret;
}

#pragma mark - Setters

- (void)setUploadProgress:(CGFloat)uploadProgress {
    
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setMessageSendState:XMNMessageSendStateSending];
        [self.messageProgressView setFrame:CGRectMake(0, 0, self.messageImageView.bounds.size.width, self.messageImageView.bounds.size.height * (1 - uploadProgress))];
        [self.messageProgressLabel setText:[NSString stringWithFormat:@"%.0f%%",uploadProgress * 100]];
    });
    
}

- (void)setMessageSendState:(XMNMessageSendState)messageSendState {
    [super setMessageSendState:messageSendState];
    if (messageSendState == XMNMessageSendStateSending) {
        if (!self.messageProgressView.superview) {
            [self.messageContentV addSubview:self.messageProgressView];
        }
        [self.messageProgressLabel setFrame:CGRectMake(0, self.messageImageView.bounds.size.height/2 - 8, self.messageImageView.bounds.size.width, 16)];
    }else {
        [self.messageProgressView removeFromSuperview];
    }
    
}

#pragma mark - Getters

- (UIImageView *)messageImageView {
    
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] init];
        _messageImageView.layer.cornerRadius = 12;
        _messageImageView.layer.masksToBounds = YES;
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _messageImageView;
    
}

- (UIView *)messageProgressView {
    if (!_messageProgressView) {
        _messageProgressView = [[UIView alloc] init];
        _messageProgressView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.3f];
        _messageProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        _messageProgressView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.font = [UIFont systemFontOfSize:14.0f];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.text = @"50.0%";
        
        [_messageProgressView addSubview:self.messageProgressLabel = progressLabel];
    }
    return _messageProgressView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] init];//指定进度轮的大小
        [_loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    }
    
    return _loadingView;
}

- (UILabel *)messageTextL {
    if (!_messageTextL) {
        _messageTextL = [UILabel new];
        _messageTextL.textColor = self.messageOwner == XMNMessageOwnerSelf ? [UIColor whiteColor] : [UIColor grayColor];
        _messageTextL.font = [UIFont systemFontOfSize:12.0f];
        _messageTextL.numberOfLines = 1;
        _messageTextL.userInteractionEnabled = YES;
        _messageTextL.text = @"查看图片";
        _messageTextL.textAlignment = NSTextAlignmentCenter;
    }
    return _messageTextL;
}
- (UIImageView *)fireImage {
    if (!_fireImage) {
        _fireImage = [[UIImageView alloc] init];
        _fireImage.image = self.messageOwner == XMNMessageOwnerSelf ? [UIImage imageNamed:@"firewhiteImage"] : [UIImage imageNamed:@"lookfireimage"];
    }
    return _fireImage;
}

- (UIView *)fireBgView {
    if (!_fireBgView) {
        _fireBgView = [[UIView alloc] init];
        _fireBgView.backgroundColor = self.messageOwner == XMNMessageOwnerSelf ?  [UIColor blackColor] : [UIColor whiteColor];
//        if (self.messageOwner == XMNMessageOwnerSelf) {
//            _fireBgView.alpha = 0.8;
//        }
    }
    return _fireBgView;
}

-(void)dealloc {
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.shouldDecompressImages = SDImageCacheOldShouldDecompressImages;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;
    
}

@end
