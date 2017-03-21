//
//  UIImage+UIImageScale.h
//  ProjectTemplate
//
//  Created by chc on 16/11/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)



/**
 按比例缩放

 @param scale 缩放比例
 @return //按比例缩放图像
 */
- (UIImage*)imageCompressWithScale:(float)scale;
/**
 //截取部分图像

 @param rect 截取的尺寸
 @return //截取部分图像
 */
- (UIImage *)getSubImage:(CGRect)rect;

/**
 //等比例缩放

 @param size 等比的高宽
 @return //等比例缩放
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 指定宽度按比例缩放

 @param defineWidth 指定宽度
 @return 指定宽度按比例缩放
 */
- (UIImage *)imageCompressForWidth:(CGFloat)defineWidth;
//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
- (UIImage *)imageCompressFortargetSize:(CGSize)size;

/**
 图片压缩

 @param maxFileSize 限定的图片大小
 @return 返回处理后的图片
 */
- (UIImage *)compressionImageToDataMaxFileSize:(NSInteger)maxFileSize;

/**
 聊天发原图的压缩

 @return 返回处理后的图片
 */
- (UIImage *)newOriginalOfChat;
@end
