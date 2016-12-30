//
//  FindUserModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FindUserModel : MTLModel<MTLJSONSerializing>



@property (nonatomic, nonnull, copy) NSString *RE_alarmNum;
@property (nonatomic, nonnull, copy) NSString *RE_department;
@property (nonatomic, nonnull, copy) NSString *RE_headpic;
@property (nonatomic, nonnull, copy) NSString *RE_nickname;
@property (nonatomic, nonnull, copy) NSString *RE_phonenum;
@property (nonatomic, nonnull, copy) NSString *RE_useralarm;

@end
