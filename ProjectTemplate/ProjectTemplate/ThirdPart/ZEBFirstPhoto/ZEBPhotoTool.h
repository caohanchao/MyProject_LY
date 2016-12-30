//
//  ZEBPhotoTool.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZEBAsset.h"

typedef void(^ZEBPhotoCallBack)(ZEBAsset *_Nullable asset);

@interface ZEBPhotoTool : NSObject
+ (void)latestAsset:(ZEBPhotoCallBack _Nullable)callBack;
@end
