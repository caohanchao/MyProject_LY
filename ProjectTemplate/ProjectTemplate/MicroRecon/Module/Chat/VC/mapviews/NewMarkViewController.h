//
//  NewMarkViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef  NS_ENUM(NSInteger, MARK_TV_SECTION){
    Mark_FristSection = 0,
    Mark_SecondSection = 1,
    Mark_ThreeSection = 2,
    Mark_FourSection = 3
};

typedef NS_ENUM(NSInteger,EditAuthorityMode){
    isOnlyReadMode = -1,
    isOnlyWriteMode = 0,
    isReadAndWriteMode = 1
};


@interface NewMarkViewController : UIViewController

@property (nonatomic,assign)MARK_TV_SECTION section;

@property (nonatomic,assign)EditAuthorityMode editMode;

@property (nonatomic,copy)NSString *markId;

@property (nonatomic,strong)NSMutableDictionary *markParam;

@property (nonatomic,copy)NSString *direction;//方向

@property(nonatomic,copy)NSString *type; //类型

@property (nonatomic,copy)NSString *gid;

@property (nonatomic,assign)NSInteger markType;

@property (nonatomic,strong)WorkAllTempModel *model;
@end
