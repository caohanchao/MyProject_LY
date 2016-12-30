//
//  DBManager.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DBManager.h"
#import "UpdataFMDBManager.h"

static DBManager *manager = nil;

@implementation DBManager

+ (DBManager *)sharedManager{
    @synchronized(self) {//同步 执行 防止多线程操作
        if (manager == nil) {
            manager = [[self alloc] init];
            //[manager createDB];
            [manager createAllTable];
            //数据库结构更新
            [[UpdataFMDBManager sharedInstance] updataFMDB];
        }
    }
    return manager;
}

/**
 *  创建新表
 */
+ (void)closeDB {
    manager = nil;
}
//创建所有的表
- (void)createAllTable{
    ZEBLog(@"创建表");
    //打开数据库
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        //消息列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'tb_userlist' ( 'ut_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'ut_cmd' TEXT , 'ut_sendid' TEXT, 'ut_alarm' TEXT unique,'ut_headpic' TEXT,'ut_name' TEXT,'ut_fire' TEXT,'ut_mode' TEXT,'ut_type' TEXT,'ut_mtype' TEXT,'ut_draft' TEXT, 'ut_message' TEXT, 'ut_time' TEXT, 'ut_newmsgcount' TEXT, 'ut_ptime' TEXT);"];
        
        //聊天记录表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'tb_message' ( 'me_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'me_sid' TEXT , 'me_rid' TEXT, 'me_qid' INTEGER,'me_gps_h' TEXT,'me_gps_w' TEXT,'me_remote_mark_id' TEXT,'me_time' TEXT,'me_type' TEXT,'me_mtype' TEXT,'me_data' TEXT, 'me_ptime' TEXT, 'me_voicetime' TEXT, 'me_videopic' TEXT, 'me_cmd' TEXT, 'me_workname' TEXT, 'me_markDataId' TEXT, 'me_headpic' TEXT, 'me_sname' TEXT, 'me_DEType' TEXT, 'me_DEName' TEXT,'me_btime' TEXT);"];
        
        [db executeUpdate:@"CREATE UNIQUE INDEX index_qid ON tb_message (me_qid)"];
        
        
        //上传视频，图片上传中model表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_uploading(UP_id INTEGER PRIMARY KEY AUTOINCREMENT,'UP_sid' TEXT , 'UP_rid' TEXT, 'UP_qid' INTEGER ,'UP_cuid' TEXT,'UP_gps_h' TEXT,'UP_gps_w' TEXT,'UP_remote_mark_id' TEXT,'UP_time' TEXT unique,'UP_type' TEXT,'UP_mtype' TEXT,'UP_data' TEXT, 'UP_ptime' TEXT, 'UP_voicetime' TEXT, 'UP_videopic' TEXT, 'UP_cmd' TEXT, 'UP_workname' TEXT, 'UP_headpic' TEXT, 'UP_sname' TEXT);"];
        
        
        //人员信息表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_PersonnelInformation(PI_id INTEGER PRIMARY KEY AUTOINCREMENT,PI_alarm TEXT unique,PI_nickname TEXT,PI_name TEXT,PI_headpic TEXT,PI_age TEXT,PI_sex TEXT,PI_phone TEXT,PI_identitycard TEXT,PI_post TEXT,PI_department TEXT,PI_addtime TEXT,PI_permission TEXT,PI_status TEXT,PI_ptime TEXT,PI_isdepartment TEXT,PI_isfriend TEXT,PI_useralarm TEXT);"];
        
        //群组列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_grouplist(GR_id VARCHAR(20) PRIMARY KEY,GR_gid VARCHAR(20) unique,GR_name VARCHAR(20),GR_type CHAR(1),GR_admin VARCHAR(20),GR_creattime VARCHAR(30),GR_usercount VARCHAR(30),GR_ptime VARCHAR(30),GR_description VARCHAR(30),GR_member TEXT,GR_remindSet TEXT);"];
    
        
        //组织结构列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_departmentlist(DE_id INTEGER PRIMARY KEY AUTOINCREMENT,DE_number VARCHAR(20) unique,DE_name VARCHAR(45),DE_sjnumber VARCHAR(20),DE_level VARCHAR(10),DE_count VARCHAR(20),DE_describe1 VARCHAR(100),DE_describe2 VARCHAR(100),DE_type VARCHAR(10));"];
        
        //新朋友列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_newfriend(nf_id INTEGER PRIMARY KEY AUTOINCREMENT,nf_fid TEXT unique,nf_mtype TEXT,nf_data TEXT,nf_isactive TEXT,nf_ptime TEXT);"];
        
        
        //用户详细信息表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_userInfo(UI_id INTEGER PRIMARY KEY AUTOINCREMENT,UI_alarm TEXT unique,UI_department TEXT,UI_headpic TEXT,UI_identitycard TEXT,UI_name TEXT,UI_phonenum TEXT,UI_post TEXT,UI_sex TEXT,UI_age TEXT,UI_soundSet TEXT,UI_vibrateSet TEXT,UI_locationSet TEXT,UI_autoUploadSet TEXT);"];
        
        //系统更新信息表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_systemUpdata(SU_id INTEGER PRIMARY KEY AUTOINCREMENT,SU_appVersion TEXT ,SU_jsVersion TEXT,SU_time TEXT,SU_jsUrl TEXT unique,SU_jsDetailedInf TEXT);"];
        
        //所有任务列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS sl_suspectalllist(SL_id INTEGER PRIMARY KEY AUTOINCREMENT,SL_create_time TEXT ,SL_createuser TEXT,SL_gid TEXT,SL_gname TEXT,SL_headpic TEXT,SL_suspectdec TEXT,SL_suspectid TEXT unique,SL_suspectname TEXT,SL_suspecttype TEXT,SL_username TEXT);"];
        
        //群任务标记
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tm_taskmark(SL_id INTEGER PRIMARY KEY AUTOINCREMENT,TM_alarm TEXT ,TM_content TEXT,TM_create_time TEXT,TM_department TEXT,TM_direction TEXT,TM_gid TEXT,TM_headpic TEXT,TM_interid TEXT unique,TM_latitude TEXT,TM_longitude TEXT,TM_mode TEXT,TM_orderid TEXT,TM_position TEXT,TM_realname TEXT,TM_title TEXT,TM_type TEXT,TM_workid TEXT,TM_workname TEXT,TM_video TEXT,TM_audio TEXT,TM_picture TEXT);"];
        
        //战友圈广场列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ca_allPost(CA_id INTEGER PRIMARY KEY AUTOINCREMENT,CA_alarm TEXT ,CA_comment TEXT,CA_department TEXT,CA_headpic TEXT,CA_ispraise TEXT,CA_mode TEXT,CA_picture TEXT,CA_position TEXT ,CA_postid TEXT,CA_posttype TEXT,CA_praisenum TEXT,CA_publishname TEXT,CA_pushtime NUMBER,CA_text TEXT);"];
        
        //战友圈关注列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS at_followPost(AT_id INTEGER PRIMARY KEY AUTOINCREMENT,AT_alarm TEXT ,AT_comment TEXT,AT_department TEXT,AT_headpic TEXT,AT_ispraise TEXT,AT_mode TEXT,AT_picture TEXT,AT_position TEXT ,AT_postid TEXT,AT_posttype TEXT,AT_praisenum TEXT,AT_publishname TEXT,AT_pushtime NUMBER,AT_text TEXT);"];
        
        //战友圈私密列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS pr_privacyPost(PR_id INTEGER PRIMARY KEY AUTOINCREMENT,PR_alarm TEXT ,PR_comment TEXT,PR_department TEXT,PR_headpic TEXT,PR_ispraise TEXT,PR_mode TEXT,PR_picture TEXT,PR_position TEXT ,PR_postid TEXT,PR_posttype TEXT,PR_praisenum TEXT,PR_publishname TEXT,PR_pushtime NUMBER,PR_text TEXT);"];

        //战友圈评论列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS cm_comment(CM_id INTEGER PRIMARY KEY AUTOINCREMENT,CM_alarm TEXT ,CM_commentid TEXT,CM_postuser TEXT,CM_content TEXT,CM_department TEXT,CM_headpic TEXT,CM_mode TEXT,CM_pushtime NUMBER,CM_name TEXT,CM_postid TEXT);"];
        
        //战友圈点赞列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ps_praiseUser(PS_id INTEGER PRIMARY KEY AUTOINCREMENT,PS_alarm TEXT ,PS_department TEXT,PS_headpic TEXT,PS_name TEXT,PS_time TEXT);"];
        
        //主页关注列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ha_userFollow(HA_id INTEGER PRIMARY KEY AUTOINCREMENT,HA_alarm TEXT ,HA_department TEXT,HA_headpic TEXT,HA_name TEXT,HA_time TEXT,HA_userAlarm TEXT);"];
        
        //主页粉丝列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS hf_userFans(HF_id INTEGER PRIMARY KEY AUTOINCREMENT,HF_alarm TEXT ,HF_department TEXT,HF_headpic TEXT,HF_name TEXT,HF_time TEXT,HF_userAlarm TEXT);"];
    
        //主页动态列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS hm_cardPost(HM_id INTEGER PRIMARY KEY AUTOINCREMENT,HM_alarm TEXT ,HM_comment TEXT,HM_department TEXT,HM_headpic TEXT,HM_ispraise TEXT,HM_mode TEXT,HM_picture TEXT,HM_position TEXT ,HM_postid TEXT,HM_posttype TEXT,HM_praisenum TEXT,HM_publishname TEXT,HM_pushtime NUMBER,HM_text TEXT);"];
        
        //主页数量列表
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS hn_countInfo(HN_id INTEGER PRIMARY KEY AUTOINCREMENT,HN_fansNum TEXT ,HN_focusNum TEXT,HN_publicNum TEXT ,HN_alarm TEXT);"];
        
        //草稿箱
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_DraftsList(SL_id INTEGER PRIMARY KEY AUTOINCREMENT,Dr_alarm TEXT ,Dr_audio TEXT ,Dr_content TEXT ,Dr_create_time TEXT ,Dr_department TEXT ,Dr_direction TEXT ,Dr_gid TEXT ,Dr_headpic TEXT ,Dr_interid TEXT ,Dr_latitude TEXT,Dr_longitude TEXT,Dr_mode TEXT,Dr_orderid TEXT ,Dr_position TEXT ,Dr_realname TEXT ,Dr_title TEXT ,Dr_type TEXT ,Dr_workid TEXT ,Dr_video TEXT ,Dr_picture TEXT ,Dr_cuid TEXT unique);"];
        
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_messageResend('mr_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'mr_sid' TEXT , 'mr_rid' TEXT, 'mr_qid' INTEGER,'mr_gps_h' TEXT,'mr_gps_w' TEXT,'mr_remote_mark_id' TEXT,'mr_time' TEXT,'mr_type' TEXT,'mr_mtype' TEXT,'mr_data' TEXT, 'mr_ptime' TEXT, 'mr_voicetime' TEXT, 'mr_videopic' TEXT, 'mr_cmd' TEXT, 'mr_headpic' TEXT, 'mr_sname' TEXT, 'mr_DEType' TEXT, 'mr_DEName' TEXT,'mr_btime' TEXT,'mr_msgid' TEXT,'mr_msgstate' TEXT,'mr_cuid' TEXT unique);"];
        
        //轨迹草稿
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_trajectoryList('TL_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'TL_alarm' TEXT , 'TL_end_latitude' TEXT,'TL_end_longitude' TEXT, 'TL_end_posi' TEXT,'TL_end_time' TEXT,'TL_head_pic' TEXT,'TL_position' TEXT,'TL_route_id' TEXT,'TL_route_title' TEXT,'TL_start_latitude' TEXT,'TL_start_longitude' TEXT, 'TL_start_posi' TEXT, 'TL_start_time' TEXT, 'TL_task_id' TEXT, 'TL_token' TEXT, 'TL_type' TEXT,'TL_location_list' TEXT, 'TL_gid' TEXT, 'TL_cuid' TEXT unique,'TL_createtime' TEXT, 'TL_describetion' TEXT);"];
        
    }];
    
}

