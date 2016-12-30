//
//  NSString+JSONCategories.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONCategories)

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary;

@end
