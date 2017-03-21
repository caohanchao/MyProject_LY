//
//  NotificationCenter.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#ifndef NotificationCenter_h
#define NotificationCenter_h
//拉取历史消息
#define AllMessageReloadNotification @"AllMessageReloadNotification"

#define setupUnreadMessageCount     @"setupUnreadMessageCount" // 修改角标
#define tabbarShowRedLabel     @"tabbarShowRedLabel" // 显示红点
#define tabbarHiddenRedLabel     @"tabbarHiddenRedLabel" // 隐藏红点

//改变tabbar的index
#define SelectTabbarIndex       @"SelectTabbarIndex"

#define PushGroupChatNotification @"PushGroupChatNotification"

#define PushTaskGroupChatNotification @"PushTaskGroupChatNotification"

//其它设备登录
#define DidLoginFromOtherDeviceNotification @"DidLoginFromOtherDeviceNotification"
//通讯录上移隐藏
#define HideTopViewNotification         @"HideTopViewNotification"
////通讯录下移移展示
#define ShowTopViewHideNotification     @"ShowTopViewHideNotification"
//得到组队列表数组
#define GetTeamArrayNotification        @"GetTeamArrayNotification"
//得到添加群成员数组
#define GetAddMemberArrayNotification   @"GetAddMemberArrayNotification"
//刷新组队界面
#define CreateGroupNotification         @"CreateGroupNotification"
//请求群列表
#define ChatListReoloadGrouplistNotification @"ChatListReoloadGrouplistNotification"

#define ChatListReoloadGrouplistNotificationForPullMes @"ChatListReoloadGrouplistNotificationForPullMes"
//刷新消息列表组队名称
#define ReloadChatGroupNameNotification     @"ReloadChatGroupNameNotification"
#define RefreshGroupNameNotification    @"RefreshGroupNameNotification"
//刷新好友ui
#define RefreshFriendsNotification      @"RefreshFriendsNotification"
//组织界面刷新UI
#define RefreshDepaetmentsNotification      @"RefreshDepaetmentsNotification"
//申请加好友的
#define AddFriendNews @"AddFriendNews"
//移除好友提示
#define RemoveTag @"RemoveTag"

//移除阅后即焚消息
#define RemoveFireMessageNotification @"RemoveFireMessageNotification"

//阅后即焚消息已读
#define ReadFireMessageNotification @"ReadFireMessageNotification"

#define ChatControllerRefreshUINotification @"ChatControllerRefreshUINotification"
//添加新成员界面删除通知刷新界面
#define DeleteFRNotification        @"DeleteFRNotification"
#define SearchAddFRNotification        @"SearchAddFRNotification"
//全选
#define AddAllFRNotification        @"AddAllFRNotification"
#define DeleteTMNotification        @"DeleteTMNotification"

#define DeleteUTNotification        @"DeleteUTNotification"

#define DeleteUTNextNotification        @"DeleteUTNextNotification"
#define SearchAddUTNotification        @"SearchAddUTNotification"
//提交组织选中
#define CommitUTSelArrayNotification  @"CommitUTSelArrayNotification"

//广场重新数据请求
#define AllPostNotification  @"AllPostNotification"
#define AllPostNewNotification @"AllPostNewNotification"
//关注重新数据请求
#define FollowPostNotification  @"FollowPostNotification"
#define NewFollowPostNotification  @"NewFollowPostNotification"
//私密重新数据请求
#define PrivacyPostNotification  @"PrivacyPostNotification"
#define NewPrivacyPostNotification  @"NewPrivacyPostNotification"

#define UserCardPostNotification  @"UserCardPostNotification"
#define CricleTitleViewNotification  @"cricleTitleViewNotification"
#define CricleTitleDisViewNotification  @"cricleTitleDisViewNotification"

#define UserCardPostToTopNotification  @"UserCardPostToTopNotification"

//发布动态的图片通知
#define ImageCancelNotification  @"imageCancelNotification"
#define ImageCancelShowNotification  @"imageCancelShowNotification"
#define AddressChangeNotification  @"addressChangeNotification"

//个人主页关注粉丝
#define UserFollowNotification  @"userFollowNotification"

#define UserFansNotification  @"userFansNotification"

#define HomeTitleViewNotification  @"homeTitleViewNotification"
#define HomeTitleDisViewNotification  @"homeTitleDisViewNotification"

//朋友圈新动态通知
#define CircleNewPostNotification  @"CircleNewPostNotification"
#define DismissPostNotification  @"DismissPostNotification"

#define ImageForwardPostNotification  @"ImageForwardPostNotification"

#define UpdateSystemRemindNotification @"UpdateSystemRemindNotification"


#define IDMPhotoBrowserDismissNotification  @"IDMPhotoBrowserDismissNotification"


//聊天界面chatbar
#define XMFunctionViewShowFaceNotification  @"XMFunctionViewShowFaceNotification"
#define XMFunctionViewShowMoreNotification  @"XMFunctionViewShowMoreNotification"
//长按cell执行CanPerformAction
#define XMNChatMessageCellCanPerformActionNotificationCenter    @"XMNChatMessageCellCanPerformActionNotificationCenter"

//地图添加成员
#define MapAddMemberNotification    @"MapAddMemberNotification"
//地图展示某一成员
#define MapShowMemberNotification    @"MapShowMemberNotification"
//改变地图聊天界面frame
#define MapChatChangeFrameNotification  @"MapChatChangeFrameNotification"
//地图展示事件
#define MapShowEventNotification        @"MapShowEventNotification"
//出现btns
#define MapShowBtnsNotification         @"MapShowBtnsNotification"
//切换任务
#define MapshowOneTaskAnnontationNotification   @"MapshowOneTaskAnnontationNotification"
//群组@人回调的内容通知
#define ChatGroupAtNotification             @"ChatGroupAtNotification"
//搜索结果后通知返回
#define BackToRootController        @"BackToRootController"

#define isMemberSelect        @"isMemberSelect"
#define getArray        @"getTeamArray"
//@人在沙盒保存的警号字段
#define atAlarms         @"atAlarms"
//是否是自动登录
#define AutomaticLogin      @"AutomaticLogin"
//是否是在地图聊天界面
#define IsChatMap       @"IsChatMap"

#define NOTfirst @"NOTfirst"
//存自己的组织类型
#define DEType @"DEType"
#define DEName @"DEName"
//用户警号 用于显示
#define UIUseralarm @"UIUseralarm"
//用户唯一标识 传服务器
#define UserUUID    @"UserUUID"
#endif /* NotificationCenter_h */