// 删除表
- (BOOL)deleteTable:(NSString *)tableName{
    
    __block NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    __block BOOL ret = NO;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:sqlstr];
    }];
    
    return ret;
}
// 清除表
- (BOOL)eraseTable:(NSString *)tableName
{
    __block NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    __block BOOL ret = NO;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlstr];
    }];
    
    return ret;
}
#pragma mark - Getter

//对聊天记录表操作的DAO
- (MessageDAO *)MessageDAO {
    if (!_MessageDAO) {
        _MessageDAO = [MessageDAO messageDAO];
    }
    return _MessageDAO;
}

//对消息列表操作的DAO
- (UserlistDAO *)UserlistDAO {
    if (!_UserlistDAO) {
        _UserlistDAO = [UserlistDAO userlistDAO];
    }
    return _UserlistDAO;
}
//对群组列表操作
- (GrouplistSQ *)GrouplistSQ {
    if (_GrouplistSQ == nil) {
        _GrouplistSQ = [GrouplistSQ grouplistDAO];
    }
    return _GrouplistSQ;
}
//对组织单位列表操作
- (DepartmentlistSQ *)DepartmentlistSQ  {

    if (_DepartmentlistSQ == nil) {
        _DepartmentlistSQ = [DepartmentlistSQ departmentlistDAO];
    }
    return _DepartmentlistSQ;
}

