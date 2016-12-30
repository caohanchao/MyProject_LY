//
//  ZEBVoiceView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZEBVoiceView;

typedef void(^startRecordVoiceBlock)(ZEBVoiceView *view);
typedef void(^cancelRecordVoiceBlock)(ZEBVoiceView *view);
typedef void(^confirmRecordVoiceBlock)(ZEBVoiceView *view);
typedef void(^updateCancelRecordVoiceBlock)(ZEBVoiceView *view);
typedef void(^updateContinueRecordVoiceBlock)(ZEBVoiceView *view);

@interface ZEBVoiceView : UILabel


@property (nonatomic, copy) startRecordVoiceBlock startBlock;
@property (nonatomic, copy) cancelRecordVoiceBlock cancelBlock;
@property (nonatomic, copy) confirmRecordVoiceBlock confimBlock;
@property (nonatomic, copy) updateCancelRecordVoiceBlock updateCancelBlock;
@property (nonatomic, copy) updateContinueRecordVoiceBlock updateContinueBlock;
@property (nonatomic, assign) BOOL isNoContains;

- (instancetype)initWithFrame:(CGRect)frame startBlock:(startRecordVoiceBlock)startBlock cancelBlock:(cancelRecordVoiceBlock)cancelBlock confimBlock:(confirmRecordVoiceBlock)confimBlock updateCancelBlock:(updateCancelRecordVoiceBlock)updateCancelBlock updateContinueBlock:(updateContinueRecordVoiceBlock)updateContinueBlock;

@end
