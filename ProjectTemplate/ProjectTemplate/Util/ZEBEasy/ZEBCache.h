//
//  ZEBCache.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEBCache : NSObject

// 清除根聊天有关的图片 语音 视频
+ (void)clearAllChat;
//视频缓存的路径
+ (NSString *)videoCacheUrlString:(NSString *)urlString chatId:(NSString *)chatId;
//语音缓存的路径
+ (NSURL *)audioCacheUrlString:(NSString *)urlString chatId:(NSString *)chatId;
//将视频文件移动
+ (BOOL)moveItemAtPath:(NSURL *)url1 toPath:(NSURL *)url2;
//清空所有视频缓存
+ (void)clearVideoCaches;
//删除指定消息的视频缓存
+ (void)clearVideoCachesChatId:(NSString *)chatId;
//高清图片缓存的路径
+ (NSURL *)originalImageCacheUrlStringUrl:(NSString *)url;
//高清图片缓存的路径
+ (void)originalImageCacheUrlString:(UIImage *)image url:(NSString *)url;
//获取缓存高清图片
+ (UIImage *)originalImageCacheUrl:(NSString *)url;
//图片缓存的路径
+ (void)imageCacheUrlString:(UIImage *)image alarm:(NSString *)alarm;
//获取缓存图片
+ (UIImage *)imageCacheAlarm:(NSString *)alarm;
//删除指定消息的图片缓存
+ (void)clearImageCaches;
//判断该图片是否存在
+ (BOOL)imageFileExistsAtAlarm:(NSString *)alarm;
//我的二维码缓存的路径
+ (void)nyCodeCacheImage:(UIImage *)image alarm:(NSString *)alarm;
//获取缓存我的二维码
+ (UIImage *)myCodeCacheAlarm:(NSString *)alarm;
//群组二维码缓存的路径
+ (void)groupCodeCacheImage:(UIImage *)image gid:(NSString *)gid;
//判断该二维码是否存在
+ (BOOL)groupCodeFileExistsAtGid:(NSString *)gid;
//判断该我的二维码是否存在
+ (BOOL)myCodeFileExistsAtAlarm:(NSString *)Alarm;
//获取缓存群组二维码
+ (UIImage *)groupCodeCacheGid:(NSString *)gid;
//通过url 删除文件
+ (BOOL)removeFileForFilePath:(NSURL *)filePath;
+ (NSString*) cacheDirectory ;

+ (void) resetCache;

+ (void) setObject:(NSData*)data forKey:(NSString*)key;

+ (id) objectForKey:(NSString*)key;
+ (long long) fileSizeAtPath:(NSString*)filePath;
+ (float ) folderSizeAtPath:(NSString*) folderPath;

@end
