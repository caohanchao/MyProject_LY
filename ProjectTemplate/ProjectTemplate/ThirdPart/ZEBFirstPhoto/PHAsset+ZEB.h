//
//  PHAsset+ZEB.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (ZEB)
/**
 *  获取最新一张图片
 */
+ (PHAsset *)latestAsset;
@end
