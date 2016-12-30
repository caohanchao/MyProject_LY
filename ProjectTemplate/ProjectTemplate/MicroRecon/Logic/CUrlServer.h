//
//  CUrlUtil.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "curl.h"

@interface CUrlServer : NSObject
{
    //连接对象
    CURL *_curl;
}

@property (nonatomic, assign) BOOL isComet;
+ (nonnull instancetype)sharedManager;

- (void) cUrlSetopt;

- (void) cUrlCleanup;

- (void) cUrlInit ;

@end
