//
//  DynamicDetailsViewController.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostListModel.h"

@interface DynamicDetailsViewController : UIViewController

@property(nonatomic,copy)NSString * postComment;

@property(nonatomic,copy)PostListModel * model;

@property(nonatomic,copy)NSString * posttypes;

@end
