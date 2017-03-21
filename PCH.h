//
//  PCH.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#ifndef PCH_h
#define PCH_h
//发送心跳包
#define Heart_URL @"http://112.74.129.54:13201/heartbeat?osType=ios"
//#define Heart_URL @"http://220.249.118.115:13201/heartbeat?osType=ios"
//
#define Gethistorymessage_URL @"http://112.74.129.54:13201/MicroRecon/1.3/gethistorymessage?token=%@&action=gethistory&qid=%@&alarm=%@"

#define IComet_URL @"http://112.74.129.54:7100/stream?cname=%@&seq=0"
#define Account_Login_URL @"http://112.74.129.54:13201/MicroRecon/1.2/login?osType=ios"

#define NewRegister_URL @"http://112.74.129.54:13201/MicroRecon/1.3/register1?osType=ios"
#define ForgetPassWord_URL @"http://112.74.129.54:13201/MicroRecon/1.3/forgetpasswd?osType=ios"
#define TestCode_URl @"http://112.74.129.54:13201/MicroRecon/1.3/register_new?osType=ios"
#define SendTestCode_URL @"http://112.74.129.54:13201/MicroRecon/1.3/microverify?osType=ios"

//#define GetTrail_URL @"http://112.74.129.54:80/MicroRecon/1.2/gettrail"
#define SaveRoute_URL @"http://112.74.129.54:13201/MicroRecon/1.2/saveroute?ostype=ios"

#define Group_URL @"http://112.74.129.54:13201/MicroRecon/1.1/group?osType=ios"
#define Message_URL @"http://112.74.129.54:13201/MicroRecon/1.3/msg_sendnew?osType=ios"
#define Upload_File_URL @"http://112.74.129.54:13201/MicroRecon/1.1/uploadfile?osType=ios"
#define FriendsLise_URL @"http://112.74.129.54:13201/MicroRecon/1.2/list?osType=ios&action=getuserlist&alarm=%@&key=%@&value=%@&token=%@"
#define TeamList_URL @"http://112.74.129.54:13201/MicroRecon/1.2/list?osType=ios&action=getgrouplist&alarm=%@&token=%@"
#define UnitList_URL @"http://112.74.129.54:13201/MicroRecon/1.2/list?osType=ios&action=getorganlist&alarm=%@&token=%@"
#define FriendDesUrl @"http://112.74.129.54:13201/MicroRecon/1.1/friends?osType=ios&action=getuserinfo&alarm=%@&token=%@"
#define FindUserUrl  @"http://112.74.129.54:13201/MicroRecon/1.1/friends?osType=ios&action=finduser&value=%@&token=%@"
#define FriendAddURL @"http://112.74.129.54:13201/MicroRecon/1.1/friendadd?osType=ios"
#define FriendAgreeURL @"http://112.74.129.54:13201/MicroRecon/1.1/friendagree?osType=ios"
#define Account_URL @"http://112.74.129.54:13201/MicroRecon/1.1/account?osType=ios"

#define Upload_File_URLTwo @"http://112.74.129.54:13201/MicroRecon/1.1/uploadfile2?osType=ios"
#define CreateGroupUrl @"http://112.74.129.54:13201/MicroRecon/1.2/groupcreate?osType=ios"
#define delGroupMemberUrl @"http://112.74.129.54:13201/MicroRecon/1.1/group?osType=ios"
#define GetGroupDesUrl @"http://112.74.129.54:13201/MicroRecon/1.1/group?osType=ios&action=getgroupinfo&alarm=%@&gid=%@&token=%@"
#define ChangeGroupDesUrl @"http://112.74.129.54:13201/MicroRecon/1.1/group?osType=ios"
#define AddGroupMemberUrl @"http://112.74.129.54:13201/MicroRecon/1.1/groupadd?osType=ios"
#define GtUserDesInfoUrl @"http://112.74.129.54:13201/MicroRecon/1.1/info?osType=ios&action=getuserinfo&alarm=%@&token=%@"


//"http://112.74.129.54/circlemain?";   线下战友圈所有接口都是同一个，只是传不同的参数
#define GetCircleList @"http://112.74.129.54:13201/circlemain?osType=ios"


