//
//  CustomCalloutView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView


@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,strong)NSString *time;//时间

@property (nonatomic, copy) NSString *title;//title
@property (nonatomic, copy) NSString *subtitle;//详情

//任务model
@property (nonatomic, weak) id gModel;

@end
