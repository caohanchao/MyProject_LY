//
//  TeamsListModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TeamsListModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *admin;
@property (nonatomic, nonnull, copy) NSString *count;
@property (nonatomic, nonnull, copy) NSString *creattime;
@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *gname;
@property (nonatomic, nonnull, copy) NSString *type;

@property (nonatomic, nonnull, copy) NSString *memebers;//群成员alarm字符串

@property (nonatomic, nonnull, copy) NSString *isRemindSet;
@end
