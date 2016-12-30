//
//  comdef.h
//  LandscapeAssistant
//
//  Created by Shondring on 6/25/14.
//  Copyright (c) 2014 Shondring. All rights reserved.
//

//设置是否使用测试环境
#ifdef _TEST_
#undef _TEST_
#endif
#define _TEST_ 1//0生产，1测试

//debug时log机制
#ifdef DEBUG
#ifdef _SHOW_LOG_
#undef _SHOW_LOG_
#endif
#define _SHOW_LOG_  //不定义时不打印NSLOG，定义时打印NSLOG
#endif

//NSlog 控制
#ifdef _SHOW_LOG_
#define NSLog(...) NSLog(__VA_ARGS__)
#define DBeginMethod() NSLog(@"%s---Begin", __func__)
#define DEndMethod() NSLog(@"%s---End", __func__)
#else
#define NSLog(...)
#define DBeginMethod()
#define DEndMethod()
#endif


//log
#ifdef DEBUG
#define DXBLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define DXBLog(format, ...)
#endif
