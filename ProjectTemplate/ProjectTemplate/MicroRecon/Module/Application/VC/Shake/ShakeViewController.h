//
//  ViewController.h
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    Camera,// 摄像头
    Policing,// 警务室
    BaseStation,// 基站
} SHAKETYPE;

@interface ShakeViewController : UIViewController

@end

