//
//  LinesignModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LinesignModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *SG_alarm;
@property (nonatomic, nonnull, copy) NSString *SG_audio;
@property (nonatomic, nonnull, copy) NSString *SG_camera_direction;
@property (nonatomic, nonnull, copy) NSString *SG_camera_id;
@property (nonatomic, nonnull, copy) NSString *SG_content;
@property (nonatomic, nonnull, copy) NSString *SG_gid;
@property (nonatomic, nonnull, copy) NSString *SG_gps_h;
@property (nonatomic, nonnull, copy) NSString *SG_gps_position;
@property (nonatomic, nonnull, copy) NSString *SG_gps_w;
@property (nonatomic, nonnull, copy) NSString *SG_picture;
@property (nonatomic, nonnull, copy) NSString *SG_signid;
@property (nonatomic, nonnull, copy) NSString *SG_signtime;
@property (nonatomic, nonnull, copy) NSString *SG_title;
@property (nonatomic, nonnull, copy) NSString *SG_type;
@property (nonatomic, nonnull, copy) NSString *SG_video;
@property (nonatomic, nonnull, copy) NSString *SG_workid;
@end
