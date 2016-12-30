//
//  XMNChatVideoMessageCell.m
//  Pods
//
//  Created by 郑胜 on 16/8/3.
//
//

#import "XMNChatVideoMessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

@interface XMNChatVideoMessageCell ()
/**
 *  用来显示image的UIImageView
 */
@property (nonatomic, strong) UIImageView *messageImageView;

/**
 *  用来显示上传进度的UIView
 */
@property (nonatomic, strong) UIView *messageProgressView;

/**
 *  显示上传进度百分比的UILabel
 */
@property (nonatomic, weak) UILabel *messageProgressLabel;
/**
 *  显示上传中的提示语UILabel
 */
@property (nonatomic, strong) UILabel *uplodingLabel;

@end

@implementation XMNChatVideoMessageCell

#pragma mark - Override Methods

- (void)updateConstraints {
    
    [super updateConstraints];
    
//    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.equalTo(self.messageContentV);
//        make.right.equalTo(self.messageContentV.mas_right).with.offset(0);
//        make.left.equalTo(self.messageContentV.mas_left).with.offset(0);
//        make.top.equalTo(self.messageContentV.mas_top).with.offset(10);
//        make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-10);
//        make.width.offset(210);
//        make.height.offset(130);
//
//    }];

    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(self.messageContentV.mas_right).with.offset(-8);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(2);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(210);
            make.height.offset(130);
            
        }];
        
    }else if (self.messageOwner == XMNMessageOwnerOther) {
        [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-2);
            make.left.equalTo(self.messageContentV.mas_left).with.offset(8);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(2);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-2);
            make.width.offset(210);
            make.height.offset(130);
            
        }];
        
        
    }
    
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.messageImageView.image = nil;
}

#pragma mark - Public Methods

- (void)setup {
    
    [self.messageContentV addSubview:self.messageImageView];
    [self.messageContentV addSubview:self.messageProgressView];
    [self.messageImageView addSubview:self.uplodingLabel];
    [super setup];
    
}

- (void)configureCellWithData:(id)data {
    
    [super configureCellWithData:data];
    if (self.messageImageView.image) {
        return;
    }
    
//    if ([data[kXMNMessageConfigurationSendStateKey] isEqualToString:@"2"] && data[kXMNMessageConfigurationSendStateKey]) {
//        id video = data[kXMNMessageConfigurationVideoKey];
//    }
    id video = data[kXMNMessageConfigurationVideoKey];
    if ([video isKindOfClass:NSURL.class]) {
        // 本地视频
        self.messageImageView.image = data[kXMNMessageConfigurationImageKey];
    } else if ([video isKindOfClass:NSString.class]) {
        
        id image = data[kXMNMessageConfigurationImageKey];
        if ([image isKindOfClass:[UIImage class]]) {
            [self.messageImageView setImage:image];
            
        } else {
            // 网络视频
            [self setImageWithUrl:data[kXMNMessageConfigurationImageKey]];
        }
        

        if (![video isEqualToString:@""]) {
        
            [self.uplodingLabel removeFromSuperview];
      
        }
        
    }
}

- (void)setImageWithUrl:(NSString *)imageUrl{
    
    NSRange range = [imageUrl rangeOfString:@"?"];
    if (range.length > 0) {
        imageUrl = [imageUrl substringToIndex:range.location];
    }
    
    [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_image"]];
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
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
        _messageImageView.layer.cornerRadius = 12;
        _messageImageView.layer.masksToBounds = YES;
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
       // progressLabel.text = @"50.0%";
        
        [_messageProgressView addSubview:self.messageProgressLabel = progressLabel];
    }
    return _messageProgressView;
}
- (UILabel *)uplodingLabel {

    if (_uplodingLabel == nil) {
        _uplodingLabel = [[UILabel alloc] init];
        _uplodingLabel.frame = CGRectMake(7, 200-30, 214, 30);
        _uplodingLabel.font = ZEBFont(13);
        _uplodingLabel.text = @"正在上传...";
        _uplodingLabel.textColor = [UIColor whiteColor];
        _uplodingLabel.backgroundColor = [UIColor blackColor];
        _uplodingLabel.alpha = 0.5;
    }
    return _uplodingLabel;
}

@end
