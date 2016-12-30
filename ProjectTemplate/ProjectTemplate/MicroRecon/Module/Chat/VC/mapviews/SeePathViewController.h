//
//  SeePathViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SeePathViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *haveSelectArray; // 已经被选中的轨迹
@property (nonatomic, copy) NSString *workId; // 任务id
@property (nonatomic, copy) NSString *gid;

@end
