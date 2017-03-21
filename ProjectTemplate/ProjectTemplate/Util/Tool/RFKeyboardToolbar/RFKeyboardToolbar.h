//
//  KeyboardToolbar.m
//
//  Created by caohanchao on 17/1/18.
//  Copyright (c) 2017 caohanchao All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RFToolbarButton.h"


@protocol RFKeyboardToolbarDelegate;

typedef enum {
    KeyboardToolBarVoiceStyle = 0,
    KeyboardToolBarPhotoStyle = 1,
    KeyboardToolBarVideoStyle = 2
}TOOLBARSTYLE;


typedef void (^KeyboardToolBar_CallBack) ();



@interface RFKeyboardToolbar : UIView <UITextViewDelegate, UITextFieldDelegate>

+ (nonnull RFKeyboardToolbar *)sharedManager;

@property (nonatomic,weak) id <RFKeyboardToolbarDelegate> delegate;

@property (nonatomic,copy,nonnull)KeyboardToolBar_CallBack toolCallBack;

- (void)addToTextView:(nonnull UITextView *)textView withButtons:(nonnull NSArray *)buttons;

- (void)addToTextView:(nonnull UITextView *)textView withCallBack:(nonnull KeyboardToolBar_CallBack)callBack;
- (void)addToTextView:(nonnull UITextView*)textView withButtons:(nonnull NSArray*)buttons withCallBack:( nonnull KeyboardToolBar_CallBack)callBack;

- (void)addToTextField:(nonnull UITextField*)textField withButtons:(nonnull NSArray*)buttons;




@end



@protocol RFKeyboardToolbarDelegate <NSObject>

- (void)toolBarOfStyle:(TOOLBARSTYLE)style;

@end
