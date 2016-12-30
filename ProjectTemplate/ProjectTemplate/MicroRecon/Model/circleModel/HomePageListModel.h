//
//  HomePageListModel.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull,copy) NSString *department;
@property (nonatomic, nonnull,copy) NSString *alarm;
@property (nonatomic, nonnull,copy) NSString *name;
@property (nonatomic, nonnull,copy) NSString *headpic;
@property (nonatomic, nonnull,copy) NSString* time;

@end
