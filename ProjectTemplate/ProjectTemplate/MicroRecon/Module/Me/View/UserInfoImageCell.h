//
//  UserInfoImageCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoImageCell;
@protocol UserInfoImageCellDelegate <NSObject>

- (void)userInfoImageCell:(UserInfoImageCell *)cell imageView:(UIImageView *)view;

@end


@interface UserInfoImageCell : UITableViewCell

@property (nonatomic, weak) id<UserInfoImageCellDelegate> delegate;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *imageStr;
@end
