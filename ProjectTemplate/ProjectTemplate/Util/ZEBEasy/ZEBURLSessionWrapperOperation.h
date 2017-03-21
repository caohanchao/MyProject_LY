//
//  ZEBURLSessionWrapperOperation.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEBURLSessionWrapperOperation : NSOperation

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task;

@end
