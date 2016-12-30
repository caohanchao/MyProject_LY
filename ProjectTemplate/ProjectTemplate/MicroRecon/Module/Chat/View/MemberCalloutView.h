//
//  MemberCalloutView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCalloutWidth   55   // 气泡宽度80.0

#define kCalloutHeight  60     // 气泡高度95.0

#define kArrorHeight    10       // 底部距离高度15
@interface MemberCalloutView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, copy) NSString *alarm;
@end
