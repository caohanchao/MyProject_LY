//
//  CommentTableViewCell.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

@property(nonatomic,strong)CommentModel * model;

/**
 *	@brief	图像;
 */
@property (nonatomic, strong) UIImageView *iconImage;

/**
 *	@brief	点击图像;
 */
@property (nonatomic, strong) UIButton *iconImageBtn;
/**
 *	@brief	点击姓名信息;
 */
@property (nonatomic, strong) UIButton *userInfoBtn;

// 用户信息回调
@property (nonatomic, copy) void(^userInfoBlock)();

/**
 *	@brief	身份;
 */
@property (nonatomic, strong) UILabel *identitylabel;
@property (nonatomic, strong) UIImageView *identityImg;
/**
 *	@brief	姓名;
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 *	@brief	哪家派出所;
 */
@property (nonatomic, strong) UILabel *fromLabel;
/**
 *	@brief	时间;
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 *	@brief	评论内容;
 */
@property (nonatomic, strong) UILabel *contentLabel;

@end
