//
//  ViewController.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>



@class CJFileObjModel;

typedef NS_ENUM(NSUInteger, SelectFileMode) {
    RecentTimeSendFileMode,
    LocalFileMode,
};

@protocol FileSelectVcDelegate <NSObject>
@required
//点击发送的事件
- (void)fileViewControlerSelected:(NSArray <CJFileObjModel *> *)fileModels;
@end
@interface CJFileManagerVC : UIViewController

@property (nonatomic,weak) id<FileSelectVcDelegate> fileSelectVcDelegate;

//默认不预览 NO , 预览请选择YES;
@property (nonatomic,assign) BOOL isReading;

@end


