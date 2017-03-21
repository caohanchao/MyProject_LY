//
//  WorkListsViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

//进入工作列表的类别
typedef  NS_ENUM(NSInteger, ComeWorkListType){
    GroupDesPage = 0,    //群详情页面
    MarkPage = 1,        //标记页面
    PhysicsDesPage = 2,     //轨迹页面
    ChatListPage = 3,       // 消息列表界面
};

typedef void (^TaskBlock)(NSMutableDictionary *param);

@interface WorkListsViewController : UIViewController

@property (nonatomic, copy) NSString *gid;

@property(nonatomic,assign) ComeWorkListType type;

@property(nonatomic,copy)TaskBlock taskBlock;

@end
