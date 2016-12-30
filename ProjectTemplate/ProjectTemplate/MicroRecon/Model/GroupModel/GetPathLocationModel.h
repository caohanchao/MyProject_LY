//
//  GetPathLocationModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GetPathLocationModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *angle;
@property (nonatomic, nonnull, copy) NSString *latitude;
@property (nonatomic, nonnull, copy) NSString *longitude;
@property (nonatomic, nonnull, copy) NSString *time;
@property (nonatomic, nonnull, copy) NSString *type;

@end
