//
//  PHAsset+ZEB.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PHAsset+ZEB.h"

@implementation PHAsset (ZEB)
+ (PHAsset *)latestAsset {
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return [assetsFetchResults firstObject];
}
@end
