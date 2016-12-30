//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDesModel.h"



@interface MyQRCodeView : UIView

@property (nonatomic,weak)UIImageView *icon;
@property (nonatomic,weak)UILabel *name;
@property (nonatomic,weak)UILabel *address;
// 二维码图片
@property (nonatomic,weak)UIImageView *qrImg;
// 二维码上图片
@property (nonatomic,weak)UIImageView *appIcon;

@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *nameStr;



@property (nonatomic, strong) GroupDesModel *gModel;
@end
