//
//  MessageBoardTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageBoardListModel;

@interface MessageBoardTableViewCell : UITableViewCell

@property (nonatomic, weak) MessageBoardListModel *model;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger row;

@end
