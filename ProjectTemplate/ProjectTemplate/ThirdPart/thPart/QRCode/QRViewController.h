//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDesModel.h"

typedef enum : NSUInteger {
    USER,
    GROUP
} UGTYPE;

@interface QRViewController : UIViewController

@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *nameStr;
//@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, strong) GroupDesModel *gModel;
@property (nonatomic, assign) UGTYPE ugType;
@end
