//
//  PullMessageLogic.m
//  ProjectTemplate
//
//  Created by pullShit on 2016.8
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PullMessageLogic.h"
#import "ChatBusiness.h"

@implementation PullMessageLogic

+ (nonnull instancetype)sharedManager {
    
    static PullMessageLogic *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}


- (void) logicPullHistoryMessage:(nonnull void(^)(NSProgress * _Nonnull progress)) progressBlock completion:(PullMSGCompletionBlock)completionBlock {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *qid = [NSString stringWithFormat:@"%ld", [[[DBManager sharedManager] MessageDAO] getMaxQid]];
    NSString *maxQid = [NSString stringWithFormat:@"%ld", [[[DBManager sharedManager] maxQidListSQ] selectmaxQid]];
    
    if ([qid integerValue] < [maxQid integerValue]) {
        qid = maxQid;
    }
    NSString *urlStr = [NSString stringWithFormat:Gethistorymessage_URL,token,qid,alarm];
    
//    paramDict[@"action"] = @"gethistory";
//    paramDict[@"alarm"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
//    paramDict[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    paramDict[@"qid"] = [NSString stringWithFormat:@"%ld", [[[DBManager sharedManager] MessageDAO] getMaxQid]];
    
    [[HttpsManager sharedManager] get:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull progress) {
        progressBlock(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable reponse) {
        
        [self pullMessageCallBack:reponse];
        
        completionBlock(reponse, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(@"拉取历史消息失败", error);
    }];
}

- (void)pullMessageCallBack:(id)reponse {
    
    BaseResponseModel *responseResult=[BaseResponseModel ResponseWithData:reponse];
    if ([responseResult.resultcode integerValue]==0) {
        UserChatModel *user=[UserChatModel UserChatWithData:reponse];
        
        NSMutableArray *messageArray=[NSMutableArray array];
        NSArray *reversedArray=[NSArray new];
        //将数据按照qid排序
        NSArray *results = [user.results sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            chatModel *model1 = obj1;
            chatModel *model2 = obj2;
            NSComparisonResult result = [[NSString stringWithFormat:@"%ld",model1.QID] compare:[NSString stringWithFormat:@"%ld",model2.QID]];
            return result == NSOrderedDescending;
        }];
    
        for (chatModel *model in results) {
            
            ICometModel *iModel = [self chatModelReplacedToICometModel:model];
        
            [ChatBusiness timeBusiness:iModel];
            
            
            
            if ([iModel.cmd isEqualToString:@"1"]) {
                [self performCMD_1:iModel];

            }else if ([iModel.cmd isEqualToString:@"2"]) {
                [self performCMD_2:iModel];
                
            }else if ([iModel.cmd isEqualToString:@"3"]) {
                [self performCMD_3:iModel];

            }else if ([iModel.cmd isEqualToString:@"4"]) {
                [self performCMD_4:iModel];

            }else if ([iModel.cmd isEqualToString:@"5"]) {
                [self performCMD_5:iModel];

            }else if ([iModel.cmd isEqualToString:@"6"]) {
                [self performCMD_6:iModel];

            }
        }
    }
}

- (void)performCMD_1:(ICometModel *)model {
    
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
        // 将消息存入到聊天记录表和消息列表中
        [[[DBManager sharedManager] MessageDAO] insertMessage:model];
        [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            // 激发事件，即通知相应的观察者
            NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
            // 通知消息列表刷新
            [notification postNotificationName:@"ReceiveMessage" object:model];

            if (![[LZXHelper isNullToString:model.cuid] isEqualToString:@""] && [model.sid isEqualToString:[kZEBUserDefaults objectForKey:@"alarm"]] && ([@"P" isEqualToString:model.mtype] || [@"V" isEqualToString:model.mtype])) {
                //通知刷新聊天界面,当视频，图片上传成功
                [notification postNotificationName:@"ImageVideoComing" object:model];
                
            }else {
                // 通知聊天页面刷新
                NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
                
                if (([@"G" isEqualToString:model.type] && [model.rid isEqualToString:chatId] && ![model.sid isEqualToString:[kZEBUserDefaults objectForKey:@"alarm"]]) ||
                    ([@"S" isEqualToString:model.type] && [model.sid isEqualToString:chatId])) {
                    
                    
                    [notification postNotificationName:@"ReceiveChatMessage" object:model];
                    
                }
            }

        });
    }
}

- (void)performCMD_2:(ICometModel *)model {
    
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

- (void)performCMD_3:(ICometModel *)model {
    
    if ([@"A" isEqualToString:model.mtype]) {
        // 将消息存入到聊天记录表和消息列表中
        [[[DBManager sharedManager] MessageDAO] insertMessage:model];

        // 将消息存入到聊天记录表和消息列表中
        [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新组队界面
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotificationForPullMes object:model.rid];

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
                [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotificationForPullMes object:model.rid];
            });

 
            // 将消息存入到聊天记录表和消息列表中
            [[[DBManager sharedManager] MessageDAO] insertMessage:model];

            [[[DBManager sharedManager] UserlistDAO] insertOrUpdateUserlist:model];


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
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotificationForPullMes object:model.rid];
                });
            }

            model.data = tempData;

            //刷新组队界面
            //[[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotificationForPullMesForPullMesForPullMes object:model.rid];
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

        if (([@"G" isEqualToString:model.type] && [model.rid isEqualToString:chatId] && ![model.sid isEqualToString:[kZEBUserDefaults objectForKey:@"alarm"]]) ||
            ([@"S" isEqualToString:model.type] && [model.sid isEqualToString:chatId])) {
            
            
            [notification postNotificationName:@"ReceiveChatMessage" object:model];
            
        }
        
    });
}

- (void)performCMD_4:(ICometModel *)model {
    
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
}

- (void)performCMD_5:(ICometModel *)model {
    
    //将消息存入到聊天记录表和消息列表中
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
            //刷新组队界面
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatListReoloadGrouplistNotificationForPullMes object:model.rid];
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
        }
    });
}

- (void)performCMD_6:(ICometModel *)model {
    
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
}

- (ICometModel *)chatModelReplacedToICometModel:(chatModel *)model {

    ICometModel *iModel = [ICometModel new];
    
    iModel.sid = model.SID;
    iModel.rid = model.RID;
    iModel.headpic = model.HEADPIC;
    iModel.type = model.TYPE;
    iModel.atAlarm = model.ATALARM;
    iModel.cmd = model.CMD;
    iModel.msGid = model.MSGID;
    iModel.time = model.TIME;
    iModel.beginTime = model.beginTime;
    iModel.sname = model.SNAME;
    iModel.qid = model.QID;

    iModel.longitude= model.GPS.H;
    iModel.latitude = model.GPS.W;
    
    iModel.FIRE = model.MSG.FIRE;
    iModel.data = model.MSG.DATA;
    iModel.videopic = model.MSG.VIDEOPIC;
    iModel.mtype = model.MSG.MTYPE;
    iModel.voicetime = model.MSG.VOICETIME;
    iModel.suspectSDataModel = model.MSG.suspectSDataModel;
    iModel.taskFDataModel = model.MSG.taskFDataModel;
    iModel.taskNDataModel = model.MSG.taskNDataModel;
    iModel.taskFDataModel = model.MSG.taskFDataModel;
    
    return iModel;
}


@end
