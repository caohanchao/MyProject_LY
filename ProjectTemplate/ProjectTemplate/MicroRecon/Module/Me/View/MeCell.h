//
//  MeCell.h
//  WWeChat
//
//  Created by WzxJiang on 16/6/28.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeCell;

@protocol MeCellDelegate <NSObject>

- (void)showTCode:(MeCell *)cell;

@end

@interface MeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avaterImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *wechatIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *show2Code;
@property (nonatomic, weak) id<MeCellDelegate> delegate;
@end
