//
//  CallHelpAlertView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ButtonClickCancel = 0,
    ButtonClickConfirm = 1,
    
}ButtonClickType;

typedef void  (^buttonClick)(ButtonClickType type);

@interface CallHelpAlertView : UIView

- (void)click:(buttonClick) block;
- (void)show;
- (void)hide;
@end
