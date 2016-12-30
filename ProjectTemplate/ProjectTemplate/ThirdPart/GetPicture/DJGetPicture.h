//
//  PersonnelInformationSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/6.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^getPictureBlock)(UIImage *image);

@interface DJGetPicture : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,copy)getPictureBlock pictureBlock;
@property (nonatomic, weak) id controller;
+ (DJGetPicture *)sharedManager;

+ (void)shareGetPicture:(getPictureBlock)block controller:(id)controller;

@end
