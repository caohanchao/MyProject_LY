//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

@property (nonatomic,copy)void (^QRUrlBlock)(NSString *url);

/**
 1.messageList   2.contact   3.application
 */
@property (nonatomic)NSInteger pageType;

@end
