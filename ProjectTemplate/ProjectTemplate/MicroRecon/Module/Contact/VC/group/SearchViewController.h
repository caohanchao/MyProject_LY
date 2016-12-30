//
//  SearchViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SearchViewController : UIViewController


@property (nonatomic, copy) NSString *str;
/**
 *  1好友 2组队 3单位
 */
@property (nonatomic, assign) NSInteger type;

/**
 1 消息列表 2 通讯录
 */
@property (nonatomic, assign) NSInteger cType;
@end
