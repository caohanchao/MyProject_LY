//
//  SqureCell.h
//  ProjectTemplate
//
//  Created by 戴小斌 on 2016/10/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostListModel.h"

@class SqureCell;

@protocol SqureCellDelegate <NSObject>

- (void)postPraise:(SqureCell *)praise;

@end



@interface SqureCell : UITableViewCell

@property(nonatomic,strong)PostListModel * model;

/**
 *	@brief	图像;
 */
@property (nonatomic, strong) UIImageView *iconImage;

/**
 *	@brief	点击图像;
 */
@property (nonatomic, strong) UIButton *iconImageBtn;

/**
 *	@brief	身份;
 */
@property (nonatomic, strong) UILabel *identitylabel;

@property (nonatomic, strong) UIImageView *positionImg;

/**
 *	@brief	姓名;
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *	@brief	哪家派出所;
 */
@property (nonatomic, strong) UILabel *fromLabel;

/**
 *	@brief	点击姓名信息;
 */
@property (nonatomic, strong) UIButton *userInfoBtn;

// 用户信息回调
@property (nonatomic, copy) void(^userInfoBlock)();

/**
 *	@brief	时间;
 */
@property (nonatomic, strong) UILabel *timeLabel;


/**
 *	@brief	内容;
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 *	@brief	位置;
 */
@property (nonatomic, strong) UILabel *positionLabel;

/**
 *	@brief	分割区域;
 */
@property (nonatomic, strong) UILabel *allLineLabel;

/**
 *	@brief	分割区域;
 */
@property (nonatomic, strong) UILabel *LineLabel;

/**
 *	@brief	图片区;
 */
@property (nonatomic, strong) UIScrollView *imageScrollview;

//// 点击图片回调
//@property (nonatomic, copy) void(^imageBlock)(UIButton*);

/**
 *	@brief	点赞按钮;
 */
@property (nonatomic, strong) UIButton *praiseBtn;

//// 点赞回调
//@property (nonatomic, copy) void(^praiseBlock)();

/**
 *	@brief	评论按钮;
 */
@property (nonatomic, strong) UIButton *commentBtn;

// 评论回调
@property (nonatomic, copy) void(^commentBlock)();

// 是否点赞
@property (nonatomic, copy) NSString * ispraise;

//点击图片是否显示大图
@property (nonatomic, assign) BOOL  isShowPicture;

@property (nonatomic, weak) id<SqureCellDelegate> delegate;

@property (nonatomic,strong)  NSArray *imageArray;

@property (nonatomic, copy) NSString * postDetail;

@end
