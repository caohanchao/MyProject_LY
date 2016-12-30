//
//  ForwardCell.h
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamsListModel.h"
#import "FriendsListModel.h"

typedef NS_ENUM(NSInteger ,ModelType)
{
    IsTeamsListModelType = 0,
    IsFriendListModelType
};

@interface ForwardCell : UITableViewCell


@property(nonatomic,copy)TeamsListModel *tModel;

@property(nonatomic,copy)FriendsListModel *fModel;

//@property(nonatomic)ModelType modelType;

-(void)configDataSourceOfTModel:(TeamsListModel *)tModel FModel:(FriendsListModel*) fModel  andModelType:(ModelType)modelType;


@end
