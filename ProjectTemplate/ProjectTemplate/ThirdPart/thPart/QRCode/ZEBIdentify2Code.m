//
//  ZEBIdentify2Code.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBIdentify2Code.h"

@implementation ZEBIdentify2Code
/**
 *  识别一个图片中所有的二维码, 获取二维码内容
 *
 *  @param sourceImage       需要识别的图片
 *  @param isDrawWRCodeFrame 是否绘制识别到的边框
 *  @param completeBlock     (识别出来的结果数组, 识别出来的绘制二维码图片)
 */
+ (void)detectorQRCodeImageWithSourceImage:(UIImage *)sourceImage isDrawWRCodeFrame:(BOOL)isDrawWRCodeFrame completeBlock:(void(^)(NSArray *resultArray, UIImage *resultImage))completeBlock
{
    // 0.创建上下文
    CIContext *context = [[CIContext alloc] init];
    // 1.创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 2.直接开始识别图片,获取图片特征
    NSArray  *features = [detector featuresInImage:[CIImage imageWithCGImage:sourceImage.CGImage]];
    
    // 3.读取特征
    UIImage *tempImage = sourceImage;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (CIFeature *feature in features) {
        
        CIQRCodeFeature *tempFeature = (CIQRCodeFeature *)feature;
        
        [resultArray addObject:tempFeature.messageString];
        
        if (isDrawWRCodeFrame) {
            tempImage = [self drawQRCodeFrameFeature:tempFeature toImage:tempImage];
        }
    }
    
    // 4.使用block传递数据给外界
    completeBlock(resultArray, tempImage);
    
}
/**
 *  根据一个特征, 对给定图片, 进行绘制边框
 *
 *  @param feature 特征对象
 *  @param toImage 需要绘制的图片
 *
 *  @return 绘制好边框的图片
 */
+ (UIImage *)drawQRCodeFrameFeature:(CIQRCodeFeature *)feature toImage:(UIImage *)toImage
{
    // bounds,相对于原图片的一个大小
    // 坐标系是以左下角为(0, 0)
    CGRect bounds = feature.bounds;
    
    CGSize size = toImage.size;
    // 1.开启图形上下文
    UIGraphicsBeginImageContext(size);
    
    // 2.绘制图片
    [toImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 3.反转上下文坐标系
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -size.height);
    
    // 4.绘制边框
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    path.lineWidth = 12;
    [[UIColor redColor] setStroke];
    [path stroke];
    
    // 4.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
