//
//  ZEBCache.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBCache.h"

#define CacheFilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
static NSTimeInterval cacheTime =  (double)604800;

@implementation ZEBCache
//视频缓存的路径
+ (NSURL *)videoCacheUrlString:(NSString *)urlString chatId:(NSString *)chatId{
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,VideoscachePath(),MD5Hash(chatId)];

    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
     NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@/%@.mp4",directoryPath,MD5Hash(urlString)]];
    ZEBLog(@"%@",urlPath);
    return urlPath;
}
//语音缓存的路径
+ (NSURL *)audioCacheUrlString:(NSString *)urlString chatId:(NSString *)chatId {
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,AudioscachePath(),MD5Hash(chatId)];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@/%@.amr",directoryPath,MD5Hash(urlString)]];
    ZEBLog(@"%@",urlPath);
    return urlPath;
}

//清空所有视频缓存
+ (void)clearVideoCaches {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",cachesDirectory,VideoscachePath()];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    }
    
}
//删除指定消息的视频缓存
+ (void)clearVideoCachesChatId:(NSString *)chatId {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,VideoscachePath(),MD5Hash(chatId)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    }

}
//将视频文件移动
+ (BOOL)moveItemAtPath:(NSURL *)url1 toPath:(NSURL *)url2 {
    NSError *error = nil;
    if ([[NSFileManager defaultManager] moveItemAtURL:url1 toURL:url2 error:&error]) {
        return YES;
    }
    ZEBLog(@"%@",[error description]);
    return NO;
}
//图片缓存的路径
+ (void)imageCacheUrlString:(UIImage *)image alarm:(NSString *)alarm {

    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,ImagescachePath(),AvatarscachePath()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",directoryPath,MD5Hash(alarm)];
    ZEBLog(@"%@-------------%@",image,imagePath);
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}
//获取缓存图片
+ (UIImage *)imageCacheAlarm:(NSString *)alarm {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@/%@.png",cachesDirectory,ImagescachePath(),AvatarscachePath(),MD5Hash(alarm)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:directoryPath]];
        return image;
    }
    return [UIImage imageNamed:@"ph_s"];
}
//删除指定消息的图片缓存
+ (void)clearImageCaches {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,ImagescachePath(),AvatarscachePath()];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    }
    
}
//判断该图片是否存在
+ (BOOL)imageFileExistsAtAlarm:(NSString *)alarm {

    NSError *error = nil;
    BOOL ret ;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@/%@.png",cachesDirectory,ImagescachePath(),AvatarscachePath(),MD5Hash(alarm)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        ret = YES;
    }
    return ret;
}
//我的二维码缓存的路径
+ (void)nyCodeCacheImage:(UIImage *)image alarm:(NSString *)alarm {
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",cachesDirectory,myCodecachePath()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",directoryPath,MD5Hash(alarm)];
    ZEBLog(@"%@",imagePath);
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}
//获取缓存我的二维码
+ (UIImage *)myCodeCacheAlarm:(NSString *)alarm {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@.png",cachesDirectory,myCodecachePath(),MD5Hash(alarm)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:directoryPath]];
        return image;
    }
    return nil;
}
//判断该我的二维码是否存在
+ (BOOL)myCodeFileExistsAtAlarm:(NSString *)Alarm {
    
    NSError *error = nil;
    BOOL ret ;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@.png",cachesDirectory,myCodecachePath(),MD5Hash(Alarm)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        ret = YES;
    }
    return ret;
}
//群组二维码缓存的路径
+ (void)groupCodeCacheImage:(UIImage *)image gid:(NSString *)gid {
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",cachesDirectory,groupCodecachePath()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",directoryPath,MD5Hash(gid)];
    ZEBLog(@"%@",imagePath);
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

//获取缓存群组二维码
+ (UIImage *)groupCodeCacheGid:(NSString *)gid {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@.png",cachesDirectory,groupCodecachePath(),MD5Hash(gid)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:directoryPath]];
        return image;
    }
    return nil;
}
//判断该二维码是否存在
+ (BOOL)groupCodeFileExistsAtGid:(NSString *)gid {
    
    NSError *error = nil;
    BOOL ret ;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@.png",cachesDirectory,groupCodecachePath(),MD5Hash(gid)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        ret = YES;
    }
    return ret;

}
//通过url 删除文件
+ (BOOL)removeFileForFilePath:(NSURL *)filePath {
    
    BOOL ret ;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *zipFilePath = [filePath path];// 将NSURL转成NSString
    
    if([fileManager fileExistsAtPath:zipFilePath]){
       ret = [fileManager removeItemAtPath:zipFilePath error:nil];
    }
    return ret;
}
+ (void) resetCache {
    [[NSFileManager defaultManager] removeItemAtPath:[ZEBCache cacheDirectory] error:nil];
}
+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    return 0;
    
}
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName; long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [ZEBCache fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
+ (NSString*) cacheDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"FTWCaches"];
    return cacheDirectory;
}

+ (NSData*) objectForKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            return data;
        }
    }
    return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSError *error;
    @try {
        [data writeToFile:filename options:NSDataWritingAtomic error:&error];
    }
    @catch (NSException * e) {
        //TODO: error handling maybe
    }
}

                                     
                                              
@end
