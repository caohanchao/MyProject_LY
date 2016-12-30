//
//  ShakeAnnotation.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeAnnotation.h"

@implementation ShakeAnnotation


@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}

@end
