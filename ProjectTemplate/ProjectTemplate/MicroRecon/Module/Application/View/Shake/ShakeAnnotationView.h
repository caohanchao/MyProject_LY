//
//  ShakeAnnotationView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class ShakeAnnotation;

@interface ShakeAnnotationView : MAAnnotationView


@property(nonatomic,weak,readwrite) ShakeAnnotation *aannotation;


@end
