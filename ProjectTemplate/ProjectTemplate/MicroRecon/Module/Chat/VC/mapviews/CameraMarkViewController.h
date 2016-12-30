//
//  CameraMarkViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkAllTempModel;
@class CameraMarkViewController;

typedef  NS_ENUM(NSInteger, MarkType){
    WalkMark = 0,   //走访标记
    QuickRecord = 1,//快速记录
    CaremaMark = 2, //摄像头标记
    
};
typedef enum : NSUInteger {
    OtherController,//其它
    DraftsController//草稿箱
} FromWhere;

@protocol CameraMarkViewControllerDelegate <NSObject>

- (void)cameraMarkViewControllerRefresh:(CameraMarkViewController *)controller;

@end
typedef void (^RefreshBlock)(CameraMarkViewController *camera);

@interface CameraMarkViewController : UIViewController

@property(nonatomic,copy)NSMutableDictionary *markParam;

@property(nonatomic,copy)NSString *locationInfo;//位置

@property(nonatomic) MarkType markType;
@property(nonatomic) FromWhere fromWhere;

@property (nonatomic, weak) id<CameraMarkViewControllerDelegate> delegate;
@property(nonatomic,copy)NSString *type; //类型

@property(nonatomic,copy)NSString *gid;

@property(nonatomic,copy)NSString *direction;//方向

@property (nonatomic, weak) WorkAllTempModel *model;
@property (nonatomic, copy) RefreshBlock block;

@end