#define ChangeUserInfoUrl @"http://112.74.129.54:13201/MicroRecon/1.1/info?osType=ios"
#define JoinGroupUrl @"http://112.74.129.54:13201/MicroRecon/1.2/usertogroup??osType=ios"
//用户注册
#define RegisterUserInfo @"http://112.74.129.54:13201/MicroRecon/1.2/register?osType=ios"
/**
 拉取聊天消息
 */
#define RequestNewUrl @"http://112.74.129.54:13201/MicroRecon/1.2/getappmessage?osType=ios"
/**
 删除好友
 */
#define DeleteFriendUrl @"http://112.74.129.54:13201/MicroRecon/1.1/friends?osType=ios"
/**
 *  获取单位结构
 *
 *  @return 获取单位结构
 */
#define GetorgbyregisterUrl @"http://112.74.129.54:13201/MicroRecon/1.2/getorgbyregister"
/**
 *  检测热更新
 *
 *  @return 检测热更新下载
 */
#define HotfixJSUrl     @"http://112.74.129.54:13201/MicroRecon/1.2/iosappupdate?osType=ios"
/**
 * 消息转发
 */
#define MSGForwardUrl @"http://112.74.129.54:13201/MicroRecon/1.2/transpond?osType=ios"

/*
 *  切换消息推送
 */
#define SwitchPushMessageUrl @"http://112.74.129.54:13201/MicroRecon/1.3/switchpush?osType=ios"

/**
 *  地图聊天获取在线人数
 *
 *  @return 地图聊天获取在线人数
 */
#define GetGPSUrl   @"http://112.74.129.54:13201/MicroRecon/1.2/position?osType=ios"
/**
 *  地图标注
 *
 *  @return 地图标注
 */
#define MapAnnotationUrl    @"http://112.74.129.54:13201/MicroRecon/1.2/eventlist?osType=ios&action=eventlist&alarm=%@&gid=%@&token=%@"
/**
 *  所有地图标注
 *
 *  @return 所有地图标注
 */
#define GetAllMapAnnotationUrl    @"http://112.74.129.54:13201/MicroRecon/1.2/getrecordbygroup?osType=ios&action=getrecordbygroup&userid=%@&alarm=%@&gid=%@&token=%@"
/**
 *  某个任务地图标注
 *
 *  @return 某个任务地图标注
 */
#define GetMapAnnotationUrl      @"http://112.74.129.54:13201/MicroRecon/1.2/getrecordbyworkid?osType=ios&action=getrecordbyworkid&alarm=%@&workid=%@&token=%@"
///**
// *  某个任务地图标注
// *
// *  @return 某个任务地图标注
// */
//#define GetMapAnnotationUrl      @"http://112.74.129.54:80/MicroRecon/1.2/getallinfo?osType=ios&action=getsign&alarm=%@&cid=%@&token=%@"
/**
 *  获取群任务id
 *
 *  @return 获取群任务id
 */
#define  GetworkbygroupUrl   @"http://112.74.129.54:13201/MicroRecon/1.2/getworkbygroup?osType=ios&action=getworkbygroup&gid=%@&alarm=%@&token=%@"
/**
 *  任务轨迹
 *
 *  @return 任务轨迹
 */
#define MapGettrailbywork   @"http://112.74.129.54:13201/MicroRecon/1.2/gettrailbywork?osType=ios&action=gettraillist&alarm=%@&suspectid=%@&token=%@"
/**
 *  任务列表
 *
 *  @return 任务列表
 */
#define GetSuspectlistUrl   @"http://112.74.129.54:13201/MicroRecon/1.2/suspectlist?osType=ios&action=suspectlist&alarm=%@&type=2&token=%@"

/*
 * 四表合一接口
 */
#define Saverecord_URL @"http://112.74.129.54:13201/MicroRecon/1.2/saverecord?osType=ios"
/*
 * 发布任务
 */
#define PublishTaskURL  @"http://112.74.129.54:13201/MicroRecon/1.2/createsuspect?osType=ios"

/**
 获取留言板列表

 @return 获取留言板列表
 */
#define CommentlistbyrecordUrl @"http://112.74.129.54:13201/MicroRecon/1.3/commentlistbyrecord?osType=ios&alarm=%@&token=%@&mark_id=%@&type=%@"

#define CommenttoRecord @"http://112.74.129.54:13201/MicroRecon/1.3/setcommenttorecord"
/**
 添加留言

 @return  添加留言
 */
