//
//  SuspectlistModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SuspectlistModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *create_time;
@property (nonatomic, nonnull, copy) NSString *createuser;
@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *gname;
@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic, nonnull, copy) NSString *suspectdec;
@property (nonatomic, nonnull, copy) NSString *suspectid;
@property (nonatomic, nonnull, copy) NSString *suspectname;
@property (nonatomic, nonnull, copy) NSString *suspecttype;
@property (nonatomic, nonnull, copy) NSString *username;


@end
