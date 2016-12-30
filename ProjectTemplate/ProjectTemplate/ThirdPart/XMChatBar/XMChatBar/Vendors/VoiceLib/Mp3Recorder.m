//
//  Mp3Recorder.m
//  BloodSugar
//
//  Created by PeterPan on 14-3-24.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "Mp3Recorder.h"
#import "lame.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "amr_wav_converter.h"

@interface Mp3Recorder()<AVAudioRecorderDelegate>
//@property (nonatomic, strong) AVAudioSession *session;
//@property (nonatomic, strong) AVAudioRecorder *recorder;
{
    AVAudioRecorder *audioRecorder;
    
    NSURL *tempRecordFileURL;
    NSURL *currentRecordFileURL;
    
    BOOL isRecording;
    dispatch_source_t timer;
}

@end

@implementation Mp3Recorder

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    if (isRecording) [audioRecorder stop];
}

- (void)p_setupAudioRecorder
{
    audioRecorder = nil;
    audioRecorder.delegate = nil;
    
    NSString *recordFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"rec.wav"];

    tempRecordFileURL = [NSURL URLWithString:recordFile];
    
    NSDictionary *recordSetting = @{ AVSampleRateKey        : @8000.0,                      // 采样率
                                     AVFormatIDKey          : @(kAudioFormatLinearPCM),     // 音频格式
                                     AVLinearPCMBitDepthKey : @16,                          // 采样位数 默认 16
                                     AVNumberOfChannelsKey  : @1                            // 通道的数目
                                     };
    
    // AVLinearPCMIsBigEndianKey    大端还是小端 是内存的组织方式
    // AVLinearPCMIsFloatKey        采样信号是整数还是浮点数
    // AVEncoderAudioQualityKey     音频编码质量
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:tempRecordFileURL
                                                settings:recordSetting
                                                   error:nil];
    
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
}

- (void)startRecord;
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *amrFileName = [NSString stringWithFormat:@"record_%@.amr", date];
    
    currentRecordFileURL = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:amrFileName]];
    
    NSLog(@"$$$$$$$$$$$$$$$$$  RecordFileURL  %@", currentRecordFileURL.absoluteString);
    
    [self p_setupAudioRecorder];
    
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    
    [audioRecorder record];
    [self p_createPickSpeakPowerTimer];
    
}

- (void)p_createPickSpeakPowerTimer
{
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
    
    //__weak __typeof(self) weakSelf = self;
    
    dispatch_source_set_event_handler(timer, ^{
       // __strong __typeof(weakSelf) _self = weakSelf;
        
    });
    
    dispatch_resume(timer);
}

- (void)stopRecord;
{
    
    double cTime = audioRecorder.currentTime;
    [audioRecorder stop];
    
    if (cTime > 1) {
        [self wav2amr];
    }else {
        
        [audioRecorder deleteRecording];
        
        if ([_delegate respondsToSelector:@selector(failRecord)]) {
            [_delegate failRecord];
        }
    }
}

- (void)wav2amr {
    // remove the old mp3 file
    [self deleteFileWithPath:currentRecordFileURL.absoluteString];
    
    NSLog(@"MP3转换开始");
    if (_delegate && [_delegate respondsToSelector:@selector(beginConvert)]) {
        [_delegate beginConvert];
    }
    @try {
        wave_file_to_amr_file([tempRecordFileURL.absoluteString cStringUsingEncoding:NSASCIIStringEncoding],
                              [currentRecordFileURL.absoluteString cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    [self deleteFileWithPath:tempRecordFileURL.absoluteString];
    NSLog(@"MP3转换结束");
    if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithMP3FileName:)]) {
        [_delegate endConvertWithMP3FileName:currentRecordFileURL.absoluteString];
    }

}

- (void)setSpeakMode:(BOOL)speakMode
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0f) {
        AVAudioSessionPortOverride portOverride = speakMode ? AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone;
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:portOverride error:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UInt32 route = speakMode ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
#pragma clang diagnostic pop
        
    }
}


#pragma mark - Init Methods


- (void)cancelRecord
{
    [audioRecorder stop];
    [audioRecorder deleteRecording];
}

- (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        NSLog(@"删除以前的mp3文件");
    }
}
@end
