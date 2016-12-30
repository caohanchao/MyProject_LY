//
//  ALAsset+ZEB.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (ZEB)
- (UIImage *)thumbnailImage;
- (UIImage *)originalImage;
- (NSTimeInterval)createTimeInterval;
- (NSURL *)assetURL;
@end
