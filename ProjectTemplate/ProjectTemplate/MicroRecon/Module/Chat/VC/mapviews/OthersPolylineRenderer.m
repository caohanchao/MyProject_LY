//
//  OthersPolylineRenderer.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "OthersPolylineRenderer.h"

@implementation OthersPolylineRenderer

- (instancetype)initWithPolyline:(MAPolyline *)polyline {
    
    self = [super initWithPolyline:polyline];
    if (self) {
        self.lineWidth = 8;
       [self loadStrokeTextureImage:[UIImage imageNamed:@"pathguiji_blue"]];
    }
    return self;
}

@end
