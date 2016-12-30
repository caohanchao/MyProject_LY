//
//  UploadModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UploadModel : MTLModel<MTLJSONSerializing>

// {"resultcode":0,"response":{"md5":"3b6097ba721ce9889021a37a361e0d9d","url":"http:\/\/112.74.129.54\/tax00\/M00\/09\/01\/QUIPAFeV2UyAJktoAKtQ5jWRTDw656.png"},"resultmessage":"成功"}

@property (nonatomic, assign) int resultcode; // 返回码
@property (nonatomic, nonnull, copy) NSString *resultmessage; // 返回信息
@property (nonatomic, nonnull, copy) NSString *url; // 文件在服务器的地址
@property (nonatomic, nonnull, copy) NSString *md5; // md5

+ (nonnull instancetype) uploadWithData:(nonnull NSData *)data;

@end