#define SetCommentUrl   @"http://112.74.129.54:13201/MicroRecon/1.3/setcommenttorecord?osType=ios"
/**
 消息撤回

 @return  消息撤回
 */
#define MessageRecallUrl @"http://112.74.129.54:13201/MicroRecon/1.3/messagerecall?osType=ios"

/**
 阅后即焚
 
 @return  阅后即焚
 */
#define MessageFirelUrl @"http://112.74.129.54:13201/MicroRecon/1.3/messageburn?osType=ios"

/**
 摇一摇

 @return  摇一摇
 */
#define ShakeUrl    @"http://112.74.129.54:13201/MicroRecon/1.2/sharkgetdata"

#define GetInfoCarUrl @"http://113.57.174.98:13201/fire/getcarinfo?hphm=%@&fromtime=%@&totime=%@&alarm=%@"

/**
 获取轨迹

 @return  获取轨迹
 */
#define ChatMapGetPath  @"http://112.74.129.54:13201/MicroRecon/1.2/gettrail?osType=ios"

/**

 点名详情

 @return 点名详情
 */
#define getReportDetailUrl @"http://112.74.129.54:13201/MicroRecon/1.2/rallcallinfo?osType=ios"
/**
 获取点名列表
 
 @return  获取点名列表
 */
#define GetRallcalllist_URL @"http://112.74.129.54:13201/MicroRecon/1.2/rallcalllist?action=rallcalllist&alarm=%@&token=%@&type=%@"


/**
 激活或者关闭点名

 @return 激活或者关闭点名
 */
#define GetReportActive_URL @"http://112.74.129.54:13201/MicroRecon/1.2/activemanage?action=activemanage&alarm=%@&token=%@&rallcallid=%@&activestate=%@"

/**
发布点名
 
 @return  发布点名
 */
#define CreateAllCallUrl  @"http://112.74.129.54:13201/MicroRecon/1.2/createrallcall?osType=ios"

/**

 编辑点名
 
 @return  编辑点名
 */
#define ChangeAllCallUrl  @"http://112.74.129.54:13201/MicroRecon/1.2/changerallcall?osType=ios"



#define ChangePassword_URL @"http://112.74.129.54:13201/MicroRecon/1.1/account?osType=ios"


//呼叫支援
#define GetHelpUrl @"http://112.74.129.54:13201/MicroRecon/1.2/help?osType=ios"

//取消呼叫支援
#define CancelHelpUrl @"http://112.74.129.54:13201/MicroRecon/1.2/cancelhelp?osType=ios"
//确认支援
#define EnsurHelpUrl @"http://112.74.129.54:13201/MicroRecon/1.2/ensurehelp?osType=ios"

/**
 
 根据日期获取人员列表
 @param date     需要查询的日期
 @param reportId 报道的id
 @return 根据日期获取人员列表
 */
#define getreportuserbydayUrl @"http://112.74.129.54:13201/MicroRecon/1.2/getreportuserbyday?osType=ios&action=getreportuserbyday&alarm=%@&token=%@&rallcallid=%@&day=%@"

#define ReportRall_URL @"http://112.74.129.54:13201/MicroRecon/1.2/toreport?action=toreport&alarm=%@&token=%@&rallcallid=%@&latitude=%@&longitude=%@&position=%@"

