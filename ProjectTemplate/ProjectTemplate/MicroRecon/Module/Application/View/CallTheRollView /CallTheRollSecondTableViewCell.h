//
//  CallTheRollSecondTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallTheRollUserListModel;

@interface CallTheRollSecondTableViewCell : UITableViewCell

@property (nonatomic, weak) CallTheRollUserListModel *userListModel;

@property (nonatomic, assign) BOOL notreported; // 未报道

@end
