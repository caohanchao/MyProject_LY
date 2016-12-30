//
//  InterinfoModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface InterinfoModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *alarm;
@property (nonatomic, nonnull, copy) NSString *audio;
@property (nonatomic, nonnull, copy) NSString *content;
@property (nonatomic, nonnull, copy) NSString *creattime;
@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *gps_h;
@property (nonatomic, nonnull, copy) NSString *gps_w;
@property (nonatomic, nonnull, copy) NSString *interid;
@property (nonatomic, nonnull, copy) NSString *picture;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic, nonnull, copy) NSString *pushtime;
@property (nonatomic, nonnull, copy) NSString *title;
@property (nonatomic, nonnull, copy) NSString *video;
@property (nonatomic, nonnull, copy) NSString *workid;

@end
