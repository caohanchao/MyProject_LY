//
//  MemberAnnotationView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class MemberCalloutView;
@class PAnnotation;
@class MemberAnnotationView;

@protocol MemberAnnotationViewDelegate <NSObject>

- (void)memberAnnotationView:(MemberAnnotationView *)view;

@end

@interface MemberAnnotationView : MAAnnotationView
@property (nonatomic, strong,readwrite) MemberCalloutView *calloutView;
@property (nonatomic, weak) id<MemberAnnotationViewDelegate> delegate;
@property(nonatomic,weak,readwrite) PAnnotation *aannotation;
@end
