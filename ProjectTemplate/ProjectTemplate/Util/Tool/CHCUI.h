//
//  CHCUI.h
//  Demo
//
//  Created by chc on 15/12/16.
//  Copyright © 2015年 caohanchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CanCelBlock)(UIAlertAction *action);
typedef void(^DefaultBlock)(UIAlertAction *action);
typedef void(^CHCAlertCompletionBlock)(UIAlertController *alert);

@interface CHCUI : NSObject

+ (UILabel*)createLabelWithbackGroundColor:(UIColor*)bgColor textAlignment:(NSInteger)alignment font:(UIFont *)font textColor:(UIColor*)textColor  text:(NSString*)text;

+ (UIImageView*)createImageWithbackGroundImageV:(NSString*)imageName;

+ (UIButton*)createButtonWithtarg:(id)targ sel:(SEL)sel titColor:(UIColor*)titleColor font:(UIFont*)font  image:(NSString*)imageName backGroundImage:(NSString*)backImage title:(NSString*)title;

+(void)presentAlertStyleDefauleForTitle:(NSString *)title andMessage:(NSString *)message andCancel:(CanCelBlock)selectCancel andDefault:(DefaultBlock )selectDefault andCompletion:(CHCAlertCompletionBlock)completion;

+(void)presentAlertStyleDefauleForTitle:(NSString *)title andMessage:(NSString *)message andCancel:(CanCelBlock)selectCancel andCompletion:(CHCAlertCompletionBlock)completion;

+ (void)presentAlertToCancelWithMessage:(NSString *)message WithObject:(id)obj;
@end
