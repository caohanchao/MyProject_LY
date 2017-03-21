
//  CUrlUtil.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CUrlServer.h"
#import "ICometModel.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "ChatLogic.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SystemSound.h"
#import  "ChatBusiness.h"
#import "PullMessageLogic.h"
@interface CUrlServer()
@property (nonatomic, strong) MessageDAO *messageDAO;
@property (nonatomic, assign) BOOL firstInit;
@end

@implementation CUrlServer

+ (nonnull instancetype)sharedManager {
    
    static CUrlServer *manager = nil;
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

//回调接口
size_t icomet_callback(char *ptr, size_t size, size_t nmemb, void *userdata){
    CUrlServer *server = (__bridge CUrlServer *)userdata;
    
    if(server.firstInit){
        server.firstInit = NO;
        // 获取历史消息
//        [[ChatLogic sharedManager] logicGetHistoryMessage:^(NSProgress * _Nonnull progress) {
//            NSLog(@"getHistoryMessage progress");
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
//            NSLog(@"getHistoryMessage success");
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"getHistoryMessage failuer");
//            server.firstInit = YES;
//        }];
        
        [[PullMessageLogic sharedManager] logicPullHistoryMessage:^(NSProgress * _Nonnull progress) {
            
        } completion:^(id  _Nonnull aResponseObject, NSError * _Nullable anError) {
            if (anError == nil) {
                
            } else {
                server.firstInit = YES;
            }
            
        }];
    }
    
    const size_t sizeInBytes = size*nmemb;

    //不知道为什么model解析不了只能这样处理去判断type
    NSString* s = [[NSString alloc] initWithBytes:ptr length:sizeInBytes encoding:NSUTF8StringEncoding];
    //查找全部匹配的，并替换
    s = [s stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
    s = [s stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
    s = [s stringByReplacingOccurrencesOfString:@"\\\\/" withString:@"/"];
    s = [s transferredMeaningWithEnter];
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"type"] isEqualToString:@"close"]) {
            //自动登录
            if ([[NSUserDefaults standardUserDefaults] boolForKey:AutomaticLogin]) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AutomaticLogin];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                //被挤掉线
                [[NSNotificationCenter defaultCenter] postNotificationName:DidLoginFromOtherDeviceNotification object:nil];
            }
            
            
        }
        
        NSDictionary *dictionary = dict[@"content"];
        //添加消息提示音
        //判断是否是接收消息
        
        if ([dict[@"type"] isEqualToString:@"data"]&&![dictionary[@"SID"]isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]])
            
        {
            TeamsListModel *model = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:dictionary[@"RID"]];
            //判断是否是群组并且是那个群组
            if ([dictionary[@"TYPE"]isEqualToString:@"G"] && ![model.isRemindSet boolValue]) {
                SystemSound *soundManager =[SystemSound sharedManager];
                [soundManager start];

            }
            if ([dictionary[@"TYPE"]isEqualToString:@"S"]) {
                
                SystemSound *soundManager =[SystemSound sharedManager];
                [soundManager start];
 
            }
            
        }
        
    }
    
    ICometModel *model = [ICometModel iCometModelWithBytes:ptr length:sizeInBytes];
    
    //时间显示的规则:
    //在聊天列表中,正常显示第一条消息的时间,第二条消息与第一条消息时间比较,大于一分钟显示时间,小于则不显示时间. 第三条消息时间与第二条消息时间比较,大于一分钟显示,小于则不显示...
    //总结以上规则即是:如果下一条消息与上一条消息的时间间隔超过一分钟以后,则显示时间.反之,则不显示时间
    //注:时间间隔可以调整
    
    [ChatBusiness timeBusiness:model];
    

    if (model && [@"1" isEqualToString:model.cmd]) {
        if ([model.mtype isEqualToString:@"F"]) {
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:[NSString stringWithFormat:@"%ld",(long)model.qid] fire:@"READ"];
                [[NSNotificationCenter defaultCenter]postNotificationName:ChatControllerRefreshUINotification object:nil];
            });
        }
        else
        {
            [[[DBManager sharedManager] uploadingSQ] deleteUploading:model.cuid];
            
//            if ([model.FIRE containsString:@"LOCK"]) {
//                if ([model.mtype isEqualToString:@"S"]||[model.mtype isEqualToString:@"P"]||[model.mtype isEqualToString:@"V"]) {
//                    
//                }else {
//                    // 将消息存入到聊天记录表和消息列表中
//                    [[[DBManager sharedManager] MessageDAO] insertMessage:model];
//                    
//                    [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
//                }
//            }
//            else
//            {
//                // 将消息存入到聊天记录表和消息列表中
//                [[[DBManager sharedManager] MessageDAO] insertMessage:model];
//                
//                [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
//            }
            // 将消息存入到聊天记录表和消息列表中
            [[[DBManager sharedManager] MessageDAO] insertMessage:model];
            
            [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
           
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 激发事件，即通知相应的观察者
                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                
                // 通知消息列表刷新
                [notification postNotificationName:@"ReceiveMessage" object:model];
                
                if (![[LZXHelper isNullToString:model.cuid] isEqualToString:@""] && [model.sid isEqualToString:[kZEBUserDefaults objectForKey:@"alarm"]] && ([@"P" isEqualToString:model.mtype] || [@"V" isEqualToString:model.mtype] ||[@"D" isEqualToString:model.mtype])) {
                    //通知刷新聊天界面,当视频，图片,文件上传成功
                    [notification postNotificationName:@"ImageVideoComing" object:model];
                    
                }else {
                    // 通知聊天页面刷新
                    NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];

                    if ([model.rid isEqualToString:model.sid]) { // 文件助手
                        if (([@"S" isEqualToString:model.type] && [model.sid isEqualToString:chatId] && [[LZXHelper isNullToString:model.cuid] isEqualToString:@""])) {
                            
                            [notification postNotificationName:@"ReceiveChatMessage" object:model];
                            
                        } else if ([@"S" isEqualToString:model.type] ){
                            
                            [notification postNotificationName:@"refreshUIByMessageCuid" object:model];
                            
                        }
                    }else { // 其它消息
                    if (([@"G" isEqualToString:model.type] && [model.rid isEqualToString:chatId] && ![model.sid isEqualToString:[kZEBUserDefaults objectForKey:@"alarm"]]) ||
                        ([@"S" isEqualToString:model.type] && [model.sid isEqualToString:chatId])) {

                        [notification postNotificationName:@"ReceiveChatMessage" object:model];
                        
                    } else if ([@"G" isEqualToString:model.type] ||
                              [@"S" isEqualToString:model.type] ){
                        [notification postNotificationName:@"refreshUIByMessageCuid" object:model];
                    }
                    }}

            });
        }
        
    } else if (model && [@"2" isEqualToString:model.cmd]) {
        
        if ([@"A" isEqualToString:model.mtype]) {
            [[[DBManager sharedManager] newFriendDAO] addNewFriend:model];
        } else if ([@"E" isEqualToString:model.mtype]) {
            [[[DBManager sharedManager] newFriendDAO] agree:model];
        }
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![model.sid isEqualToString:alarm]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AddFriendNews object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:tabbarShowRedLabel object:@"1"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFriendsNotification object:nil];
        });
    }
    else if (model && [@"3" isEqualToString:model.cmd]){
        
        if ([@"A" isEqualToString:model.mtype]) {
            
            // 将消息存入到聊天记录表和消息列表中
            [[[DBManager sharedManager] MessageDAO] insertMessage:model];
            
            // 将消息存入到聊天记录表和消息列表中
            [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新组队界面
                [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotification object:model.rid];
                
            });
        }else if ([@"C" isEqualToString:model.mtype]){
        
            
            [[[DBManager sharedManager] GrouplistSQ] updateGroupName:model.data gid:model.rid];
            
            
        }else {
            
            
            UserInfoModel *iModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
            
            UserAllModel *sModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:model.sid];
            
            BOOL isHaveMe = NO;
            
            NSArray *pAlarmArr = [model.data componentsSeparatedByString:@","];
            NSMutableArray *pNameArr = [NSMutableArray array];
            for (NSString *alarmStr in pAlarmArr) {
                
                UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:alarmStr];
                
                
                if (uModel != nil) {
                    [pNameArr addObject:uModel.RE_name];
                    
                    if ([alarmStr isEqualToString:iModel.alarm]) {
                        isHaveMe = YES;
                    }
                }
            }
            NSString *alarmStrs = [pNameArr componentsJoinedByString:@","];
                
                if ([@"P" isEqualToString:model.mtype]) {
                    
                    NSString *tempData = model.data;
                    NSString *name = @"";
                    if ([iModel.alarm isEqualToString:model.sid]) {
                        name = @"你";
                    }else {
                        name = sModel.RE_name;
                    }
                    if ([name isEqualToString:alarmStrs]) {
                        tempData = [NSString stringWithFormat:@"%@加入群聊",name];
                    }else {
                        tempData = [NSString stringWithFormat:@"%@邀请%@加入群聊",name,alarmStrs];
                    }
                    
                    if (isHaveMe) {
                        if ([name isEqualToString:@"你"]) {
                            tempData = [NSString stringWithFormat:@"你加入群聊"];
                        }else {
                            tempData = [NSString stringWithFormat:@"你被%@加入群聊",name];
                        }
                    }
                    model.data = tempData;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //刷新组队界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotification object:model.rid];
                    });
                    
                    // if (![iModel.alarm isEqualToString:model.sid]) {
                    // 将消息存入到聊天记录表和消息列表中
                    [[[DBManager sharedManager] MessageDAO] insertMessage:model];
                    
                    [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
                    
                    //            }
                    
                    
                }else if ([@"D" isEqualToString:model.mtype]) {
                    
                    NSString *tempData = model.data;
                    NSString *name = @"";
                    if ([iModel.alarm isEqualToString:model.sid]) {
                        name = @"你";
                    }else {
                        name = sModel.RE_name;
                    }
                    
                    if ([name isEqualToString:alarmStrs]) {
                        tempData = [NSString stringWithFormat:@"%@退出了群聊",name];
                    }else {
                        tempData = [NSString stringWithFormat:@"%@将%@移除了群聊",name,alarmStrs];
                    }
                    
                    
                    if (isHaveMe) {
                        [[[DBManager sharedManager] GrouplistSQ] deleteGrouplist:model.rid];
                        tempData = [NSString stringWithFormat:@"你被%@移除群聊",name];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:model.rid];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"GroupDeleteManMotification" object:model.rid];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //刷新组队界面
                            [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotification object:model.rid];
                        });
                    }
                    
                    model.data = tempData;
                    
                    //刷新组队界面
                    //[[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotification object:model.rid];
                    if ([iModel.alarm isEqualToString:model.sid] && isHaveMe ) {//发送者是我 删除人有我 就是我退群
                    }else {
                        // 将消息存入到聊天记录表和消息列表中
                        [[[DBManager sharedManager] MessageDAO] insertMessage:model];
                        
                        [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
                    }
                }
            }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 激发事件，即通知相应的观察者
            NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
            
            // 通知消息列表刷新
            [notification postNotificationName:@"ReceiveMessage" object:model];
            
            //修改群名称
            if ([model.mtype isEqualToString:@"C"]) {
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"gName"] = model.data;
                param[@"gid"] = model.rid;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:CreateGroupNotification object:model.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadChatGroupNameNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshGroupNameNotification object:param];
            }
            

            // 通知聊天页面刷新
            NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
            
            if ([model.rid isEqualToString:model.sid]) { // 文件助手
                if (([@"S" isEqualToString:model.type] && [model.sid isEqualToString:chatId] && [[LZXHelper isNullToString:model.cuid] isEqualToString:@""])) {
                    
                    [notification postNotificationName:@"ReceiveChatMessage" object:model];
                    
                } else if ([@"S" isEqualToString:model.type] ){
                    
                    [notification postNotificationName:@"refreshUIByMessageCuid" object:model];
                    
                }
            }else { // 其它消息
            if (([@"G" isEqualToString:model.type] && [model.rid isEqualToString:chatId] && ![model.sid isEqualToString:[kZEBUserDefaults objectForKey:@"alarm"]]) ||
                ([@"S" isEqualToString:model.type] && [model.sid isEqualToString:chatId])) {
                
                
                [notification postNotificationName:@"ReceiveChatMessage" object:model];
                
            }else if ([@"G" isEqualToString:model.type] ||
                      [@"S" isEqualToString:model.type] ){
                [notification postNotificationName:@"refreshUIByMessageCuid" object:model];
            
            }
            }
            
        });
    }else if (model && [@"5" isEqualToString:model.cmd]) {//发起任务
        
        // 将消息存入到聊天记录表和消息列表中
        [[[DBManager sharedManager] MessageDAO] insertMessage:model];
        [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
        
        //将消息存入到标记列表中
        if ([model.mtype isEqualToString:@"N"]) {
            
            [[[DBManager sharedManager] taskMarkSQ] insertTaskMarkFormICometModel:model];
            NSMutableDictionary *parm = [NSMutableDictionary dictionary];
            //将任务添加到地图
            parm[@"workAllModelMark"] = [[WorkAllTempModel alloc] initWithICometModel:model];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{

            [LYRouter openURL:@"ly://mapaddmark" withUserInfo:parm completion:nil];
                
            });
        }else if ([model.mtype isEqualToString:@"T"]) {
            
        }else if ([model.mtype isEqualToString:@"F"]) {
            
        }
        if (![[[DBManager sharedManager] GrouplistSQ] isExistGroupForGid:model.rid]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通知聊天页面刷新
                NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
                
                if (([@"G" isEqualToString:model.type] && [model.rid isEqualToString:chatId])) {
                    
                    //刷新组队界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotification object:model.rid];
                    
                }
                
            });
            
            
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 激发事件，即通知相应的观察者
            NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
            
            // 通知消息列表刷新
            [notification postNotificationName:@"ReceiveMessage" object:model];
            // 通知聊天页面刷新
            NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
            if (([@"G" isEqualToString:model.type] && [model.rid isEqualToString:chatId])) {
                [notification postNotificationName:@"ReceiveChatMessage" object:model];
            }else if ([@"G" isEqualToString:model.type] ||
                      [@"S" isEqualToString:model.type] ){
                [notification postNotificationName:@"refreshUIByMessageCuid" object:model];
            }
        });
        
        
    }else if (model && [@"6" isEqualToString:model.cmd]) {
        
        [[[DBManager sharedManager] MessageDAO] insertMessage:model];
        [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
        
        if ([model.mtype isEqualToString:@"P"]) {//战友圈更新提醒
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:CircleNewPostNotification object:nil];
//                [[NSNotificationCenter defaultCenter]postNotificationName:UpdateSystemRemindNotification object:model];
                
            });
        }else if ([model.mtype isEqualToString:@"O"]) {//上线提醒
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:UpdateSystemRemindNotification object:model];
                
            });
        }
        
    }else if (model && [@"4" isEqualToString:model.cmd]) {//各种提醒
        
        if ([model.mtype isEqualToString:@"8"]||[model.mtype isEqualToString:@"9"])
        {
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [[NSNotificationCenter defaultCenter]postNotificationName:CircleNewPostNotification object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:HomeTitleViewNotification object:nil];
                
            });
        }else if ([model.mtype isEqualToString:@"7"]) {
            
            ICometModel *tempModel = [[[DBManager sharedManager] MessageDAO] selectMessageByMsgid:model.msGid];
            UserInfoModel *iModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
            UserAllModel *sModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:model.sid];
            NSString *messageData = @"";
            
            if ([model.sid isEqualToString:iModel.alarm]) {
                messageData = @"你撤回了一条消息";
            }else {
                messageData = [NSString stringWithFormat:@"%@撤回了一条消息",sModel.RE_name];
            }
            model.data = messageData;
            if (tempModel) {
                //消息的qid替换
                model.qid = tempModel.qid;
                model.headpic = tempModel.headpic;
                model.sname = tempModel.sname;
                //删除原消息
                [[[DBManager sharedManager] MessageDAO] deleteMessageForMsgid:model.msGid];
            }
            
            // 将消息存入到聊天记录表和消息列表中
            [[[DBManager sharedManager] MessageDAO] insertMessage:model];
            [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                // 激发事件，即通知相应的观察者
                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                // 通知聊天页面刷新
                [notification postNotificationName:ChatControllerRefreshUINotification object:nil];
                // 通知消息列表刷新
                [notification postNotificationName:@"chatlistRefreshNotification" object:nil];
            });
        }
        if ([model.mtype isEqualToString:@"3"])
        {//收到一键求助消息
            if (![model.sid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *rsdata = [s dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *rsdict = [NSJSONSerialization JSONObjectWithData:rsdata
                                                                           options:NSJSONReadingMutableContainers error:nil];
                    
                    NSDictionary *dicts =[[NSDictionary alloc] initWithObjectsAndKeys:rsdict,@"receive", nil];
                       [LYRouter openURL:@"ly://CallHelpReceiveHelp" withUserInfo:dicts completion:nil];
                });
            }
        }
        else if ([model.mtype isEqualToString:@"5"])
        {//有人回应了求助
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *userDict =[[NSDictionary alloc] initWithObjectsAndKeys:model.sid,@"userAlarm", nil];
                [LYRouter openURL:@"ly://UserSureHelpCallHelp" withUserInfo:userDict completion:nil];
            });
            
        }
        else if ([model.mtype isEqualToString:@"4"])
        {//有人取消了回应
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *userDict =[[NSDictionary alloc] initWithObjectsAndKeys:model.sid,@"userAlarm", nil];
                [LYRouter openURL:@"ly://CallHelpCancelHelp" withUserInfo:userDict completion:nil];
                 [LYRouter openURL:@"ly://UserCancelCallHelp" withUserInfo:userDict completion:nil];
            });
        }
    }
    
    return sizeInBytes;
}

