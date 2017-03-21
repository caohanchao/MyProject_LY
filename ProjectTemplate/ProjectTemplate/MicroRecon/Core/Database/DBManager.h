//
//  DBManager.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  对数据库的操作管理类

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MessageDAO.h"
#import "UserlistDAO.h"
#import "GrouplistSQ.h"
#import "DepartmentlistSQ.h"
#import "NewFriendDAO.h"
#import "UserDetailSQ.h"
#import "UploadingSQ.h"
#import "PersonnelInformationSQ.h"
#import "SystemUpdataSQ.h"
#import "SuspectAlllistSQ.h"
#import "TaskMarkSQ.h"
#import "DraftsListSQ.h"
#import "PostListSQ.h"
#import "FollowPostListSQ.h"
#import "PrivacyPostListSQ.h"
#import "PostPraiseUserSQ.h"
#import "PostCommentSQ.h"
#import "UserPostInfoSQ.h"
#import "UserFollowSQ.h"
#import "UserFansSQ.h"
#import "UserCountInfoSQ.h"
#import "MessageResendSQ.h"
#import "TrajectoryListSQ.h"
#import "MaxQidListSQ.h"

@interface DBManager : NSObject

@property (nonatomic ,retain) MessageDAO *MessageDAO; //对聊天记录表操作的DAO
@property (nonatomic ,retain) UserlistDAO *UserlistDAO; //对消息列表操作的DAO
@property (nonatomic, strong) GrouplistSQ *GrouplistSQ;//对群组列表操作
@property (nonatomic, strong) DepartmentlistSQ *DepartmentlistSQ;//对组织单位列表操作
@property (nonatomic, strong) NewFriendDAO *newFriendDAO;//对新朋友表操作的dao
@property (nonatomic, strong) UserDetailSQ *userDetailSQ;//对用户信息操作的dao
@property (nonatomic, strong) UploadingSQ *uploadingSQ;//对正在上传的model操作的dao
@property (nonatomic, strong) PersonnelInformationSQ *personnelInformationSQ;//对人员信息表操作的dao
@property (nonatomic, strong) SystemUpdataSQ *systemUpdataSQ;//对系统热更新表操作的dao
@property (nonatomic, strong) SuspectAlllistSQ *suspectAlllistSQ;//对任务列表操作的dao
@property (nonatomic, strong) TaskMarkSQ *taskMarkSQ;//对任务标记列表操作的dao
@property (nonatomic, strong) DraftsListSQ *draftsListSQ;
@property (nonatomic, strong) PostListSQ *postListSQ;//战友圈广场
@property (nonatomic, strong) FollowPostListSQ *followPostListSQ;//战友圈关注
@property (nonatomic, strong) PrivacyPostListSQ *privacyPostListSQ;//战友圈私密
@property (nonatomic, strong) PostPraiseUserSQ *postPraiseUserSQ;//战友圈点赞
@property (nonatomic, strong) PostCommentSQ *postCommentSQ;//战友圈评论
@property (nonatomic, strong) UserPostInfoSQ *userPostInfoSQ;//战友圈评论
@property (nonatomic, strong) UserFollowSQ *userFollowSQ;//关注
@property (nonatomic, strong) UserFansSQ *userFansSQ;//粉丝
@property (nonatomic, strong) UserCountInfoSQ *userCountInfoSQ;//数量
@property (nonatomic, strong) MessageResendSQ *messageResendSQ; //消息重发dao
@property (nonatomic, strong) TrajectoryListSQ *trajectoryListSQ; //轨迹列表
@property (nonatomic, strong) MaxQidListSQ *maxQidListSQ; //最大qid列表

+ (DBManager *)sharedManager;
/**
 *  关闭数据库
 */
+ (void)closeDB;
// 删除表
- (BOOL)deleteTable:(NSString *)tableName;
// 清除表
- (BOOL)eraseTable:(NSString *)tableName;
@end
