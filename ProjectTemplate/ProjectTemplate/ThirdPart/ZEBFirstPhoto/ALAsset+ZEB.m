//
//  ALAsset+ZEB.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ALAsset+ZEB.h"

@implementation ALAsset (ZEB)
- (UIImage *)thumbnailImage {
    return [[UIImage alloc]initWithCGImage:[self aspectRatioThumbnail]];
}
- (UIImage *)originalImage {
    
    CGImageRef ref = [[self defaultRepresentation] fullScreenImage];
    return [[UIImage alloc]initWithCGImage:ref];
}
- (NSTimeInterval)createTimeInterval {
    return [[self valueForProperty:ALAssetPropertyDate] timeIntervalSince1970];
}

- (NSURL *)assetURL {
    return [self valueForProperty:ALAssetPropertyAssetURL];
}
@end
