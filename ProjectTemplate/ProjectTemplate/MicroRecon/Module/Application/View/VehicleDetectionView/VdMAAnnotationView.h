//
//  VdMAAnnotationView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class VdCalloutView;
@class VdAnnotation;


@interface VdMAAnnotationView : MAAnnotationView

@property (nonatomic, strong,readwrite) VdCalloutView *calloutView;

@property(nonatomic,weak,readwrite) VdAnnotation *aannotation;

@end
