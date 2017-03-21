//
//  NSString+Emoji.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

+ (BOOL)stringContainsEmoji:(NSString *)string;
//过滤表情
+ (NSString *)filterEmoji:(NSString *)string;

+ (BOOL)containEmoji:(NSString *)string;


@end
