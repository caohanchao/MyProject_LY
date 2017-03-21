//
//  OnlineURL.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//
//113.57.174.98
//113.57.174.98
#ifndef OnlineURL_h
#define OnlineURL_h
//发送心跳包
//#define Heart_URL @"http://113.57.174.98:80/heartbeat?osType=ios"
#define Heart_URL @"http://113.57.174.98:13201/heartbeat?osType=ios"
//
#define IComet_URL @"http://113.57.174.98:8100/stream?cname=%@&seq=0"

#define Gethistorymessage_URL @"http://113.57.174.98:13201/MicroRecon/1.3/gethistorymessage?token=%@&action=gethistory&qid=%@&alarm=%@"

#define Account_Login_URL @"http://113.57.174.98:13201/MicroRecon/1.2/login?osType=ios"
#define Group_URL @"http://113.57.174.98:13201/MicroRecon/1.3/group?osType=ios"
#define Message_URL @"http://113.57.174.98:13201/MicroRecon/1.3/msg_sendnew?osType=ios"
#define Upload_File_URL @"http://113.57.174.98:13201/MicroRecon/1.3/uploadfile?osType=ios"
#define FriendsLise_URL @"http://113.57.174.98:13201/MicroRecon/1.2/list?osType=ios&action=getuserlist&alarm=%@&key=%@&value=%@&token=%@"
#define TeamList_URL @"http://113.57.174.98:13201/MicroRecon/1.3/list?osType=ios&action=getgrouplist&alarm=%@&token=%@"
#define UnitList_URL @"http://113.57.174.98:13201/MicroRecon/1.3/list?osType=ios&action=getorganlist&alarm=%@&token=%@"
#define FriendDesUrl @"http://113.57.174.98:13201/MicroRecon/1.3/friends?osType=ios&action=getuserinfo&alarm=%@&token=%@"
#define FindUserUrl  @"http://113.57.174.98:13201/MicroRecon/1.3/friends?osType=ios&action=finduser&value=%@&token=%@"
#define FriendAddURL @"http://113.57.174.98:13201/MicroRecon/1.3/friendadd?osType=ios"
#define FriendAgreeURL @"http://113.57.174.98:13201/MicroRecon/1.3/friendagree?osType=ios"
#define Account_URL @"http://113.57.174.98:13201/MicroRecon/1.3/account?osType=ios"

#define CreateGroupUrl @"http://113.57.174.98:13201/MicroRecon/1.2/groupcreate?osType=ios"
#define delGroupMemberUrl @"http://113.57.174.98:13201/MicroRecon/1.3/group?osType=ios"
#define GetGroupDesUrl @"http://113.57.174.98:13201/MicroRecon/1.3/group?osType=ios&action=getgroupinfo&alarm=%@&gid=%@&token=%@"
#define ChangeGroupDesUrl @"http://113.57.174.98:13201/MicroRecon/1.3/group?osType=ios"
#define AddGroupMemberUrl @"http://113.57.174.98:13201/MicroRecon/1.3/groupadd?osType=ios"
#define GtUserDesInfoUrl @"http://113.57.174.98:13201/MicroRecon/1.3/info?osType=ios&action=getuserinfo&alarm=%@&token=%@"
#define Upload_File_URLTwo @"http://113.57.174.98:13201/MicroRecon/1.3/uploadfile2?osType=ios"
#define ChangeUserInfoUrl @"http://113.57.174.98:13201/MicroRecon/1.3/info?osType=ios"
#define JoinGroupUrl @"http://113.57.174.98:13201/MicroRecon/1.3/usertogroup??osType=ios"


//用户注册
#define RegisterUserInfo @"http://113.57.174.98:13201/MicroRecon/1.3/register?osType=ios"
///**
// 拉取聊天消息
// */
#define RequestNewUrl @"http://113.57.174.98:13201/MicroRecon/1.3/getappmessage?osType=ios"
///**
// 删除好友
// */
#define DeleteFriendUrl @"http://113.57.174.98:13201/MicroRecon/1.3/friends?osType=ios"
/**
 *  获取单位结构
 *
 *  @return 获取单位结构
 */
