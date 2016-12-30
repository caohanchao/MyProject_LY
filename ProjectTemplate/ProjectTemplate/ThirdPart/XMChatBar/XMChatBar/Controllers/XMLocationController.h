//
//  XMLocationController.h
//  XMChatBarExample
//
//  Created by shscce on 15/8/24.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLocationManager.h"

@protocol XMLocationControllerDelegate <NSObject>

- (void)cancelLocation;
- (void)sendLocation:(NSString *)location locationText:(NSString *)locationText ;

@end

/**
 *  选择地理位置
 */
@interface XMLocationController : UIViewController

@property (weak, nonatomic) id<XMLocationControllerDelegate> delegate;
@property (copy, nonatomic) NSString * locationStr;

@end
