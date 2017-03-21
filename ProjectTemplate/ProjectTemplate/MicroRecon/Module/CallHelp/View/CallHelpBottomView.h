//
//  CallHelpBottomView.h
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/27.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT 160

typedef enum
{
    ButtonClickPhone = 0,
    ButtonClickCancels = 1,
    ButtonClickSure = 2,
    
}ButtonClickNum;

typedef void  (^threeButtonClick)(ButtonClickNum type);

@interface CallHelpBottomView : UIView

- (void)dissmiss;
- (void)showWith:(NSDictionary*)dict;

@property (nonatomic, copy) threeButtonClick block;
@property (nonatomic, assign) double  latitude;//纬度
@property (nonatomic, assign) double  longitude;//经度

@end
