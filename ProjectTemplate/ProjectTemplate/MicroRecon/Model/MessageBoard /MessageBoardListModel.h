//
//  MessageBoardListModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MessageBoardListModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *alarm;
@property (nonatomic, nonnull, copy) NSString *audio;
@property (nonatomic, nonnull, copy) NSString *content;
@property (nonatomic, nonnull, copy) NSString *head_pic;
@property (nonatomic, nonnull, copy) NSString *mark_id;
@property (nonatomic, nonnull, copy) NSString *name;
@property (nonatomic, nonnull, copy) NSString *picture;
@property (nonatomic, nonnull, copy) NSString *position;
@property (nonatomic, nonnull, copy) NSString *record_id;
@property (nonatomic, nonnull, copy) NSString *record_time;
@property (nonatomic, nonnull, copy) NSString *token;
@property (nonatomic, nonnull, copy) NSString *type;
@property (nonatomic, nonnull, copy) NSString *video;

@end
