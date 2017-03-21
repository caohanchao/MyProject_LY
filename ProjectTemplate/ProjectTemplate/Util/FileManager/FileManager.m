//
//  FileManager.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/6.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "FileManager.h"

@interface FileManager ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation FileManager


+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


- (NSFileManager *)fileManager {
    if (!_fileManager) {
        //创建文件管理器
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

-(void)writeFile:(NSString *)file ByPath:(NSString *)p {
    
    
    //获取路径
    
    //参数NSDocumentDirectory要获取那种路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    //更改到待操作的目录下
    
    [self.fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    
    //获取文件路径
    
    [self.fileManager removeItemAtPath:p error:nil];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:p];
    
    //创建数据缓冲
    NSMutableData *writer = [[NSMutableData alloc] init];
    
    //将字符串添加到缓冲中
    
    [writer appendData:[file dataUsingEncoding:NSUTF8StringEncoding]];
    
    //将其他数据添加到缓冲中
    
    //将缓冲的数据写入到文件中
    
    [writer writeToFile:path atomically:YES];
    
    
}

-(NSString *)readFileByPath:(NSString *)p {
    
    //获取路径
    
    //参数NSDocumentDirectory要获取那种路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    //更改到待操作的目录下
    
    [self.fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    //获取文件路径
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:p];
    
    NSData *reader = [NSData dataWithContentsOfFile:path];
    
    return [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    
}

- (NSString*)getmyAppInfo {
    
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    return appInfo;
}
@end
