//
//  SystemSound.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SystemSound.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SystemSound ()

@property (nonatomic)NSTimeInterval timeInterval;
@property (nonatomic,copy)NSDate *date;

@end

@implementation SystemSound

+ (nonnull instancetype)sharedManager {
    
    static SystemSound *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

#pragma mark - Public

- (void)start
{
    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    if(!self.date) {
        self.date = [NSDate date];
        if([model.soundSet boolValue]){
            [self playNewMessageSound];
        }
        if([model.vibrateSet boolValue]){
            [self playVibration];
        }
    }
    else {
        NSDate *currentDate = [NSDate date];
        self.timeInterval = [currentDate timeIntervalSinceDate:self.date];
        if (self.timeInterval > 2) {
            if([model.soundSet boolValue]){
                [self playNewMessageSound];
            }
            if([model.vibrateSet boolValue]){
                [self playVibration];
            }
            self.date = currentDate;
        }
        
    }
    
    
}


/**
 *  系统铃声播放完成后的回调
 */
void EMSystemSoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}

// 播放接收到新消息时的声音
- (SystemSoundID)playNewMessageSound
{
    
    NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
    // 要播放的音频文件地址
//    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseMob" withExtension:@"bundle"];
//    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    // 创建系统声音，同时返回一个ID
    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundID);
    // Register the sound completion callback.
//    AudioServicesAddSystemSoundCompletion(soundID,
//                                          NULL, // uses the main run loop
//                                          NULL, // uses kCFRunLoopDefaultMode
//                                          EMSystemSoundFinishedPlayingCallback, // the name of our custom callback function
//                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
//                                          );
    
    AudioServicesPlaySystemSound(soundID);
    
    return soundID;

}

// 震动
- (void)playVibration
{

        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                              NULL, // uses the main run loop
                                              NULL, // uses kCFRunLoopDefaultMode
                                              EMSystemSoundFinishedPlayingCallback, // the name of our custom callback function
                                              NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                              );
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
