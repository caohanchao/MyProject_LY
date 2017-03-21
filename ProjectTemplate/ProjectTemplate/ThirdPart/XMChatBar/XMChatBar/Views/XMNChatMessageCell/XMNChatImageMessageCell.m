//
//  XMNChatImageMessageCell.m
//  XMNChatExample
//
//  Created by shscce on 15/11/16.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatImageMessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+CornerRadius.h"

static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImagedownloderOldShouldDecompressImages = YES;

@interface XMNChatImageMessageCell ()


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


@end

@implementation XMNChatImageMessageCell


#pragma mark - Override Methods

- (void)updateConstraints {

    [super updateConstraints];
    
//    self.messageContentV.backgroundColor = [UIColor redColor];
    
    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo(self.messageContentV);
            //        make.edges.equalTo(self.messageContentV).insets(UIEdgeInsetsMake(35, 10, 35, 10));
            //        make.edges.equalTo(self.messageContentV).with.insets(UIEdgeInsetsMake(-30, 10, -30, 10));
            
//            make.right.equalTo(self.messageContentV.mas_right).with.offset(0);
//            make.left.equalTo(self.messageContentV.mas_left).with.offset(0);
//            make.top.equalTo(self.messageContentV.mas_top).with.offset(10);
//            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-10);
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-8);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(2);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(220);
            make.height.offset(130);
            
        }];
    
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-2);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(8);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(220);
            make.height.offset(130);
            
        }];
    
    
    }
    
   
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(@30);
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
    [super setup];
    
}

- (void)configureCellWithData:(id)data {
    
    [super configureCellWithData:data];
    if (self.messageImageView.image) {
        return;
    }
    
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
        [self.messageProgressView setFrame:CGRectMake(2.5, 2.5, self.messageImageView.bounds.size.width-5, self.messageImageView.bounds.size.height * (1 - uploadProgress)-5)];
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
        _messageImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
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
-(void)dealloc {
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.shouldDecompressImages = SDImageCacheOldShouldDecompressImages;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;
    
}
@end
