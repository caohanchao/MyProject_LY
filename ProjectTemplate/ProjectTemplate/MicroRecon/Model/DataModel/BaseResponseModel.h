//
//  BaseResponseModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BaseResponseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, copy) NSString *resultcode; // 返回码
@property (nonatomic, nonnull, copy) NSString *resultmessage; // 返回信息

+ (nonnull instancetype)ResponseWithData:(nonnull NSData *)data ;

@end
