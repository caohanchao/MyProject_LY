//
//  ChangeUserInfoPhoneController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeUserInfoPhoneController;
@protocol ChangeUserInfoPhoneControllerDelegate <NSObject>

- (void)changeUserInfoPhoneController:(ChangeUserInfoPhoneController *)con phoneNum:(NSString *)pho;

@end
@interface ChangeUserInfoPhoneController : UIViewController

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, weak) id<ChangeUserInfoPhoneControllerDelegate> delegate;

@end
