//
//  GroupDesModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GroupDesModel : MTLModel<MTLJSONSerializing>



@property (nonatomic, nonnull, copy) NSString *count;
@property (nonatomic, nonnull, copy) NSString *description1;
@property (nonatomic, nonnull, copy) NSString *gadmin;
@property (nonatomic, nonnull, copy) NSString *gcreatetime;
@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *gname;
@property (nonatomic, nonnull, copy) NSString *gtype;


@end
