//
//  CustomAnnotationView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class CustomCalloutView;
@class ZAnnotation;

@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, strong,readwrite) CustomCalloutView *calloutView;

@property(nonatomic,weak,readwrite)ZAnnotation *aannotation;
@end