#define GetorgbyregisterUrl @"http://113.57.174.98:13201/MicroRecon/1.3/getorgbyregister?osType=ios"
/**
 *  检测热更新
 *
 *  @return 检测热更新下载
 */
#define HotfixJSUrl     @"http://113.57.174.98:13201/MicroRecon/1.3/iosappupdate?osType=ios"

/**
 * 消息转发
 */
#define MSGForwardUrl @"http://113.57.174.98:13201/MicroRecon/1.2/transpond?osType=ios"
/**
 *  地图聊天获取在线人数
 *
 *  @return 地图聊天获取在线人数
 */
#define GetGPSUrl   @"http://113.57.174.98:13201/MicroRecon/1.2/position?osType=ios"
/**
 *  地图标注
 *
 *  @return 地图标注
 */
#define MapAnnotationUrl    @"http://113.57.174.98:13201/MicroRecon/1.2/eventlist?osType=ios&action=eventlist&alarm=%@&gid=%@&token=%@"
/**
 *  任务轨迹
 *
 *  @return 任务轨迹
 */
#define MapGettrailbywork   @"http://113.57.174.98:13201/MicroRecon/1.2/gettrailbywork?osType=ios&action=gettraillist&alarm=%@&suspectid=%@&token=%@"
/**
 *  所有地图标注
 *
 *  @return 所有地图标注
 */
#define GetAllMapAnnotationUrl    @"http://113.57.174.98:13201/MicroRecon/1.2/getrecordbygroup?osType=ios&action=getrecordbygroup&userid=%@&alarm=%@&gid=%@&token=%@"
/**
 *  某个任务地图标注
 *
 *  @return 某个任务地图标注
 */
#define GetMapAnnotationUrl      @"http://113.57.174.98:13201/MicroRecon/1.2/getrecordbyworkid?osType=ios&action=getrecordbyworkid&alarm=%@&workid=%@&token=%@"


/**
 *  获取群任务id
 *
 *  @return 获取群任务id
 */
#define  GetworkbygroupUrl   @"http://113.57.174.98:13201/MicroRecon/1.2/getworkbygroup?osType=ios&action=getworkbygroup&gid=%@&alarm=%@&token=%@"
/**
 *  任务列表
 *
 *  @return 任务列表
 */

#define GetSuspectlistUrl   @"http://113.57.174.98:13201/MicroRecon/1.2/suspectlist?osType=ios&action=suspectlist&alarm=%@&type=2&token=%@"

#define SwitchPushMessageUrl    @"http://113.57.174.98:13201/MicroRecon/1.3/switchpush?osType=ios"

#ifdef DEBUG // 处于开发阶段
#define Provider_URL @"http://113.57.174.98:8085/APNSProductTestProvider/send"
#else   // 处于发布阶段
#define Provider_URL @"http://113.57.174.98:8085/APNSProductProvider/send"
#endif

/*
 * 四表合一接口
 */
#define Saverecord_URL @"http://113.57.174.98:13201/MicroRecon/1.2/saverecord?osType=ios"

/*
 * 发布任务
 */
#define PublishTaskURL  @"http://113.57.174.98:13201/MicroRecon/1.2/createsuspect?osType=ios"


/**
 获取留言板列表
 
 @return 获取留言板列表
 */
#define CommentlistbyrecordUrl @"http://113.57.174.98:13201/MicroRecon/1.3/commentlistbyrecord?osType=ios&alarm=%@&token=%@&mark_id=%@&type=%@"

/**
 添加留言
 
 @return  添加留言
 */
#define SetCommentUrl   @"http://113.57.174.98/MicroRecon/1.3/setcommenttorecord?osType=ios"

