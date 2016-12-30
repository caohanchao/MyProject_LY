//
//  ZEBIdentify2Code.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEBIdentify2Code : NSObject

+ (void)detectorQRCodeImageWithSourceImage:(UIImage *)sourceImage isDrawWRCodeFrame:(BOOL)isDrawWRCodeFrame completeBlock:(void(^)(NSArray *resultArray, UIImage *resultImage))completeBlock;

@end
