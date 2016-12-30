//
//  Hotfix.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "Hotfix.h"
#import "JPEngine.h"
#import "JspatchBaseModel.h"

// Library/Caches
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])


@implementation Hotfix


+ (void)httpJSPatch {

    
    NSString *jsVersion = [[NSUserDefaults standardUserDefaults] objectForKey:jsversion];
    if (jsVersion == nil) {
        jsVersion = @"1";
    }
    NSString *appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"iosappupdate";
    paramDict[@"appversion"] = appVersion;
    paramDict[@"jsversion"] = jsVersion;
    paramDict[@"alarm"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    paramDict[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    [[HttpsManager sharedManager] get:HotfixJSUrl parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *time = [formatter stringFromDate:[NSDate date]];
        
        JspatchBaseModel *baseModel = [JspatchBaseModel getInfoWithData:response];
        
        JsPatchModel *model = baseModel.jsPatch;
        model.time = time;
        [[NSUserDefaults standardUserDefaults] setObject:model.jsVersion forKey:jsversion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (![[LZXHelper isNullToString:model.jsUrl] isEqualToString:@""]) {
            [[[DBManager sharedManager] systemUpdataSQ] insertSystemUpdatalist:model];
            [Hotfix loadJSPatch:model.jsUrl];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
/**
 *  下载JSPatch
 */
+ (void)loadJSPatch:(NSString *)jsUrl
{
    //使用AFNetWork下载在服务器的js文件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:jsUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  NSURL *documentsDirectoryURL = FilePath;
                                                  //保存到本地 Library/Caches目录下
                                                  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                              }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                  [Hotfix HSDevaluateScript];
                                                  ZEBLog(@"File downloaded to: %@", filePath);
                                              }];
    [downloadTask resume];
    
}

/**
 *  运行下载的JS文件
 */
+ (void)HSDevaluateScript
{
    
    //从本地获取下载的JS文件
    NSURL *p = FilePath;
    //获取内容
    NSString *js = [NSString stringWithContentsOfFile:[p.path stringByAppendingString:@"/template.js"] encoding:NSUTF8StringEncoding error:nil];
    
    //如果有内容
    if (js.length > 0)
    {
        //-------
        //如加密在此处解密js内容
        //----
    
        //运行
        [JPEngine startEngine];
        [JPEngine evaluateScript:js];
    }
    
}

@end
