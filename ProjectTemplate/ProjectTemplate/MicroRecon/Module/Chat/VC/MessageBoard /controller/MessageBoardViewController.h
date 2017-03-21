//
//  MessageBoardViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBoardViewController : UIViewController

@property (nonatomic, copy) NSString *mark_id; // 可能是嫌疑人id,或者标记id,或者案发地id
@property (nonatomic, copy) NSString *type; // "0" 嫌疑人; "1"标记; "2"案发地  
@end