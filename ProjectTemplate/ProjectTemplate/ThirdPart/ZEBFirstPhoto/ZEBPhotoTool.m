//
//  ZEBPhotoTool.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBPhotoTool.h"

#import "ALAsset+ZEB.h"
#import "ALAssetsLibrary+ZEB.h"
#import "PHAsset+ZEB.h"

@implementation ZEBPhotoTool
+ (void)latestAsset:(ZEBPhotoCallBack _Nullable)callBack {
    NSLog(@"system -- %@",[UIDevice currentDevice].systemVersion);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {//判断适配
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                PHAsset *asset = [PHAsset latestAsset];
                // 在资源的集合中获取第一个集合，并获取其中的图片
                if (asset) {
                    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                    [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                        ZEBAsset *a = nil;
                        if (imageData) {
                            UIImage * image = [UIImage imageWithData:imageData];
                            a = [[ZEBAsset alloc]initWithPHAsset:asset image:image];
                            NSLog(@"---- %f",a.creationTimeInterval);
                        }
                        if (callBack) {
                            callBack(a);
                        }
                    }];
                } else {
                    if (callBack) {
                        callBack(nil);
                    }
                }
            } else {
                NSLog(@"status %ld",(long)status);
                if (callBack) {
                    callBack(nil);
                }
            }
        }];
    } else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library latestAsset:^(ALAsset * _Nullable asset, NSError * _Nullable error) {
            ZEBAsset *a = nil;
            if (asset) {
                a = [[ZEBAsset alloc]initWithALAsset:asset];
                NSLog(@"---- %f",a.creationTimeInterval);
            } else {
                NSLog(@"---- %@",error.localizedDescription);
            }
            if (callBack) {
                callBack(a);
            }
        }];
    }
}
@end
