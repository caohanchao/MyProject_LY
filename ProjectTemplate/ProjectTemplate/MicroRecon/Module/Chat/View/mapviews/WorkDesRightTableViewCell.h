//
//  WorkDesRightTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkAllTempModel.h"

@interface WorkDesRightTableViewCell : UITableViewCell


@property (nonatomic, weak) WorkAllTempModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthModel:(WorkAllTempModel *)model;


@end
