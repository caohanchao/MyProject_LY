//
//  SuspectSDataModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SuspectSDataModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *gid;
@property (nonatomic, nonnull, copy) NSString *suspectid;
@property (nonatomic, nonnull, copy) NSString *name;
@property (nonatomic, nonnull, copy) NSString *suspectname;
@end
