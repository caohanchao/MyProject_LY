//
//  SeePathNolineTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetPathModel.h"

@interface SeePathNolineTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) GetPathModel *model;

@end
