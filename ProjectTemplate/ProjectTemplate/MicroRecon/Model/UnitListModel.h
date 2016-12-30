//
//  UnitListModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UnitListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, strong) NSArray *DE_mermber;

@property (nonatomic, nonnull, copy) NSString *DE_count;
@property (nonatomic, nonnull, copy) NSString *DE_level;
@property (nonatomic, nonnull, copy) NSString *DE_sjnumber;
@property (nonatomic, nonnull, copy) NSString *DE_name;
@property (nonatomic, nonnull, copy) NSString *DE_number;
@property (nonatomic, nonnull, copy) NSString *DE_describe1;
@property (nonatomic, nonnull, copy) NSString *DE_describe2;
@property (nonatomic, nonnull, copy) NSString *DE_type;//0警察公务组织，1技术支持

/**
 * 根据data获取 GroupInfoResponseModel 对象
 */
+ (nonnull instancetype) getInfoWithData:(nonnull NSDictionary *)data;

@end
