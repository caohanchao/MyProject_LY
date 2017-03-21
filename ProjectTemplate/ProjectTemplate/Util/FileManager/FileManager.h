//
//  FileManager.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/6.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject


/**
 写入数据

 @param file 内容
 @param p 路径
 */
-(void)writeFile:(NSString *)file ByPath:(NSString *)p;

/**
 读取数据

 @param p 路径
 @return 内容
 */
-(NSString *)readFileByPath:(NSString *)p;

- (NSString*)getmyAppInfo;

+ (instancetype)shareManager;

@end
