//
//  VdDesHaveImageCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VdDesHaveImageCell : UITableViewCell


/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 图片
 */
@property (nonatomic, strong) UIScrollView *imageScrollView;
@end
