//
//  QRResultGroupController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHATLISTQRRESULT,//消息列表
    CONTACTQRRESULT,//通讯录
    APPLICATIONQRRESULT,//应用
    OTHERQRRESULT//其它
} QRRESULYTYPE;

@interface QRResultGroupController : UIViewController

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *gname;
@property (nonatomic, copy) NSString *gtype;
@property (nonatomic, copy) NSString *otherAlarm;

@property (nonatomic, assign) QRRESULYTYPE myType;

@end
