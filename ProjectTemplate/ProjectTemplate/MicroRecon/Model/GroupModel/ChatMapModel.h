//
//  ChatMapModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ChatMapModel : MTLModel<MTLJSONSerializing>



@property (nonatomic, nonnull, copy) NSString *alarm;
@property (nonatomic, nonnull, copy) NSString *department;
@property (nonatomic, nonnull, copy) NSString *gps_h;
@property (nonatomic, nonnull, copy) NSString *gps_w;
@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic, nonnull, copy) NSString *name;
@property (nonatomic, nonnull, copy) NSString *phonenum;
@property (nonatomic, nonnull, copy) NSString *status;
@property (nonatomic, nonnull, copy) NSString *time;
@end
