//
//  WorkListsCollectionViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuspectlistModel.h"

@interface WorkListsCollectionViewCell : UICollectionViewCell

/**
 *  背景图片
 */
@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) SuspectlistModel *model;

@end
