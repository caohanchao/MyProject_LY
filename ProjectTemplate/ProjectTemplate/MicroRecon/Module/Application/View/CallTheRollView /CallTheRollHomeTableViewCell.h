//
//  CallTheRollHomeTableViewCell.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallTheRollDetailModel.h"

typedef NS_ENUM(NSInteger, CallTheRallType) {
    WillCallTheRall,            //待点名
    CallingTheRall,              //点名中
    CalledTheRall,               //点名完成
    CloseTheTaskOfCallTheRall,    //关闭点名
};


typedef void(^CallTheRollHomeCallBack)(id object ,BOOL isSwitchOn,NSString *reportId);

@interface CallTheRollHomeTableViewCell : UITableViewCell


/**
 初始化cell

 @param model 数据模型
 @param type 点名类型
 @param mode 是否是自己创建或者接收
 @param callback 回调
 */
- (void)configWithModel:(CallTheRollListDetailModel *)model withCallRollType:(CallTheRallType)type withReceiveOrCreateMode:(NSInteger)mode withCallBack:(CallTheRollHomeCallBack)callback;


@end
