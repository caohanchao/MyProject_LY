//
//  WarningView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT 44

@interface WarningView : UIView

@property (nonatomic, copy) NSString *warn;
- (void)show;
- (void)dissmiss;
@end
