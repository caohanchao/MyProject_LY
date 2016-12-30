//
//  JspatchBaseModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseResponseModel.h"
#import "JsPatchModel.h"


@interface JspatchBaseModel : BaseResponseModel


@property (nonatomic, nonnull, strong) JsPatchModel *jsPatch;

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSData *)data;
@end
