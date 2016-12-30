//
//  GetAudioView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetAudioView;

typedef void(^startGetAudioRecordVoiceBlock)(GetAudioView *view);
typedef void(^cancelGetAudioRecordVoiceBlock)(GetAudioView *view);
typedef void(^confirmGetAudioRecordVoiceBlock)(GetAudioView *view);
typedef void(^updateGetAudioCancelRecordVoiceBlock)(GetAudioView *view);
typedef void(^updateGetAudioContinueRecordVoiceBlock)(GetAudioView *view);

@interface GetAudioView : UIView

@property (nonatomic, copy) startGetAudioRecordVoiceBlock startBlock;
@property (nonatomic, copy) cancelGetAudioRecordVoiceBlock cancelBlock;
@property (nonatomic, copy) confirmGetAudioRecordVoiceBlock confimBlock;
@property (nonatomic, copy) updateGetAudioCancelRecordVoiceBlock updateCancelBlock;
@property (nonatomic, copy) updateGetAudioContinueRecordVoiceBlock updateContinueBlock;

- (instancetype)initWithFrame:(CGRect)frame startBlock:(startGetAudioRecordVoiceBlock)startBlock cancelBlock:(cancelGetAudioRecordVoiceBlock)cancelBlock confimBlock:(confirmGetAudioRecordVoiceBlock)confimBlock updateCancelBlock:(updateGetAudioCancelRecordVoiceBlock)updateCancelBlock updateContinueBlock:(updateGetAudioContinueRecordVoiceBlock)updateContinueBlock;

- (void)showIn:(UIView *)view;
- (void)dismiss;
@end
