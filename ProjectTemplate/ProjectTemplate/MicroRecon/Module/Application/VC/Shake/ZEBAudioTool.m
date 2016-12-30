//
//  HMAudioTool.m
//
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import "ZEBAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZEBAudioTool

/**
 *  存放所有的音乐播放器
 */
static NSMutableDictionary *_musicPlayers;
+ (NSMutableDictionary *)musicPlayers
{
    if (!_musicPlayers) {
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}

/**
 *  播放自定义音乐 摇一摇
 *
 */
+ (void)playSound {
    
    //    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseMob" withExtension:@"bundle"];
    //    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"mp3"];

    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL URLWithString:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
//    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

/**
 播放搜到结果后声音
 */
+ (void)playResultSound {
    
    //    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseMob" withExtension:@"bundle"];
    //    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL URLWithString:path],&shake_sound_match_id);
        AudioServicesPlaySystemSound(shake_sound_match_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    //    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
@end