/**
 消息撤回
 
 @return  消息撤回
 */
#define MessageRecallUrl @"http://113.57.174.98:13201/MicroRecon/1.3/messagerecall?osType=ios"


#define GetCircleList @"http://120.76.157.56:80/circlemain?osType=ios"
/**
 车侦接口
 
 @return   车侦接口
 */

#define GetInfoCarUrl @"http://113.57.174.98:13201/fire/getcarinfo?hphm=%@&fromtime=%@&totime=%@&alarm=%@"

/**
 摇一摇
 
 @return  摇一摇
 */
#define ShakeUrl    @"http://113.57.174.98:13201/MicroRecon/1.2/sharkgetdata"


#define GetRallcalllist_URL @"http://113.57.174.98:13201/MicroRecon/1.2/rallcalllist?action=rallcalllist&alarm=%@&token=%@&type=%@"

#define GetReportActive_URL @"http://113.57.174.98:13201/MicroRecon/1.2/activemanage?action=activemanage&alarm=%@&token=%@&rallcallid=%@&activestate=%@"


#define ReportRall_URL @"http://113.57.174.98:13201/MicroRecon/1.2/toreport?action=toreport&alarm=%@&token=%@&rallcallid=%@&latitude=%@&longitude=%@&position=%@"

/**
 获取轨迹
 
 @return  获取轨迹
 */
#define ChatMapGetPath   @"http://113.57.174.98:13201/MicroRecon/1.2/gettrail?osType=ios"


#define SendTestCode_URL @"http://113.57.174.98:13201/MicroRecon/1.3/microverify?osType=ios"

/**
 点名详情
 
 @return 点名详情
 */
#define getReportDetailUrl @"http://113.57.174.98:13201/MicroRecon/1.2/rallcallinfo?osType=ios"
/**
 发布点名
 
 @return  发布点名
 */
#define CreateAllCallUrl  @"http://113.57.174.98:13201/MicroRecon/1.2/createrallcall?osType=ios"
/**
 
 根据日期获取人员列表
 @param date     需要查询的日期
 @param reportId 报道的id
 @return 根据日期获取人员列表
 */
#define getreportuserbydayUrl @"http://113.57.174.98:13201/MicroRecon/1.2/getreportuserbyday?osType=ios&action=getreportuserbyday&alarm=%@&token=%@&rallcallid=%@&day=%@"


//呼叫支援
#define GetHelpUrl @"http://113.57.174.98:13201/MicroRecon/1.2/help?osType=ios"

//取消呼叫支援
#define CancelHelpUrl @"http://113.57.174.98:13201/MicroRecon/1.2/cancelhelp?osType=ios"
//确认支援
#define EnsurHelpUrl @"http://113.57.174.98:13201/MicroRecon/1.2/ensurehelp?osType=ios"
/**
 
 编辑点名
 
 @return  编辑点名
 */
#define ChangeAllCallUrl  @"http://113.57.174.98:13201/MicroRecon/1.2/changerallcall?osType=ios"

#define SendTestCode_URL @"http://113.57.174.98:13201/MicroRecon/1.3/microverify?osType=ios"

#define TestCode_URl @"http://113.57.174.98:13201/MicroRecon/1.3/register_new?osType=ios"

#define NewRegister_URL @"http://113.57.174.98:13201/MicroRecon/1.3/register1?osType=ios"

#define ForgetPassWord_URL @"http://113.57.174.98:13201/MicroRecon/1.3/forgetpasswd?osType=ios"

//#define GetTrail_URL @""
#define SaveRoute_URL @"http://113.57.174.98:13201/MicroRecon/1.2/saveroute?ostype=ios"

#define MessageFirelUrl @"http://113.57.174.98:13201/MicroRecon/1.3/messageburn?osType=ios"


#define ChangePassword_URL @"http://113.57.174.98:13201/MicroRecon/1.1/account?osType=ios"
#endif /* OnlineURL_h */
