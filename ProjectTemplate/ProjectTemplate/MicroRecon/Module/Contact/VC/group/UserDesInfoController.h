//
//  UserDesInfoController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "BaseViewController.h"

@class UserDesInfoController;
@class FriendsListModel;
@class UserAllModel;
//判断来自哪个界面
typedef enum : NSUInteger {
    ChatControlelr,
    GroupController,//群聊
    Search,//搜索
    ApplicationPage,//应用
    Others//其它
} CONTYPE;

typedef enum : NSUInteger {
    Code,//二维码
    Group,//通讯录
    Chat,//消息列表
    TheOthers//其它
} CGTYPE;

@interface UserDesInfoController : BaseViewController

@property (nonatomic, strong) FriendsListModel *model;
@property (nonatomic, strong) UserAllModel *userModel;

@property (nonatomic, copy) NSString *alarm;//警号
@property (nonatomic, copy) NSString *RE_alarmNum;//组织警号
@property (nonatomic, assign) CONTYPE cType;
@property (nonatomic, assign) CGTYPE cgType;
@end
