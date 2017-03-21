//
//  CallHelpTopView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT 140

//typedef enum
//{
//    userButtonClickPhone = 0,
//    userButtonClickCancels = 1,
//    userButtonClickSure = 2,
//    
//}userButtonClickNum;
//
//typedef void  (^userthreeButtonClick)(userButtonClickNum type);

@interface CallHelpTopView : UIView

- (void)dissmiss;
- (void)showWithAlarm:(NSString*)alarm;
//@property (nonatomic, copy) userthreeButtonClick block;
//@property (strong, nonatomic) NSArray *userHelpArr;

@end
