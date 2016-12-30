//
//  AllCaches.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#ifndef AllCaches_h
#define AllCaches_h
/**
 *  视频路径
 *
 *  @return 视频路径
 */
static inline NSString *VideoscachePath() {
    return @"VideosCaches";
}
/**
 *  语音路径
 *
 *  @return 语音路径
 */
static inline NSString *AudioscachePath() {
    return @"AudiosCaches";
}
/**
 *  图片路径
 *
 *  @return v
 */
static inline NSString *ImagescachePath() {
    return @"ImagesCaches";
}
/**
 *  成员头像
 *
 *  @return 成员头像
 */
static inline NSString *AvatarscachePath() {
    return @"avatars";
}
/**
 *  我的二维码缓存路径
 *
 *  @return 我的二维码缓存路径
 */
static inline NSString *myCodecachePath() {
    return @"MyCode";
}
/**
 *  群二维码缓存路径
 *
 *  @return 群二维码缓存路径
 */
static inline NSString *groupCodecachePath() {
    return @"groupCode";
}
#endif /* AllCaches_h */
