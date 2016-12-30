//
//  HMAudioTool.m
//
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//  播放本地音乐

#import <Foundation/Foundation.h>

static SystemSoundID shake_sound_male_id = 0;
static SystemSoundID shake_sound_match_id = 1;

@interface ZEBAudioTool : NSObject
/**
 *  播放自定义音乐 摇一摇
 *
 */
+ (void)playSound;
/**
 播放搜到结果后声音
 */
+ (void)playResultSound;
@end
