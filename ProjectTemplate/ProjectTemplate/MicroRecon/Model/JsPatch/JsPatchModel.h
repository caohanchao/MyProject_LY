//
//  JsPatchModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JsPatchModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *appVersion;
@property (nonatomic, nonnull, copy) NSString *jsDetailedInf;
@property (nonatomic, nonnull, copy) NSString *jsUrl;
@property (nonatomic, nonnull, copy) NSString *jsVersion;
@property (nonatomic, nonnull, strong) NSNumber *resultCode;


@property (nonatomic, nonnull, copy) NSString *time;
@end
