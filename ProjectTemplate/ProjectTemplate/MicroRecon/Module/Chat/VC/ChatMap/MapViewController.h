//
//  MapViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "XMNChatController.h"
#import "ChatView.h"

#define taskId  @"taskId"
#define taskName  @"taskName"
#define chooseAll   @"chooseAll"

@interface MapViewController : UIViewController

@property (nonatomic, assign) BOOL isLocation;
@property (nonatomic, copy) NSString *gname;
- (void)clearMapView;
//释放气泡
- (void)dismiss;
@end
