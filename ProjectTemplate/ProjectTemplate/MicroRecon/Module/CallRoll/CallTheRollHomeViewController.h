//
//  CallTheRollHomeViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CreateTaskOfCallTheRallType) {
    ISReceiveType = 1,			//接收
    ISCreateType ,			//创建
    
};

@interface CallTheRollHomeViewController : UIViewController


@property (nonatomic,assign)CreateTaskOfCallTheRallType createType;



@end
