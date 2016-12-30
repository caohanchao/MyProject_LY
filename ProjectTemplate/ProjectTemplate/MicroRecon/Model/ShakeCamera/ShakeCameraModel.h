//
//  ShakeCameraModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ShakeCameraModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *ADDRESS;
@property (nonatomic, nonnull, copy) NSString *CGH;
@property (nonatomic, nonnull, copy) NSString *FJID;
@property (nonatomic, nonnull, copy) NSString *FL;
@property (nonatomic, nonnull, copy) NSString *gps_h;
@property (nonatomic, nonnull, copy) NSString *gps_w;
@property (nonatomic, nonnull, copy) NSString *IP;
@property (nonatomic, nonnull, copy) NSString *NAME;
@property (nonatomic, nonnull, copy) NSString *OBJECTID;
@property (nonatomic, nonnull, copy) NSString *PCSID;
@property (nonatomic, nonnull, copy) NSString *PHONE;
@property (nonatomic, nonnull, copy) NSString *PNAME;

@property (nonatomic, nonnull, copy) NSString *distance;
@property (nonatomic, assign) NSInteger udid;
@end
