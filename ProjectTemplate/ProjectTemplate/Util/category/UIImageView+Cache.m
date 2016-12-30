//
//  UIImageView+Cache.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UIImageView+Cache.h"

@implementation UIImageView (Cache)

//先从本地缓存取 没有再去网络取
- (void)imageGetCacheForAlarm:(NSString *)alarm forUrl:(NSString *)url {
    if ([ZEBCache imageFileExistsAtAlarm:alarm]) {
        [self setImage:[ZEBCache imageCacheAlarm:alarm]];
    }else {
        if (!url) {
            [self setImage:[UIImage imageNamed:@"ph_s"]];
        }else {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ph_s"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [ZEBCache imageCacheUrlString:image alarm:alarm];
        }];
        }
    }
}

@end
