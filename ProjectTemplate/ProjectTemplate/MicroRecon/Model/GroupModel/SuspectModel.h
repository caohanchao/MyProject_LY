//
//  SuspectModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SuspectModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *workid;
@property (nonatomic, nonnull, copy) NSString *suspectname;

@end
