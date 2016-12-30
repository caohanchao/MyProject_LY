//
//  GetorgbyregisterModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GetorgbyregisterModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptions;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parent_id;

/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId : (NSString *)descriptions Id : (NSString *)Id name : (NSString *)name parent_id : (NSString *)parent_id;

@end
