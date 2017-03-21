//
//  ProvinceListAlertView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/13.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "ZEBBubbleView.h"
@class ProvinceListAlertView;

#define HEIGHT_H 200

typedef void(^chooseProvinceBlock)(ProvinceListAlertView *view, NSString *province);

@interface ProvinceListAlertView : ZEBBubbleView

@property (nonatomic, copy) chooseProvinceBlock block;

@end
