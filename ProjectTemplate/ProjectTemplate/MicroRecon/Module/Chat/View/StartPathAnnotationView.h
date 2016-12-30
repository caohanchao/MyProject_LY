//
//  StartPathAnnotationView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class StartAnnotation;

@interface StartPathAnnotationView : MAAnnotationView


@property(nonatomic,weak,readwrite) StartAnnotation *aannotation;


@end
