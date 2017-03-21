//
//  UIImage+Property.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/3.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Property)

@property (nonatomic, copy) NSString *type; // original 原图  
@property (nonatomic, copy) NSString *Bytes; // 图片大小
@property (nonatomic, strong) NSData *imageData; // 图片Data

@end