//
//#define IComet_URL @"http://220.74.129.54:8100/stream?cname=%@&seq=0"
//#define Account_Login_URL @"http://220.74.129.54/MicroRecon/1.3/login?osType=ios"
//#define Group_URL @"http://220.74.129.54/MicroRecon/1.3/group?osType=ios"
//#define Message_URL @"http://220.74.129.54/MicroRecon/1.3/message?osType=ios"
//#define Upload_File_URL @"http://220.74.129.54/MicroRecon/1.3/uploadfile?osType=ios"
//#define FriendsLise_URL @"http://220.74.129.54:80/MicroRecon/1.3/list?osType=ios&action=getuserlist&alarm=%@&key=%@&value=%@&token=%@"
//#define TeamList_URL @"http://220.74.129.54:80/MicroRecon/1.3/list?osType=ios&action=getgrouplist&alarm=%@&token=%@"
//#define UnitList_URL @"http://220.74.129.54:80/MicroRecon/1.3/list?osType=ios&action=getorganlist&alarm=%@&token=%@"
//#define FriendDesUrl @"http://220.74.129.54:80/MicroRecon/1.3/friends?osType=ios&action=getuserinfo&alarm=%@&token=%@"
//#define FindUserUrl  @"http://220.74.129.54:80/MicroRecon/1.3/friends?osType=ios&action=finduser&value=%@&token=%@"
//#define FriendAddURL @"http://220.74.129.54:80/MicroRecon/1.3/friendadd?osType=ios"
//#define FriendAgreeURL @"http://220.74.129.54:80/MicroRecon/1.3/friendagree?osType=ios"
//#define Account_URL @"http://220.74.129.54/MicroRecon/1.3/account?osType=ios"
//
//
//#define CreateGroupUrl @"http://220.74.129.54/MicroRecon/1.3/groupcreate?osType=ios"
//#define delGroupMemberUrl @"http://220.74.129.54:80/MicroRecon/1.3/group?osType=ios"
//#define GetGroupDesUrl @"http://220.74.129.54:80/MicroRecon/1.3/group?osType=ios&action=getgroupinfo&alarm=%@&gid=%@&token=%@"
//#define ChangeGroupDesUrl @"http://220.74.129.54:80/MicroRecon/1.3/group?osType=ios"
//#define AddGroupMemberUrl @"http://220.74.129.54:80/MicroRecon/1.3/groupadd?osType=ios"
//#define GtUserDesInfoUrl @"http://220.74.129.54:80/MicroRecon/1.3/info?osType=ios&action=getuserinfo&alarm=%@&token=%@"
//
//#define ChangeUserInfoUrl @"http://220.74.129.54:80/MicroRecon/1.3/info?osType=ios"
//#define JoinGroupUrl @"http://220.74.129.54:80/MicroRecon/1.3/usertogroup??osType=ios"
//
///**
// 拉取聊天消息
// */
//#define RequestNewUrl @"http://220.74.129.54:80/MicroRecon/1.3/getappmessage?osType=ios"
///**
// 删除好友
// */
//#define DeleteFriendUrl @"http://220.74.129.54:80/MicroRecon/1.3/friends?osType=ios"

//#define IComet_URL @"http://220.249.118.115:8100/stream?cname=%@&seq=0"
//#define Account_URL @"http://220.249.118.115:13201/MicroRecon/1.2/login?osType=ios"
//#define Group_URL @"http://220.249.118.115:13201/MicroRecon/1.1/group?osType=ios"
//#define Message_URL @"http://220.249.118.115:13201/MicroRecon/1.1/message?osType=ios"
//#define Upload_File_URL @"http://220.249.118.115:13201/MicroRecon/1.1/uploadfile?osType=ios"
//#define FriendsLise_URL @"http://220.249.118.115:13201/MicroRecon/1.1/list?osType=ios&action=getuserlist&alarm=%@&key=%@&value=%@&token=%@"
//#define TeamList_URL @"http://220.249.118.115:13201/MicroRecon/1.2/list?osType=ios&action=getgrouplist&alarm=%@&token=%@"
//#define UnitList_URL @"http://220.249.118.115:13201/MicroRecon/1.2/list?osType=ios&action=getorganlist&alarm=%@&token=%@"
//#define FriendDesUrl @"http://220.249.118.115:13201/MicroRecon/1.1/friends?osType=ios&action=getuserinfo&alarm=%@&token=%@"
//#define FindUserUrl  @"http://220.249.118.115:13201/MicroRecon/1.1/friends?osType=ios&action=finduser&value=%@&token=%@"
//#define FriendAddURL @"http://220.249.118.115:13201/MicroRecon/1.1/friendadd?osType=ios"
//#define FriendAgreeURL @"http://220.249.118.115:13201/MicroRecon/1.1/friendagree?osType=ios"
//#define Account_Reconnect_URL @"http://220.249.118.115:13201/MicroRecon/1.1/account?osType=ios"

#ifdef DEBUG // 处于开发阶段
#define Provider_URL @"http://112.74.129.54:8085/APNSTestProvider/send"
#else   // 处于发布阶段
#define Provider_URL @"http://112.74.129.54:8085/APNSBetaProvider/send"
#endif

#endif /* PCH_h */