- (void) cUrlInit {
    _firstInit = YES;
    _isComet = YES;
    _curl = curl_easy_init();
    // Some settings I recommend you always set:
    curl_easy_setopt(_curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY);	// support basic, digest, and NTLM authentication
    curl_easy_setopt(_curl, CURLOPT_NOSIGNAL, 1L);	// try not to use signals
    curl_easy_setopt(_curl, CURLOPT_USERAGENT, curl_version());	// set a default user agent
    // Things specific to this app:
    curl_easy_setopt(_curl, CURLOPT_VERBOSE, 1L);	// turn on verbose logging; your app doesn't need to do this except when debugging a connection
    curl_easy_setopt(_curl, CURLOPT_DEBUGDATA, self);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, self);	// prevent libcurl from writing the data to stdout
    
}

- (void) cUrlSetopt {
    NSLog(@"开始监听...");
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *alarm = [user objectForKey:@"alarm"];
    NSString *iCometUrl = [NSString stringWithFormat:IComet_URL, alarm];
    NSURL *url = [NSURL URLWithString:iCometUrl];
    
    curl_easy_setopt(_curl, CURLOPT_URL, url.absoluteString.UTF8String);	// little warning: curl_easy_setopt() doesn't retain the memory passed into it, so if the memory used by calling url.absoluteString.UTF8String is freed before curl_easy_perform() is called, then it will crash. IOW, don't drain the autorelease pool before making the call
    curl_easy_setopt(_curl, CURLOPT_NOSIGNAL, 1L);  // try not to use signals
    curl_easy_setopt(_curl, CURLOPT_USERAGENT, curl_version()); // set a default user agent
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, icomet_callback);
    
   
    if (_curl) {
        while (_isComet) {
            curl_easy_perform(_curl);
        }
    }
//    curl_easy_cleanup(_curl);
}

- (void) cUrlCleanup {
    curl_easy_cleanup(_curl);
    _isComet = false;
    _curl = nil;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    curl_easy_cleanup(_curl);
}

@end
