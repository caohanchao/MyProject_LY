//
//  MessageDoubleTapViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapMissBlock) (void);

@interface MessageDoubleTapViewController : UIViewController

@property (nonatomic,copy)NSString *textStr;

@property (nonatomic,copy)TapMissBlock tapMissBlock;

@end
