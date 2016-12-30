//
//  RegisterViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Frist_RegisterVC,
    ForgetPassWord_ResetRegisterVC,
} RegisterVCtype;

@interface RegisterViewController : UIViewController

@property(nonatomic,assign)RegisterVCtype vcType;

@end
