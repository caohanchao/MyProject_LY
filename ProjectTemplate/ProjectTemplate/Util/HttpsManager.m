//
//  HttpsManager.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "HttpsManager.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Property.h"

@interface HttpsManager()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation HttpsManager


#pragma mark - 创建HttpsManager单例对象
+ (nonnull HttpsManager *)sharedManager {
    
    static HttpsManager *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

#pragma mark - getter
- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        // 超时时间
        _httpSessionManager.requestSerializer.timeoutInterval = 30.f;
        
        [_httpSessionManager setSecurityPolicy:[LZXHelper customSecurityPolicy]];
        
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        // 上传普通格式s
        _httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        // 声明获取到的数据格式
        // AFN不会解析,数据是data，需要自己解析
        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return _httpSessionManager;
}

#pragma mark - Public Method
- (void)get:(NSString *)urlString parameters:(NSDictionary *)param progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable response))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    [self.httpSessionManager GET:urlString parameters:param progress:^(NSProgress * _Nonnull progress) {
        // 这里可以获取到目前数据请求的进度
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        failureBlock(task, error);
    }];
}

- (void)post:(NSString *)urlString parameters:(NSDictionary *)param progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    if([param isKindOfClass:[NSMutableDictionary class]]){
        NSMutableDictionary *temp = (NSMutableDictionary *)param;
        temp[@"osType"] = @"ios";
    }

    [self.httpSessionManager POST:urlString parameters:param
         progress:^(NSProgress * _Nonnull progress) {
             // 这里可以获取到目前数据请求的进度
             progressBlock(progress);
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // 请求成功
             successBlock(task, responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // 请求失败
             failureBlock(task, error);
         }];
    
}
- (void)downloadImage:(NSString *)urlString
        progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock
     destination:(nonnull NSURL *_Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse)) destinationBlock
completionHandler:(void(^)(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error)) completionHandlerBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {

        NSURL *filePath = [ZEBCache originalImageCacheUrlStringUrl:urlString];
        return filePath;
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了
        NSLog(@"*****************  Download filePath %@  *********************", filePath);
        completionHandlerBlock(response, filePath, error);
    }];
    
    [downloadTask resume];
    
}

- (void)download:(NSString *)urlString
        progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock
     destination:(nonnull NSURL *_Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse)) destinationBlock
completionHandler:(void(^)(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error)) completionHandlerBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        NSURL *filePath = [ZEBCache videoCacheUrlString:urlString chatId:chatId];
        return filePath;
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了
        NSLog(@"*****************  Download filePath %@  *********************", filePath);
        completionHandlerBlock(response, filePath, error);
    }];
    
    [downloadTask resume];
    
}
//聊天界面语音下载，由于保存格式不同另写一个
- (void)downloadAudio:(NSString *)urlString
        progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock
     destination:(nonnull NSURL *_Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse)) destinationBlock
completionHandler:(void(^)(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error)) completionHandlerBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        NSURL *filePath = [ZEBCache audioCacheUrlString:urlString chatId:chatId];
        return filePath;
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了
        NSLog(@"*****************  Download filePath %@  *********************", filePath);
        completionHandlerBlock(response, filePath, error);
    }];
    
    [downloadTask resume];
    
}

