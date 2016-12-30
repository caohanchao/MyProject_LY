//
//  ChatBusiness.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatBusiness : NSObject
//绘制图片水印
+ (UIImage *)addVideoLogo:(UIImage *)image videoTime:(NSString *)videoTimeStr videoSize:(NSString *)videoSizeStr;
#pragma mark - Video Methods
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url;
#pragma mark - 视频时长
+ (NSUInteger)durationWithVideo:(NSURL *)videoUrl;

#pragma mark -
#pragma mark 将拉取的历史消息中带有删除，添加好友的数据将data格式化
+ (void)backChatModel:(chatModel *)iModel;
// 格式化撤回消息
+ (void)backSystemChatmodel:(chatModel *)model;
//拉取历史消息刷新界面
+ (void)getHistoryReloadView:(NSMutableDictionary *)dict  chatModel:(chatModel *)iModel;
//拉取本地历史消息刷新
+ (void)getNewsForDb:(NSMutableDictionary *)dict iComdeModel:(ICometModel *)iModel;

//比较时间间隔
+(BOOL)isTimeCompareWithTime:(NSString *)time WithBtime:(NSString *)bTime;

//处理时间的业务
+(void)timeBusiness:(id)model;

//得到大头针背景图片
+ (UIImage *)getZAnnotationIcon:(NSString *)my_type direction:(NSString *)direction type:(NSString *)type;

#pragma mark -
#pragma mark 得到工作列表的展示图片
+ (UIImage *)getIcon:(NSString *)my_type direction:(NSString *)direction type:(NSString *)type;
//得到标记大头针的背景图或地图中心标记icon
+ (UIImage *)getIntersignZAnnotationIcon:(NSString *)type;
//得到摄像头大头针背景图片或地图中心标记icon
+ (UIImage *)getCameraZAnnotationIcon:(NSString *)type direction:(NSString *)direction;
//格式化摄像头方向
+ (NSInteger)getStandardDircation:(NSInteger)tag;
//返回消息列表消息
+ (NSString *)getLastMessage:(UserlistModel *)model;
//比较 新消息的时间  和  前一条消息的时间  间隔
+(BOOL)isTimeCompareWithATime:(NSString *)atime WithBtime:(NSString *)bTime;

#pragma mark -
#pragma mark 得到草稿箱的展示图片
+ (UIImage *)getIcon:(NSString *)my_type  type:(NSString *)type;
@end
