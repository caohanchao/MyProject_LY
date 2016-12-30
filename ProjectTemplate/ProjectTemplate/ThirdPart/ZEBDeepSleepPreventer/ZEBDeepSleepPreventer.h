//
//  ZEBDeepSleepPreventer.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//


#pragma mark -
#pragma mark MMPLog

// Set up some advanced logging preprocessor macros to replace NSLog.
// I usually have this in an external file (MMPLog.h) which is maintained in its own git repository.
// I add this repository in my other projects as a submodule (via git submodule) and import the MMPLog.h
// in a project's Prefix.pch.
//
// For convenience reasons, I just include these macros here, so other people are not confused by
// git submodule if they are unfamiliar with it or simply don't have to bother and can use MMPDeepSleepPreventer
// as simple drop-in code.

#ifndef MMPDLog
#ifdef DEBUG
#define MMPDLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MMPDLog(...) do { } while (0)
#endif
#endif

#ifndef MMPALog
#define MMPALog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif


#pragma mark -
#pragma mark Imports and Forward Declarations

#import <Foundation/Foundation.h>

@class AVAudioPlayer;


#pragma mark -
#pragma mark Public Interface

@interface ZEBDeepSleepPreventer : NSObject
{
    
}


#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSTimer       *preventSleepTimer;


#pragma mark -
#pragma mark Public Methods

- (void)startPreventSleep;
- (void)stopPreventSleep;

@end

