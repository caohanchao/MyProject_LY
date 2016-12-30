//
//  VdAnnotation.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdAnnotation.h"

@implementation VdAnnotation


@synthesize coordinate = _coordinate;
@synthesize date = _date;
@synthesize moment = _moment;
@synthesize LaneNumber = _LaneNumber;

@synthesize bayonetName = _bayonetName;
@synthesize iconUrl = _iconUrl;
@synthesize icon = _icon;
@synthesize myID = _myID;
@synthesize model = _model;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}
@end
