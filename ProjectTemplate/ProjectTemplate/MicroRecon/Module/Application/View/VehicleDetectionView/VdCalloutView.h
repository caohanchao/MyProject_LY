//
//  VdCalloutView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAutoScrollLabel;
@class VdResultModel;

@interface VdCalloutView : UIView

@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *momentLabel;

@property (nonatomic, strong) UILabel *kknumLabel;

@property (nonatomic, strong) UILabel *LaneNumberLabel;
@property (nonatomic, strong) UILabel *bayonetNameLabel;
@property (nonatomic, strong) CBAutoScrollLabel *rollLabel;
@property (nonatomic, strong) UIImageView *icon;

@property(nonatomic,copy)NSString *date;// 经过日期
@property (nonatomic, copy) NSString *moment;// 经过时刻
@property (nonatomic, copy) NSString *LaneNumber;// 车道编号
@property (nonatomic, copy) NSString *bayonetName;// 车道编号
@property (nonatomic, copy) NSString *iconUrl; // 图片url
@property (nonatomic, copy) NSString *kknum; // 经过次数

@property (nonatomic, weak) VdResultModel *model;
@end
