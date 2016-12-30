//
//  PersonnelInformationSQ.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/6.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsListModel.h"
#import "UserAllModel.h"
#import "UserInfoModel.h"
#import "GroupMemberModel.h"


@interface PersonnelInformationSQ : NSObject

//根据FMDatabase获取PersonnelInformationSQ对象
+ (instancetype)personnelInformationDAO;
// 插入一条好友信息到列表
- (BOOL)insertPersonnelInformationOfFriendsListModel:(FriendsListModel *)model;
// 插入一条组织人员信息到列表
- (BOOL)insertPersonnelInformationOfUserAllModel:(UserAllModel *)model;
// 插入一条好友信息到列表
- (BOOL)insertPersonnelInformationOfUserInfoModel:(UserInfoModel *)model;
//事务插入好友信息（处理大量数据）
- (void)transactionInsertPersonnelInformationOfFriendsListModel:(NSArray *)array;
//事务插入组织人员信息（处理大量数据）
- (void)transactionInsertPersonnelInformationOfUserAllModel:(NSArray *)array;
// 查询在列表的好友列表
- (NSMutableArray *)selectFrirndlist;
// 查询在列表的组织人员列表
- (NSMutableArray *)selectDepartmentmemberlist;
// 根据id查询在消息列表对应的消息
- (FriendsListModel *)selectFrirndlistById:(NSString *)Id;
// 根据姓名查询在消息列表对应的信息
- (FriendsListModel *)selectFrirndlistByName:(NSString *)name;
// 根据id查询在消息列表对应的消息
- (UserAllModel *)selectDepartmentmemberlistById:(NSString *)Id;
// 根据id查询在消息列表对应的消息 返回群成员
- (GroupMemberModel *)selectDepartmentGroupMemberModelById:(NSString *)Id;
// 插入或更新组织人员列表数据
- (BOOL)insertOrUpdateNewPersonnelInformationOfUserAllModel:(UserAllModel *)model;
// 插入或更新好友列表数据
- (BOOL)insertOrUpdateNewPersonnelInformationOfFriendsListModel:(FriendsListModel *)model;
// 更新好友列表信息
- (BOOL)updateNewPersonnelInformationOfFriendsListModel:(FriendsListModel *)model;
// 删除好友信息
-(BOOL)deletePersonelInfomationFriendsListModel:(NSString *)alarm;
// 更新组织成员列表信息
- (BOOL)updateNewPersonnelInformationOfUserAllModel:(UserAllModel *)model;
// 更新人员信息
- (BOOL)updateNewPersonnelInformationOfUserInfoModel:(UserInfoModel *)model;
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistForAlarm:(NSString *)alarm;
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isFriendExistForAlarm:(NSString *)alarm;
//查询Department列表数
- (NSInteger)getDepartmentCountsFromDB;

@end
