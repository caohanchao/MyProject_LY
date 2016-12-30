//
//  HonourTableViewCell.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfoModel.h"

@interface HonourTableViewCell : UITableViewCell

@property(nonatomic,strong)PostInfoModel * model;

/**
 *	@brief	图像;
 */
@property (nonatomic, strong) UIImageView *iconImage;
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


@end