//对组织人员列表操作
- (NewFriendDAO *)newFriendDAO {
    if (!_newFriendDAO) {
        _newFriendDAO = [NewFriendDAO newFriendDAO];
    }
    
    return _newFriendDAO;
}
//对用户信息操作的dao
- (UserDetailSQ *)userDetailSQ {

    if (!_userDetailSQ) {
        _userDetailSQ = [UserDetailSQ userDetailDAO];
    }
    return _userDetailSQ;
}
//对正在上传的model操作的dao
- (UploadingSQ *)uploadingSQ {
    
    if (!_uploadingSQ) {
        _uploadingSQ = [UploadingSQ uploadingDAO];
    }
    return _uploadingSQ;
}
//对人员信息表操作的dao
- (PersonnelInformationSQ *)personnelInformationSQ {

    if (!_personnelInformationSQ) {
        _personnelInformationSQ = [PersonnelInformationSQ personnelInformationDAO];
    }
    return _personnelInformationSQ;
}
//对系统热更新表操作的dao
- (SystemUpdataSQ *)systemUpdataSQ {
    if (!_systemUpdataSQ) {
        _systemUpdataSQ = [SystemUpdataSQ systemUpdataSQ];
    }
    return _systemUpdataSQ;
}
//对任务列表操作的dao
- (SuspectAlllistSQ *)suspectAlllistSQ {
    if (!_suspectAlllistSQ) {
        _suspectAlllistSQ = [SuspectAlllistSQ suspectAlllistSQ];
    }
    return _suspectAlllistSQ;
}
//对任务标记列表操作的dao
- (TaskMarkSQ *)taskMarkSQ {
    if (!_taskMarkSQ) {
        _taskMarkSQ = [TaskMarkSQ taskMarkSQ];
    }
    return _taskMarkSQ;
}

