//
//  NSString+Tools.h
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)
NSString * URLEncodedString(NSString *str);
NSString * MD5Hash(NSString *aString);

- (BOOL)isUrl;
- (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet;
- (NSString *)trimWhitespace;
- (NSString *)trimNewline;
- (NSString *)trimWhitespaceAndNewline;

- (NSString *)trimWithQuoteSymbol;//引用符号

- (NSString *)separatedBy:(NSString *)string;//分割@"@",@","
//转义回车 \\n
- (NSString *)transferredMeaningWithEnter;
// 去掉 \n @" "
- (NSString *)delSpaceAndNewline;
//用str2替换str1
- (NSString *)handleStringReplace:(NSString *)str1 with:(NSString *)str2;
//从str1(包括)，截取字符串到str2(不包括)
- (NSString *)handleStringInterceptFrom:(NSString *)str1 to:(NSString *)str2;
@end
