//
//  GroupDelMemebrController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GroupDelMemebrController;

@protocol GroupDelMemebrControllerDelegate <NSObject>

- (void)groupDelMemebrControllerRefresh:(GroupDelMemebrController *)con;

@end

@interface GroupDelMemebrController : UIViewController

@property (nonatomic, copy) NSString *gadmin;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<GroupDelMemebrControllerDelegate> delegate;


@end