- (void)upload:(UIImage *)image progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:@"alarm"];
    NSDictionary *paramDict = @{@"token" : @"xxx", @"alarm" : username, @"action" : @"uploadfile"};
    NSString *urlString =  Upload_File_URL;
    [self.httpSessionManager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@.jpg", date];
        // 拼接数据到请求体中
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        [formData appendPartWithFileData:data name:@"fileName" fileName:timeLocal mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        successBlock(task, data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        
        
        failureBlock(task, error);
    }];
}
// 聊天发送图片
- (NSURLSessionUploadTask *)uploadImage:(UIImage *)image progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse, UIImage * _Nullable theImage))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:@"alarm"];
    NSDictionary *paramDict = @{@"token" : @"xxx", @"alarm" : username, @"action" : @"uploadfile"};
    NSString *urlString =  Upload_File_URL;
   return  [self.httpSessionManager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@.jpg", date];
        // 拼接数据到请求体中
        NSData *data = image.imageData;
        [formData appendPartWithFileData:data name:@"fileName" fileName:timeLocal mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        successBlock(task, data, image);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        failureBlock(task, error);
    }];
}
- (void)uploadFile:(NSString *)filePath progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:@"alarm"];
    NSDictionary *paramDict = @{@"token" : @"xxx", @"alarm" : username, @"action" : @"uploadfile"};
    NSString *urlString = Upload_File_URL;
    [self.httpSessionManager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.amr", date];
        // 拼接数据到请求体中
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"fileName" fileName:fileName mimeType:@"image/png/file" error:nil];
    } progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        successBlock(task, data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

- (void)uploadFilesWithURL:(NSString *)fileURL  withFileName:(NSString *)fileName progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:@"alarm"];
    NSDictionary *paramDict = @{@"token" : @"xxx", @"alarm" : username, @"action" : @"uploadfile"};
    NSString *urlString = Upload_File_URL;
    [self.httpSessionManager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.amr", date];
        // 拼接数据到请求体中
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:fileURL] name:@"fileName" fileName:fileName mimeType:@"image/png/file" error:nil];
    } progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        successBlock(task, data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

- (void)uploadTwo:(UIImage *)image progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:@"alarm"];
    if (username==nil) {
        username=@"";
    }
    NSDictionary *paramDict = @{@"token" : @"xxx", @"alarm" : username, @"action" : @"uploadfile"};
    NSString *urlString =  Upload_File_URLTwo;
    [self.httpSessionManager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@.jpg", date];
        // 拼接数据到请求体中
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        [formData appendPartWithFileData:data name:@"fileName" fileName:timeLocal mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        successBlock(task, data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        failureBlock(task, error);
    }];
}

/**
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */

-(void)uploadVideo:(NSURL *)videoPath progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock
{
    
    /**创建日期格式化器*/
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    
    /**转化后直接写入Library---caches*/
    NSString *  videoWritePath = [NSString stringWithFormat:@"output_%@.mp4",[formatter stringFromDate:[NSDate date]]];
    

    [self compressVideoWithVideoURL:videoPath savedName:videoWritePath completion:^(NSString *savedPath) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *username = [user objectForKey:@"alarm"];
        NSDictionary *paramDict = @{@"token" : @"xxx", @"alarm" : username, @"action" : @"uploadfile"};
        NSString *urlString = Upload_File_URL;
        
        [self.httpSessionManager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //获得沙盒中的视频内容
            
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:savedPath] name:@"fileName" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadVideo progress");
            progressBlock(uploadProgress);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSLog(@"uploadVideo success");
            successBlock(task, responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"uploadVideo failure");
            failureBlock(task, error);
            
        }];

    }];
    
}

// 压缩并导出视频
- (void)compressVideoWithVideoURL:(NSURL *)videoURL
                        savedName:(NSString *)savedName
                       completion:(void (^)(NSString *savedPath))completion {
    // Accessing video by URL
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:AVAssetExportPresetMediumQuality]) {
    
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset  presetName:AVAssetExportPresetMediumQuality];
        
        NSString *doc = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *folder = [doc stringByAppendingPathComponent:@"HYBVideos"];
        BOOL isDir = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
        if (!isExist || (isExist && !isDir)) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error == nil) {
                NSLog(@"目录创建成功");
            } else {
                NSLog(@"目录创建失败");
            }
        }
        
        NSString *outPutPath = [folder stringByAppendingPathComponent:savedName];
        session.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^{
            if ([session status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSDictionary *attrs = [fileManager attributesOfItemAtPath:[session.outputURL path] error: NULL];
                        CGFloat sizeInMB = [attrs fileSize]/(1024*1024);
                        NSString *videoSize = [NSString stringWithFormat:@"%.2fM", sizeInMB];
                        
                        NSLog(@"videoSize is %@, videoUrl is %@", videoSize, [session.outputURL path]);
                        completion([session.outputURL path]);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil);
                    }
                });
            }
        }];
    }
}
+ (AFNetworkReachabilityStatus)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      //未知
     AFNetworkReachabilityStatusNotReachable     = 0,       //无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       //蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       //WiFi
     };
     
    __block AFNetworkReachabilityStatus aStatus;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        aStatus = status;
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
                
            default:
                break;
        }
        
    }] ;
    
    return aStatus;
}
- (void)cancelAllOperations {
    //取消所有的网络请求
    [self.httpSessionManager.operationQueue cancelAllOperations];
}
@end
