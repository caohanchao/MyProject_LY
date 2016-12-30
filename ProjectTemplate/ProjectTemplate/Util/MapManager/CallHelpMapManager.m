//
//  CallHelpMapManager.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpMapManager.h"

static MAMapView *_mapView = nil;

@implementation CallHelpMapManager


//创建单利
+ (MAMapView *)shareMAMapView {
    
    @synchronized(self) {
        
        if (_mapView == nil) {
            CGRect frame = [[UIScreen mainScreen] bounds];
            _mapView = [[MAMapView alloc] initWithFrame:frame];
            _mapView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            // _mapView.showsUserLocation = YES;
            //      _mapView.rotateEnabled = YES;
            //      _mapView.rotateCameraEnabled = YES;
            //   _mapView.zoomEnabled = YES;
        }
        _mapView.frame = [UIScreen mainScreen].bounds;
        return _mapView;
    }
}


//重写allocWithZone保证分配内存alloc相同
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        
        if (_mapView == nil) {
            _mapView = [super allocWithZone:zone];
            return _mapView; // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

//保证copy相同
+ (id)copyWithZone:(NSZone *)zone {
    return _mapView;
}




@end
