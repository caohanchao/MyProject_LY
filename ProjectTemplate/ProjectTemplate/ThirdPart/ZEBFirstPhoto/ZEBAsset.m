//
//  ZEBAsset.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBAsset.h"
#import "ALAsset+ZEB.h"
#import "PHAsset+ZEB.h"

@implementation ZEBAsset
- (instancetype _Nonnull)initWithALAsset:(ALAsset * _Nonnull)asset {
    return [self initWithCreation:asset.createTimeInterval image:asset.originalImage];
}
- (instancetype _Nonnull)initWithPHAsset:(PHAsset * _Nonnull)asset image:(UIImage * _Nonnull)image {
    return [self initWithCreation:asset.creationDate.timeIntervalSince1970 image:image];
}
- (instancetype _Nonnull)initWithCreation:(NSTimeInterval)creation image:(UIImage * _Nonnull)image {
    if (self = [super init] ) {
        _image = image;
        _creationTimeInterval = creation;
    }
    return self;
}
@end
