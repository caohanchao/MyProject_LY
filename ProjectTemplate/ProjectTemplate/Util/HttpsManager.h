//
//  HttpsManager.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface HttpsManager : NSObject

/**
 * 创建一个HttpsManager单例对象
 */
+ (nonnull HttpsManager *)sharedManager;

/**
 * get请求
 */
- (void)get:(nonnull NSString *)urlString
 parameters:(nonnull NSDictionary *)param
   progress:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock
    success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable response))successBlock
    failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 * post请求
 */
- (void)post:(nonnull NSString *)urlString
  parameters:(nonnull NSDictionary *)param
    progress:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock
     success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock
     failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

/**
 * 下载
 */
- (void)download:(nonnull NSString *)urlString
        progress:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock
     destination:(nonnull NSURL * _Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse)) destinationBlock
completionHandler:(nonnull void(^)(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error)) completionHandlerBlock;
NS_ASSUME_NONNULL_BEGIN//去警告
//语音下载，由于保存格式不同另写一个
- (void)downloadAudio:(NSString *)urlString
             progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock
          destination:(nonnull NSURL *_Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull reponse)) destinationBlock
    completionHandler:(void(^)(NSURLResponse * _Nonnull reponse, NSURL * _Nullable filePath, NSError * _Nullable error)) completionHandlerBlock;
NS_ASSUME_NONNULL_END
/**
 * 上传
 */
NS_ASSUME_NONNULL_BEGIN//去警告
- (void)upload:(UIImage *)image progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;
- (void)uploadTwo:(UIImage *)image progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;
- (void)uploadFile:(NSString *)filePath progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

//- (void)uploadVideoFile:(NSURL *)filePath progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;

-(void)uploadVideo:(NSURL *)videoPath progress:(void(^)(NSProgress * _Nonnull progress)) progressBlock success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock;
NS_ASSUME_NONNULL_END
// 取消所有网络请求
- (void)cancelAllOperations;
@end