//对草稿箱列表操作的dao
-(DraftsListSQ *)draftsListSQ
{
    if (!_draftsListSQ) {
        _draftsListSQ = [DraftsListSQ draftsListSQ];
    }
    return _draftsListSQ;
}

//对广场列表操作的dao
-(PostListSQ *)postListSQ
{
    if (!_postListSQ) {
        _postListSQ = [PostListSQ PostListSQ ];
    }
    return _postListSQ;
}

//对关注列表操作的dao
-(FollowPostListSQ *)followPostListSQ
{
    if (!_followPostListSQ) {
        _followPostListSQ = [FollowPostListSQ FollowPostListSQ ];
    }
    return _followPostListSQ;
}

//对私密列表操作的dao
-(PrivacyPostListSQ *)privacyPostListSQ
{
    if (!_privacyPostListSQ) {
        _privacyPostListSQ = [PrivacyPostListSQ PrivacyPostListSQ ];
    }
    return _privacyPostListSQ;
}

//对点赞列表操作的dao
-(PostPraiseUserSQ *)postPraiseUserSQ
{
    if (!_postPraiseUserSQ) {
        _postPraiseUserSQ = [PostPraiseUserSQ PostPraiseUserSQ ];
    }
    return _postPraiseUserSQ;
}

//对评论列表操作的dao
-(PostCommentSQ *)postCommentSQ
{
    if (!_postCommentSQ) {
        _postCommentSQ = [PostCommentSQ PostCommentSQ ];
    }
    return _postCommentSQ;
}

//对主页列表操作的dao
-(UserPostInfoSQ *)userPostInfoSQ
{
    if (!_userPostInfoSQ) {
        _userPostInfoSQ = [UserPostInfoSQ UserPostInfoSQ ];
    }
    return _userPostInfoSQ;
}

//对关注列表操作的dao
-(UserFollowSQ *)userFollowSQ
{
    if (!_userFollowSQ) {
        _userFollowSQ = [UserFollowSQ UserFollowSQ ];
    }
    return _userFollowSQ;
}

//对粉丝列表操作的dao
-(UserFansSQ *)userFansSQ
{
    if (!_userFansSQ) {
        _userFansSQ = [UserFansSQ UserFansSQ ];
    }
    return _userFansSQ;
}

//对数量列表操作的dao
-(UserCountInfoSQ *)userCountInfoSQ
{
    if (!_userCountInfoSQ) {
        _userCountInfoSQ = [UserCountInfoSQ UserCountInfoSQ ];
    }
    return _userCountInfoSQ;
}

-(MessageResendSQ *)messageResendSQ
{
    if (!_messageResendSQ) {
        _messageResendSQ = [MessageResendSQ messageResendSQ];
    }
    return _messageResendSQ;
}

//轨迹列表的dao
- (TrajectoryListSQ *)trajectoryListSQ
{
    if (!_trajectoryListSQ) {
        _trajectoryListSQ = [TrajectoryListSQ trajectoryListSQ];
    }
    return _trajectoryListSQ;
}
@end
