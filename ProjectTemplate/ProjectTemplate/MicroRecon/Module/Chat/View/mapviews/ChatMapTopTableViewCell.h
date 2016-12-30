//
//  ChatMapTopTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatMapTopTableViewCell;

@protocol ChatMapTopTableViewCellDelegate <NSObject>

- (void)chatMapTopTableViewCell:(ChatMapTopTableViewCell *)cell index:(NSInteger)index;

@end

@interface ChatMapTopTableViewCell : UITableViewCell

@property (nonatomic, weak) id model;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<ChatMapTopTableViewCellDelegate> delegate;
@end
