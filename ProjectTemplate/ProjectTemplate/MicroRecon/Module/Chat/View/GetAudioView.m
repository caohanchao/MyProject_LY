//
//  GetAudioView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetAudioView.h"
#import "ZEBVoiceView.h"

#define MHeight 185

@interface GetAudioView ()

@property (nonatomic, strong) ZEBVoiceView *btn;
@property (nonatomic, strong) UILabel *laebl;

@end

@implementation GetAudioView

- (instancetype)initWithFrame:(CGRect)frame startBlock:(startGetAudioRecordVoiceBlock)startBlock cancelBlock:(cancelGetAudioRecordVoiceBlock)cancelBlock confimBlock:(confirmGetAudioRecordVoiceBlock)confimBlock updateCancelBlock:(updateGetAudioCancelRecordVoiceBlock)updateCancelBlock updateContinueBlock:(updateGetAudioContinueRecordVoiceBlock)updateContinueBlock {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.startBlock = startBlock;
        self.cancelBlock = cancelBlock;
        self.confimBlock = confimBlock;
        self.updateCancelBlock = updateCancelBlock;
        self.updateContinueBlock = updateContinueBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
- (void)createUI {
//    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btn.frame = CGRectMake(width(self.frame)/2-30, 40, 64, 64);
//    [_btn setBackgroundImage:[UIImage imageNamed:@"getaudio"] forState:UIControlStateNormal];
//    [_btn addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
//    [_btn addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
//    [_btn addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
//    [_btn addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
//    [_btn addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width(self.frame)/2-30, 40, 64, 64)];
    imageView.image = [UIImage imageNamed:@"getaudio"];
    [self addSubview:imageView];
    
    _btn = [[ZEBVoiceView alloc] initWithFrame:imageView.frame startBlock:^(ZEBVoiceView *view) {
        [self startRecordVoice];
    } cancelBlock:^(ZEBVoiceView *view) {
        [self cancelRecordVoice];
    } confimBlock:^(ZEBVoiceView *view) {
        [self confirmRecordVoice];
    } updateCancelBlock:^(ZEBVoiceView *view) {
        [self updateCancelRecordVoice];
    } updateContinueBlock:^(ZEBVoiceView *view) {
        [self updateContinueRecordVoice];
    }];
    _btn.isNoContains = YES;
    [self addSubview:_btn];
    
    _laebl = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(13) textColor:[UIColor blackColor] text:@"按住说话"];
    _laebl.frame = CGRectMake(minX(_btn), maxY(_btn)+10, width(_btn.frame), 30);
    [self addSubview:_laebl];
}

- (void)startRecordVoice {
    self.startBlock(self);
}
- (void)cancelRecordVoice {
    self.cancelBlock(self);
}
- (void)confirmRecordVoice {
    self.confimBlock(self);
}
- (void)updateCancelRecordVoice {
    self.updateCancelBlock(self);
}
- (void)updateContinueRecordVoice {
    self.updateContinueBlock(self);
}

- (void)showIn:(UIView *)view {
    
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
  
        self.frame = CGRectMake(0, kScreenHeight-MHeight, kScreenWidth, MHeight);
    }];
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
