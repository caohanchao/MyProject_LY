//
//  ShakeMapViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ShakeMapCamera,// 摄像头
    ShakeMapPolicing,// 警务室
    ShakeMapBaseStation,// 基站
} SHAKEMAPSHAKETYPE;

@interface ShakeMapViewController : UIViewController

@property (nonatomic, assign) SHAKEMAPSHAKETYPE shakeMapType;
@property (nonatomic, strong) NSMutableArray *dataArray;
//添加距离
- (void)addDistance:(NSMutableArray *)arr;
@end
