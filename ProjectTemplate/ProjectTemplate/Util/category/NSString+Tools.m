//
//  NSString+Tools.m
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+Extensions.h"
@implementation NSString (Tools)
NSString * URLEncodedString(NSString *str) {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
NSString * MD5Hash(NSString *aString) {
    if (aString) {
        const char *cStr = [aString UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
        return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]];
    }
    return @"";
}

- (BOOL)isUrl

{
    
    if(self == nil)
        
        return NO;
    
    NSString *url;
    
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        
        url = [NSString stringWithFormat:@"http://%@",self];
        
    }else{
        
        url = self;
        
    }
    
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    return [urlTest evaluateWithObject:url];
    
}


- (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet {
    NSString *returnVal = @"";
     if (val) {
             returnVal = [val stringByTrimmingCharactersInSet:characterSet];
         }
     return returnVal;
 }

- (NSString *)trimWhitespace {
     return [self trim:self trimCharacterSet:[NSCharacterSet whitespaceCharacterSet]]; //去掉前后空格
 }

- (NSString *)trimNewline {
     return [self trim:self trimCharacterSet:[NSCharacterSet newlineCharacterSet]]; //去掉前后回车符
 }

- (NSString *)trimWhitespaceAndNewline{
     return [self trim:self trimCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去掉前后空格和回车符
 }

- (NSString *)trimWithQuoteSymbol {
    NSString *newStr = @"";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
    NSArray *array =  [self componentsSeparatedByCharactersInSet:set];
    newStr = [array componentsJoinedByString:@"\""];
//    NSLog(@"%@",newStr);
    return newStr;
}

- (NSString *)separatedBy:(NSString *)string{

//    NSArray *array = [self  componentsSeparatedByString:@"@"];
//    NSString *postion = [array firstObject];
//    NSArray *array1 = [postion componentsSeparatedByString:@","];
    NSString *str1;
//    NSString *str2;
//    NSString *str3;
    if ([self isContentOfstring:string]) {
        NSArray *array =[self componentsSeparatedByString:string];
        str1 = [array lastObject];
    }
   
    
    return str1;
}

- (BOOL) isContentOfstring:(NSString *)str {
    NSRange range = [self  rangeOfString:str];
    //通过length的值来判断是否查找成功
    if (range.length>0) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)transferredMeaningWithEnter {
    
    NSArray *transArray = @[@"\\a",@"\\b",@"\\f",@"\\n",@"\\r",@"\\t",@"\\v",@"\\'",@"%%"];
    NSArray *arr = @[@"\a",@"\b",@"\f",@"\n",@"\r",@"\t",@"\v",@"\'",@"%"];
    

    NSString *str;
    NSString *tempStr = [self copy];
    for (int i = 0; i < transArray.count; i++) {
        NSString *string = transArray[i];
        NSString *string1 = arr[i];
        
        if ([tempStr isContentOfstring:string]) {
            str =[tempStr stringByReplacingOccurrencesOfString:string withString:string1];
            tempStr = str;
        }
        else {
            str = tempStr;
//            continue;
        }
    }
    return str;
    

    
}
- (NSString *)delSpaceAndNewline {
    
    NSMutableString *mutStr = [NSMutableString stringWithString:self];
    
    NSRange range = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//用str2替换str1
- (NSString *)handleStringReplace:(NSString *)str1 with:(NSString *)str2 {
    if (str2 == nil) {
        
        str2 = @"";
        
    }
    
    
    
    //    //方式一
    
    //    NSMutableString *tempStr = [NSMutableString stringWithString:string];
    
    //    NSRange range = {0,tempStr.length};
    
    //    [tempStr replaceOccurrencesOfString:str1 withString:str2 options:NSLiteralSearch range:range];
    
    //    return tempStr;
    
    
    
    //    //方式二
    
    //    string = [string stringByReplacingOccurrencesOfString:str1 withString:str2];
    
    //    return string;
    
    
    
    
    
    //方式三
    
    NSArray *array = [self componentsSeparatedByString:str1];
    
    NSInteger count = [array count] - 1;
    
    
    
    NSMutableString *tempStr = [NSMutableString stringWithString:self];
    
    for (NSInteger i = 0; i<count; i++) {
        
        NSRange range = [tempStr rangeOfString:str1];
        
        NSInteger location = range.location;
        
        NSInteger length = range.length;
        
        if (location != NSNotFound) {
            
            [tempStr replaceCharactersInRange:NSMakeRange(location, length) withString:str2];
            
        }
        
    }
    
    return tempStr;
    

}
//从str1(包括)，截取字符串到str2(不包括)
- (NSString *)handleStringInterceptFrom:(NSString *)str1 to:(NSString *)str2 {
    if (str1 == nil) {
        
        str1 = @"";
        
    }
    
    if (str2 == nil) {
        
        str2 = @"";
        
    }
    
    NSString *string = self;
    
    NSRange range1 = [string rangeOfString:str1];
    
    NSInteger location1 = range1.location;
    
    if (location1 != NSNotFound) {
        
        string = [string substringFromIndex:location1];
        
    }
    
    
    
    NSRange range2 = [string rangeOfString:str2];
    
    NSInteger location2 = range2.location;
    
    if (location2 != NSNotFound) {
        
        string = [string substringToIndex:location2];
        
    }
    
    
    
    return string;
}
@end
