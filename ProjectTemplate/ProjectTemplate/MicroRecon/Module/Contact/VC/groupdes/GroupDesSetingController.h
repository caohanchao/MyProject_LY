//
//  GroupDesSetingController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupDesSetingController : UIViewController

@property (nonatomic, copy) NSString *gid;


@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *selectFRArray;
@property (nonatomic, strong) NSMutableArray *selectTMArray;
@property (nonatomic, strong) NSMutableArray *selectUTArray;

@property (nonatomic, assign) NSInteger cType;//1 消息列表 2 组队 3 搜索
@property (nonatomic, copy) NSString *selGid;

@end
