//
//  DisplayContentLogic.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/30.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DisplayContentLogic.h"

@implementation DisplayContentLogic



+ (nonnull instancetype)sharedManager {
    
    static DisplayContentLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}


-(nonnull NSString *)displayContentLogicWithChatType:(nonnull NSString *)chatType withChatID: ( nonnull NSString *)chatId withMessageType:(XMNMessageType)mType  withData:(nonnull NSString *)data
{
    
     NSString *displayContent;
     NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    if ([chatType isEqualToString:@"G"])
    {
         TeamsListModel *tmodel = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:chatId];
        
        //    XMNMessageTypeUnknow = 0 /**< 未知的消息类型 */,
        //    XMNMessageTypeSystem /**< 系统消息 */,
        //    XMNMessageTypeText /**< 文本消息 */,
        //    XMNMessageTypeImage /**< 图片消息 */,
        //    XMNMessageTypeVoice /**< 语音消息 */,
        //    XMNMessageTypeLocation /**< 地理位置消息 */,
        //    XMNMessageTypeVideo /**< 视频消息 */,
        //    XMNMessageTypeReleaseTask /**< 发布任务 */,
        switch (mType)
        {
            case XMNMessageTypeText:
                return [NSString stringWithFormat:@"%@ : %@",tmodel.gname,data];
                break;
            case XMNMessageTypeImage:
                return [NSString stringWithFormat:@"%@ : [图片]",tmodel.gname];
                break;
            case XMNMessageTypeVoice:
                return [NSString stringWithFormat:@"%@ : [语音]",tmodel.gname];
                break;
            case XMNMessageTypeVideo:
                return [NSString stringWithFormat:@"%@ : [视频]",tmodel.gname];
                break;
            case XMNMessageTypeLocation:
                return [NSString stringWithFormat:@"%@ : [定位]",tmodel.gname];
                break;
            case XMNMessageTypeSystem:
                return [NSString stringWithFormat:@"%@ : [系统消息]",tmodel.gname];
                break;
            case XMNMessageTypeReleaseTask:
                return [NSString stringWithFormat:@"%@ : [任务消息]",tmodel.gname];
                break;
            case XMNMessageTypeFiles:
                return [NSString stringWithFormat:@"%@ : [文件]",tmodel.gname];
                break;
            case XMNMessageTypeUnknow:
                return [NSString stringWithFormat:@"您收到一条消息"];
                break;
                
            default:
                break;
        }
    }
    else if([chatType isEqualToString:@"S"])
    {
        UserInfoModel *fmodel = [[[DBManager sharedManager] userDetailSQ]selectUserDetail];
        switch (mType) {
            case XMNMessageTypeText:
                return [NSString stringWithFormat:@"%@ : %@",fmodel.name,data];
                break;
            case XMNMessageTypeImage:
                return [NSString stringWithFormat:@"%@ : [图片]",fmodel.name];
                break;
            case XMNMessageTypeVoice:
                return [NSString stringWithFormat:@"%@ : [语音]",fmodel.name];
                break;
            case XMNMessageTypeVideo:
                return [NSString stringWithFormat:@"%@ : [视频]",fmodel.name];
                break;
            case XMNMessageTypeLocation:
                return [NSString stringWithFormat:@"%@ : [定位]",fmodel.name];
                break;
            case XMNMessageTypeSystem:
                return [NSString stringWithFormat:@"%@ : [系统消息]",fmodel.name];
                break;
            case XMNMessageTypeFiles:
                return [NSString stringWithFormat:@"%@ : [文件]",fmodel.name];
                break;
            case XMNMessageTypeUnknow:
                return [NSString stringWithFormat:@"您收到一条消息"];
                break;
            default:
                break;
        }
        
    }
    
    
    return @"您收到一条消息";
}


@end
