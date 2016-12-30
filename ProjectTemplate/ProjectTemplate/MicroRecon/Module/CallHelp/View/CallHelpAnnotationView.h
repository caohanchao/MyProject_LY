//
//  CallHelpAnnotationView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CallHelpAnnotationView : MAAnnotationView

- (void)addPulsingHaloLayer;
- (void)removePulsingHaloLayer;

- (void)showPulsingHaloLayer;
- (void)dissmissPulsingHaloLayer;
@end
