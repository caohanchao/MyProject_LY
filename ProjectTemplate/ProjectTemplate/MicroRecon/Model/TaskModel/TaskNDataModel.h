//
//  TaskNDataModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TaskNDataModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *workname;
@property (nonatomic, nonnull, copy) NSString *workid;
@property (nonatomic, nonnull, copy) NSString *dataid;
@property (nonatomic, nonnull, copy) NSString *content;
@property (nonatomic, nonnull, copy) NSString *picture;
@property (nonatomic, nonnull, copy) NSString *audio;
@property (nonatomic, nonnull, copy) NSString *type;
@property (nonatomic, nonnull, copy) NSString *video;
@property (nonatomic, nonnull, copy) NSString *title;

@property (nonatomic, nonnull, copy) NSString *markType;
@property (nonatomic, nonnull, copy) NSString *direction;

@end
