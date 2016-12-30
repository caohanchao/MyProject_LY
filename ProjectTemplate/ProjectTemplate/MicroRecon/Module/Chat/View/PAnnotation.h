//
//  PAnnotation.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface PAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@property (nonatomic, copy) NSString *title;//title
@property (nonatomic, copy) NSString *subtitle;//详情
//人头像
@property (nonatomic, strong) UIImage *bgIcon;
/**大头针的图片名*/
@property (nonatomic, strong)UIImage  *icon;

//tag
@property(nonatomic,strong)NSString *tagg;
//唯一标示
@property (nonatomic, copy) NSString *alarm;
@end
