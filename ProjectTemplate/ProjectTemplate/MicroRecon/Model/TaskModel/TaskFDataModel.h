//
//  TaskFDataModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TaskFDataModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *workname;
@property (nonatomic, nonnull, copy) NSString *workid;
@property (nonatomic, nonnull, copy) NSString *dataid;


@end
