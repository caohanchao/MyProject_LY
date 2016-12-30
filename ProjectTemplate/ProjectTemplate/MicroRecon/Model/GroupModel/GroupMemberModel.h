//
//  GroupMemberModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "ChatView.h"

@interface GroupMemberModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *headpic;
@property (nonatomic, nonnull, copy) NSString *ME_gid;
@property (nonatomic, nonnull, copy) NSString *ME_jointime;
@property (nonatomic, nonnull, copy) NSString *ME_nickname;
@property (nonatomic, nonnull, copy) NSNumber *ME_permission;
@property (nonatomic, nonnull, copy) NSNumber *ME_share;
@property (nonatomic, nonnull, copy) NSString *ME_uid;

@end
