//
//  AudioView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioView;

@protocol AudioViewDelegate <NSObject>

@optional
- (void)audioViewPlayAudio:(AudioView *)view index:(NSInteger)index audio:(NSURL *)url;
- (void)audioViewPlayAudio:(AudioView *)view deleteAudioIndex:(NSInteger)index;
@end

@interface AudioView : UIView


@property (nonatomic, assign) XMNVoiceMessageState voiceMessageState;
@property (nonatomic, copy) NSString *audioStr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<AudioViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *audioImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, assign) BOOL delhidden;

@end
