//
//  UIImageView+Cache.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)
//先从本地缓存取 没有再去网络取
- (void)imageGetCacheForAlarm:(NSString *)alarm forUrl:(NSString *)url;
@end
