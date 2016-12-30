//
//  CHCUI.m
//  Demo
//
//  Created by chc on 15/12/16.
//  Copyright © 2015年 caohanchao. All rights reserved.
//

#import "CHCUI.h"

@implementation CHCUI

+ (UILabel*)createLabelWithbackGroundColor:(UIColor*)bgColor textAlignment:(NSInteger)alignment font:(UIFont *)font textColor:(UIColor*)textColor  text:(NSString*)text{
    UILabel * label = [[UILabel   alloc]init];
    if (bgColor) {
        label.backgroundColor  = bgColor;
    }
    label.userInteractionEnabled = YES;
    label.textAlignment = alignment;
    label.font  = font;
    label.textColor = textColor;
    label.text  =  text;
    
    return label;
}

+ (UIImageView*)createImageWithbackGroundImageV:(NSString*)imageName{
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:imageName];
    return imageV;
}

+ (UIButton*)createButtonWithtarg:(id)targ sel:(SEL)sel titColor:(UIColor*)titleColor font:(UIFont*)font  image:(NSString*)imageName backGroundImage:(NSString*)backImage title:(NSString*)title{
    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:titleColor forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    bt.titleLabel.font = font;
    [bt addTarget:targ action:sel forControlEvents:UIControlEventTouchUpInside];
    
    
    return bt;

}


+(void)presentAlertStyleDefauleForTitle:(NSString *)title andMessage:(NSString *)message andCancel:(CanCelBlock)selectCancel andDefault:(DefaultBlock )selectDefault andCompletion:(CHCAlertCompletionBlock)completion
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
        selectCancel(action);
        //            NSLog(@"返回");
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        selectDefault(action);
        //            NSLog(@"确认");
    }];
    [alert addAction:action1];
    [alert addAction:action2];

    completion(alert);
}

+(void)presentAlertStyleDefauleForTitle:(NSString *)title andMessage:(NSString *)message andCancel:(CanCelBlock)selectCancel andCompletion:(CHCAlertCompletionBlock)completion
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
        selectCancel(action);
        //            NSLog(@"返回");
    }];

    [alert addAction:action1];

    completion(alert);
}

+ (void)presentAlertToCancelWithMessage:(NSString *)message WithObject:(id)obj {
    [self presentAlertStyleDefauleForTitle:@"温馨提示" andMessage:message andCancel:^(UIAlertAction *action) {
        
    } andCompletion:^(UIAlertController *alert) {
        [obj presentViewController:alert animated:YES completion:nil];
    }];
}

@end
