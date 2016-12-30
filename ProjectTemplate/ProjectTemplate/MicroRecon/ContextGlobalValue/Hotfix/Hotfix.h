//
//  Hotfix.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hotfix : NSObject
/**
 *  请求判断js文件是否需要更新
 */
+ (void)httpJSPatch;
/**
 *  下载JSPatch
 */
+ (void)loadJSPatch:(NSString *)jsUrl;
/**
 *  运行下载的JS文件
 */
+ (void)HSDevaluateScript;
@end
