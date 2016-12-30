//
//  NSString+JSONCategories.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "NSString+JSONCategories.h"

@implementation NSString (JSONCategories)

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary {
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

@end
