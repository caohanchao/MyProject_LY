//
//  PhysicsViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetPathModel;
@class PhysicsViewController;

typedef enum : NSUInteger {
    OtherPage,//其它
    DraftsPage,//草稿箱
    EndPhysicsPage //结束轨迹
} FromPage;

typedef enum:NSUInteger{
    writeType, //可写
    OnlyReadType //只读
    
} WriteOrOnlyReadType;

typedef void (^PhysicsRefreshBlock)(PhysicsViewController *physics);

@interface PhysicsViewController : UIViewController


@property (nonatomic, strong) GetPathModel *gModel;
@property(nonatomic,copy)NSMutableDictionary *markParam;

@property(nonatomic,copy)NSString *locationInfo;//位置

@property(nonatomic,copy)NSString *gid;

@property(nonatomic)FromPage fromWhere;

@property(nonatomic)WriteOrOnlyReadType editType;

@property(nonatomic,copy)NSDictionary *workInfo;

@property(nonatomic,strong)NSMutableArray *pointInfo;//点位信息
@property (nonatomic, copy) PhysicsRefreshBlock block;
@end
